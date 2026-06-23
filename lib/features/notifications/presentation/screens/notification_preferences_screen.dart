import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_delivery/config/routing/routing_extensions.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/errors/error_widgets/skeleton_state_widget.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/services/notification_sound_preferences_service.dart';
import 'package:zadana_delivery/core/services/trip_request_overlay_service.dart';
import 'package:zadana_delivery/core/widgets/custom_app_bar.dart';
import 'package:zadana_delivery/core/widgets/custom_progress_indicator.dart';
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
  final AudioPlayer _audioPlayer = AudioPlayer();
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
    _audioPlayer.dispose();
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
      'classic';

  /// Returns the sound for a specific category from the server preferences.
  String _getCategorySound(String category) {
    final prefs = _viewModel.state.preferences;
    if (prefs == null) return 'classic';
    final sounds = prefs['notificationSounds'];
    if (sounds is Map) {
      final value = sounds[category]?.toString().trim().toLowerCase() ?? '';
      if (NotificationSoundValues.all.contains(value)) return value;
    }
    // Fallback to the global default
    return prefs['notificationSound']?.toString() ?? 'classic';
  }

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

  Future<void> _changeCategorySound(String category, String sound) async {
    final body = <String, dynamic>{
      'notificationSounds': {category: sound},
    };
    await _updateAndNotify(body);
  }

  Future<void> _previewSound(String soundKey) async {
    if (soundKey == 'off') return;
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(
        AssetSource('sounds/$soundKey.wav'),
      );
    } catch (e) {
      debugPrint('[NotificationPreferences] Audio preview failed: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isArabic
                ? 'تعذّر تشغيل النغمة'
                : 'Could not play sound',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
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
                ? const _PreferencesLoadingSkeleton()
                : Stack(
                    children: [
                      ListView(
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

                      // ── Per-category sound selection ──
                      _buildSectionCard(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(16, 12, 16, 4),
                            child: Text(
                              _isArabic
                                  ? 'أصوات الإشعارات'
                                  : 'Notification Sounds',
                              style: getSemiBoldStyle(
                                fontFamily: FontConstant.cairo,
                                fontSize: FontSize.size15,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(16, 0, 16, 8),
                            child: Text(
                              _isArabic
                                  ? 'اختر نغمة مختلفة لكل فئة'
                                  : 'Choose a different tone for each category',
                              style: getRegularStyle(
                                fontFamily: FontConstant.cairo,
                                fontSize: FontSize.size13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          _buildSoundDropdown(
                            label: _isArabic ? 'النغمة الافتراضية' : 'Default Sound',
                            currentValue: _currentSound,
                            isLoading: isLoading,
                            onChanged: _changeSound,
                          ),
                          const Divider(height: 1, indent: 16, endIndent: 16),
                          _buildSoundDropdown(
                            label: _isArabic ? 'عروض التوصيل' : 'Dispatch',
                            currentValue: _getCategorySound('dispatch'),
                            isLoading: isLoading,
                            onChanged: (v) => _changeCategorySound('dispatch', v),
                          ),
                          const Divider(height: 1, indent: 16, endIndent: 16),
                          _buildSoundDropdown(
                            label: _isArabic ? 'الطلبات المسندة' : 'Assignment',
                            currentValue: _getCategorySound('assignment'),
                            isLoading: isLoading,
                            onChanged: (v) => _changeCategorySound('assignment', v),
                          ),
                          const Divider(height: 1, indent: 16, endIndent: 16),
                          _buildSoundDropdown(
                            label: _isArabic ? 'الدعم الفني' : 'Support',
                            currentValue: _getCategorySound('support'),
                            isLoading: isLoading,
                            onChanged: (v) => _changeCategorySound('support', v),
                          ),
                          const Divider(height: 1, indent: 16, endIndent: 16),
                          _buildSoundDropdown(
                            label: _isArabic ? 'المحفظة' : 'Wallet',
                            currentValue: _getCategorySound('wallet'),
                            isLoading: isLoading,
                            onChanged: (v) => _changeCategorySound('wallet', v),
                          ),
                          const Divider(height: 1, indent: 16, endIndent: 16),
                          _buildSoundDropdown(
                            label: _isArabic ? 'الحساب' : 'Account',
                            currentValue: _getCategorySound('account'),
                            isLoading: isLoading,
                            onChanged: (v) => _changeCategorySound('account', v),
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
                      if (isLoading)
                        Positioned.fill(
                          child: ColoredBox(
                            color: Colors.white.withValues(alpha: 0.5),
                            child: const CustomProgressIndicator(),
                          ),
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

  Widget _buildSoundDropdown({
    required String label,
    required String currentValue,
    required bool isLoading,
    required ValueChanged<String> onChanged,
  }) {
    const soundOptions = [
      ('classic', 'كلاسيكي', 'Classic'),
      ('chime', 'رنين', 'Chime'),
      ('soft', 'هادئ', 'Soft'),
      ('urgent', 'عاجل', 'Urgent'),
      ('off', 'بدون صوت', 'Off'),
    ];

    final effectiveValue = NotificationSoundValues.all.contains(currentValue)
        ? currentValue
        : 'classic';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: getRegularStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size14,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          if (effectiveValue != 'off')
            IconButton(
              icon: const Icon(Icons.play_circle_outline, size: 22),
              color: AppColors.primary,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              tooltip: _isArabic ? 'تشغيل' : 'Preview',
              onPressed: () => _previewSound(effectiveValue),
            ),
          const SizedBox(width: 4),
          DropdownButton<String>(
            value: effectiveValue,
            underline: const SizedBox.shrink(),
            isDense: true,
            style: getRegularStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size13,
              color: AppColors.primary,
            ),
            onChanged: isLoading
                ? null
                : (value) {
                    if (value != null) onChanged(value);
                  },
            items: soundOptions.map((option) {
              final (value, arLabel, enLabel) = option;
              return DropdownMenuItem<String>(
                value: value,
                child: Text(_isArabic ? arLabel : enLabel),
              );
            }).toList(growable: false),
          ),
        ],
      ),
    );
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
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}

class _PreferencesLoadingSkeleton extends StatelessWidget {
  const _PreferencesLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return SkeletonStateWidget(
      child: ListView(
        padding: const EdgeInsets.all(16),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // Master toggle section
          _buildSkeletonSection(1),
          const SizedBox(height: 16),
          // Per-category toggles section (5 switches)
          _buildSkeletonSection(5),
          const SizedBox(height: 16),
          // Sound section
          _buildSkeletonSection(4, isRadio: true),
          const SizedBox(height: 16),
          // Overlay section
          _buildSkeletonSection(1),
        ],
      ),
    );
  }

  Widget _buildSkeletonSection(int itemCount, {bool isRadio = false}) {
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
        children: List.generate(itemCount, (index) {
          return Column(
            children: [
              if (index > 0)
                const Divider(height: 1, indent: 16, endIndent: 16),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: isRadio ? 80 : 160,
                            height: 14,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8ECF0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          if (!isRadio) ...[
                            const SizedBox(height: 8),
                            Container(
                              width: 200,
                              height: 11,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0F3F6),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: isRadio ? 22 : 44,
                      height: 22,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8ECF0),
                        borderRadius: BorderRadius.circular(isRadio ? 11 : 14),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
