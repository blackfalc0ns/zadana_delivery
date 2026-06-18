import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_delivery/config/routing/routing_extensions.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/services/trip_request_overlay_service.dart';
import 'package:zadana_delivery/core/widgets/custom_app_bar.dart';
import 'package:zadana_delivery/core/widgets/custom_snack_bar.dart';
import 'package:zadana_delivery/features/notifications/presentation/manager/notifications_state.dart';
import 'package:zadana_delivery/features/notifications/presentation/manager/notifications_view_model.dart';

class NotificationPreferencesScreen extends StatefulWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  State<NotificationPreferencesScreen> createState() =>
      _NotificationPreferencesScreenState();
}

class _NotificationPreferencesScreenState
    extends State<NotificationPreferencesScreen> with WidgetsBindingObserver {
  late final NotificationsViewModel _viewModel;
  late final TripRequestOverlayService _overlayService;
  bool _hasOverlayPermission = false;

  bool get _isArabic => Localizations.localeOf(context).languageCode == 'ar';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _viewModel = getIt<NotificationsViewModel>()..loadPreferences();
    _overlayService = getIt<TripRequestOverlayService>();
    _checkOverlayPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _viewModel.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkOverlayPermission();
    }
  }

  Future<void> _checkOverlayPermission() async {
    final granted = await _overlayService.hasPermission();
    if (mounted && granted != _hasOverlayPermission) {
      setState(() => _hasOverlayPermission = granted);
    }
  }

  Future<void> _onOverlaySwitchTapped(bool value) async {
    await _overlayService.requestPermission();
  }

  // ─── Preference Getters ───────────────────────────────────────────────

  bool _getBool(String key) =>
      _viewModel.state.preferences?[key] == true;

  String get _currentSound =>
      _viewModel.state.preferences?['notificationSound']?.toString() ??
      'default';

  // ─── Update Helpers ───────────────────────────────────────────────────

  Future<void> _toggleAllNotifications(bool enabled) async {
    final body = <String, dynamic>{
      'notificationsEnabled': enabled,
      'dispatchPushEnabled': enabled,
      'assignmentPushEnabled': enabled,
      'supportPushEnabled': enabled,
      'walletPushEnabled': enabled,
      'accountPushEnabled': enabled,
      'notificationSound': _currentSound,
    };
    await _updateAndNotify(body);
  }

  Future<void> _togglePreference(String key, bool value) async {
    final body = <String, dynamic>{key: value};
    await _updateAndNotify(body);
  }

  Future<void> _changeSound(String sound) async {
    final body = <String, dynamic>{'notificationSound': sound};
    await _updateAndNotify(body);
  }

  Future<void> _updateAndNotify(Map<String, dynamic> body) async {
    final success = await _viewModel.updatePreferences(body);
    if (!mounted) return;
    if (success) {
      CustomSnackbar.showSuccess(
        context: context,
        message: _isArabic ? 'تم تحديث الإعدادات' : 'Preferences updated',
      );
    }
  }

  // ─── Build ────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _viewModel,
      child: BlocBuilder<NotificationsViewModel, NotificationsState>(
        builder: (context, state) {
          final isLoading = state.isPreferencesLoading;

          return Scaffold(
            backgroundColor: context.colorScheme.surface,
            appBar: CustomAppBar.modern(
              title:
                  _isArabic ? 'إعدادات الإشعارات' : 'Notification Settings',
              onBackPressed: context.pop,
            ),
            body: isLoading && state.preferences == null
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // ── Master toggle ──
                      _buildSectionCard(
                        children: [
                          _buildSwitch(
                            title: _isArabic
                                ? 'تفعيل الإشعارات'
                                : 'Push Notifications',
                            subtitle: _isArabic
                                ? 'تشغيل أو إيقاف كل الإشعارات'
                                : 'Enable or disable all notifications',
                            value: _getBool('notificationsEnabled'),
                            onChanged: isLoading
                                ? null
                                : _toggleAllNotifications,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // ── Per-category toggles ──
                      _buildSectionCard(
                        children: [
                          _buildSwitch(
                            title: _isArabic
                                ? 'إشعارات العروض والديسباتش'
                                : 'Dispatch Notifications',
                            subtitle: _isArabic
                                ? 'عروض التوصيل والديسباتش'
                                : 'Delivery offers and dispatch',
                            value: _getBool('dispatchPushEnabled'),
                            onChanged: isLoading
                                ? null
                                : (v) => _togglePreference(
                                      'dispatchPushEnabled',
                                      v,
                                    ),
                          ),
                          const Divider(height: 1),
                          _buildSwitch(
                            title: _isArabic
                                ? 'إشعارات الطلبات المسندة'
                                : 'Assignment Notifications',
                            subtitle: _isArabic
                                ? 'تحديثات الطلبات المسندة إليك'
                                : 'Updates on orders assigned to you',
                            value: _getBool('assignmentPushEnabled'),
                            onChanged: isLoading
                                ? null
                                : (v) => _togglePreference(
                                      'assignmentPushEnabled',
                                      v,
                                    ),
                          ),
                          const Divider(height: 1),
                          _buildSwitch(
                            title: _isArabic
                                ? 'إشعارات الدعم والنزاعات'
                                : 'Support Notifications',
                            subtitle: _isArabic
                                ? 'الدعم والنزاعات والاسترجاع'
                                : 'Support, disputes and refunds',
                            value: _getBool('supportPushEnabled'),
                            onChanged: isLoading
                                ? null
                                : (v) => _togglePreference(
                                      'supportPushEnabled',
                                      v,
                                    ),
                          ),
                          const Divider(height: 1),
                          _buildSwitch(
                            title: _isArabic
                                ? 'إشعارات المحفظة'
                                : 'Wallet Notifications',
                            subtitle: _isArabic
                                ? 'المحفظة والسحب'
                                : 'Wallet and withdrawals',
                            value: _getBool('walletPushEnabled'),
                            onChanged: isLoading
                                ? null
                                : (v) => _togglePreference(
                                      'walletPushEnabled',
                                      v,
                                    ),
                          ),
                          const Divider(height: 1),
                          _buildSwitch(
                            title: _isArabic
                                ? 'إشعارات الحساب'
                                : 'Account Notifications',
                            subtitle: _isArabic
                                ? 'المراجعات والحظر وفك الحظر'
                                : 'Reviews, bans and unbans',
                            value: _getBool('accountPushEnabled'),
                            onChanged: isLoading
                                ? null
                                : (v) => _togglePreference(
                                      'accountPushEnabled',
                                      v,
                                    ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // ── Sound selection ──
                      _buildSectionCard(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(16, 12, 16, 8),
                            child: Text(
                              _isArabic
                                  ? 'صوت الإشعار'
                                  : 'Notification Sound',
                              style: getSemiBoldStyle(
                                fontFamily: FontConstant.cairo,
                                fontSize: FontSize.size15,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          ..._buildSoundOptions(
                            _currentSound,
                            isLoading,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // ── Overlay permission ──
                      _buildSectionCard(
                        children: [
                          SwitchListTile(
                            title: Text(
                              _isArabic
                                  ? 'الظهور فوق التطبيقات'
                                  : 'Display Over Other Apps',
                              style: getSemiBoldStyle(
                                fontFamily: FontConstant.cairo,
                                fontSize: FontSize.size15,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            subtitle: Text(
                              _isArabic
                                  ? 'عرض طلبات التوصيل فوق التطبيقات الأخرى'
                                  : 'Show delivery offers above other apps',
                              style: getRegularStyle(
                                fontFamily: FontConstant.cairo,
                                fontSize: FontSize.size13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            value: _hasOverlayPermission,
                            onChanged: _onOverlaySwitchTapped,
                            activeThumbColor: AppColors.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }

  // ─── Widgets ──────────────────────────────────────────────────────────

  Widget _buildSwitch({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool>? onChanged,
  }) {
    return SwitchListTile(
      title: Text(
        title,
        style: getSemiBoldStyle(
          fontFamily: FontConstant.cairo,
          fontSize: FontSize.size15,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: getRegularStyle(
          fontFamily: FontConstant.cairo,
          fontSize: FontSize.size13,
          color: AppColors.textSecondary,
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppColors.primary,
    );
  }

  List<Widget> _buildSoundOptions(String currentSound, bool isLoading) {
    const options = [
      ('default', 'افتراضي', 'Default'),
      ('chime', 'رنين', 'Chime'),
      ('alert', 'تنبيه', 'Alert'),
      ('silent', 'صامت', 'Silent'),
    ];

    return [
      RadioGroup<String>(
        groupValue: currentSound,
        onChanged: (String? newValue) {
          if (!isLoading && newValue != null) _changeSound(newValue);
        },
        child: Column(
          children: options.map((option) {
            final (value, arLabel, enLabel) = option;
            return RadioListTile<String>(
              title: Text(
                _isArabic ? arLabel : enLabel,
                style: getRegularStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size14,
                  color: AppColors.textPrimary,
                ),
              ),
              value: value,
              activeColor: AppColors.primary,
              dense: true,
            );
          }).toList(growable: false),
        ),
      ),
    ];
  }

  Widget _buildSectionCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
