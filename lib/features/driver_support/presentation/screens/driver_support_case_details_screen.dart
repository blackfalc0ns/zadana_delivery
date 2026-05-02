import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:zadana_delivery/config/routing/routing_extensions.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/errors/error_presentation.dart';
import 'package:zadana_delivery/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_delivery/core/errors/error_widgets/skeleton_state_widget.dart';
import 'package:zadana_delivery/core/widgets/app_button.dart';
import 'package:zadana_delivery/core/widgets/custom_app_bar.dart';
import 'package:zadana_delivery/core/widgets/custom_snack_bar.dart';
import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_case_entity.dart';
import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_case_message_request_entity.dart';
import 'package:zadana_delivery/features/driver_support/presentation/manager/driver_support_cubit.dart';
import 'package:zadana_delivery/features/driver_support/presentation/manager/driver_support_event.dart';
import 'package:zadana_delivery/features/driver_support/presentation/manager/driver_support_state.dart';

class DriverSupportCaseDetailsScreen extends StatefulWidget {
  const DriverSupportCaseDetailsScreen({super.key, required this.initialCase});

  final DriverSupportCaseEntity initialCase;

  @override
  State<DriverSupportCaseDetailsScreen> createState() =>
      _DriverSupportCaseDetailsScreenState();
}

class _DriverSupportCaseDetailsScreenState
    extends State<DriverSupportCaseDetailsScreen> {
  late final DriverSupportCubit _cubit;
  late final TextEditingController _messageController;
  String _selectedReasonCode = 'follow_up';

  bool get _isArabic => Localizations.localeOf(context).languageCode == 'ar';

  static const List<_ReasonOption> _followUpReasons = [
    _ReasonOption(
      code: 'follow_up',
      labelAr: 'متابعة عامة',
      labelEn: 'General follow-up',
    ),
    _ReasonOption(
      code: 'additional_info',
      labelAr: 'إضافة تفاصيل',
      labelEn: 'Additional info',
    ),
    _ReasonOption(
      code: 'proof_submitted',
      labelAr: 'إرسال إثبات',
      labelEn: 'Proof submitted',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _cubit = getIt<DriverSupportCubit>();
    _messageController = TextEditingController();
    unawaited(
      _cubit.doIntent(DriverSupportLoadCaseDetailsEvent(widget.initialCase.id)),
    );
  }

  @override
  void dispose() {
    _cubit.close();
    _messageController.dispose();
    super.dispose();
  }

  String _text(String ar, String en) => _isArabic ? ar : en;

  String _reasonLabel(_ReasonOption option) =>
      _isArabic ? option.labelAr : option.labelEn;

  Future<void> _sendMessage(DriverSupportCaseEntity item) async {
    final message = _messageController.text.trim();
    final reasonCode = _selectedReasonCode.trim();
    if (message.isEmpty || reasonCode.isEmpty) {
      CustomSnackbar.showError(
        context: context,
        message: _text(
          'اختار سبب المتابعة واكتب الرسالة',
          'Choose a follow-up reason and enter a message',
        ),
      );
      return;
    }

    final success = await _cubit.doIntent(
      DriverSupportSendMessageEvent(
        orderId: item.orderId,
        caseId: item.id,
        request: DriverSupportCaseMessageRequestEntity(
          reasonCode: reasonCode,
          message: message,
        ),
      ),
    );
    if (!mounted || !success) return;
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<DriverSupportCubit, DriverSupportState>(
        listenWhen: (previous, current) =>
            previous.failure != current.failure ||
            previous.successMessage != current.successMessage,
        listener: (context, state) {
          final successMessage = state.successMessage?.trim() ?? '';
          if (successMessage.isNotEmpty) {
            CustomSnackbar.showSuccess(
              context: context,
              message: successMessage,
            );
            unawaited(
              _cubit.doIntent(const DriverSupportConsumeSuccessEvent()),
            );
          }

          final exception = state.failure?.asException;
          if (exception == null || !exception.errorType.showSnackBar) return;
          CustomSnackbar.showError(
            context: context,
            message: ErrorMessagePresenter.snackBarMessage(context, exception),
          );
        },
        builder: (context, state) {
          final item = state.selectedCase ?? widget.initialCase;
          final exception = state.failure?.asException;

          if (state.isLoading && state.selectedCase == null) {
            return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.surface,
              appBar: CustomAppBar.modern(
                title: _text('تفاصيل الشكوى', 'Case details'),
                onBackPressed: context.pop,
              ),
              body: const _DriverSupportCaseDetailsLoadingView(),
            );
          }

          if (!state.isLoading &&
              exception != null &&
              exception.errorType.showFullScreen &&
              state.selectedCase == null) {
            return Scaffold(
              appBar: CustomAppBar.modern(
                title: _text('تفاصيل الشكوى', 'Case details'),
                onBackPressed: context.pop,
              ),
              body: ApiErrorWidget(
                exception: exception,
                onRetry: () => _cubit.doIntent(
                  DriverSupportLoadCaseDetailsEvent(widget.initialCase.id),
                ),
                onGoBack: context.pop,
              ),
            );
          }

          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            appBar: CustomAppBar.modern(
              title: _text('تفاصيل الشكوى', 'Case details'),
              onBackPressed: context.pop,
            ),
            body: RefreshIndicator(
              onRefresh: () => _cubit.doIntent(
                DriverSupportLoadCaseDetailsEvent(item.id, refresh: true),
              ),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 22),
                children: [
                  _CaseDetailsHero(item: item, isArabic: _isArabic),
                  const SizedBox(height: 10),
                  _SectionCard(
                    title: _text('الوصف', 'Description'),
                    icon: Icons.description_outlined,
                    child: Text(
                      item.message.trim().isEmpty ? '--' : item.message.trim(),
                    ),
                  ),
                  if ((item.adminNote ?? '').trim().isNotEmpty) ...[
                    const SizedBox(height: 10),
                    _SectionCard(
                      title: _text('ملاحظة الإدارة', 'Admin note'),
                      icon: Icons.campaign_outlined,
                      child: Text(item.adminNote!.trim()),
                    ),
                  ],
                  if ((item.decisionNotes ?? '').trim().isNotEmpty) ...[
                    const SizedBox(height: 10),
                    _SectionCard(
                      title: _text('ملاحظات القرار', 'Decision notes'),
                      icon: Icons.rule_folder_outlined,
                      child: Text(item.decisionNotes!.trim()),
                    ),
                  ],
                  if (item.activities.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    _SectionCard(
                      title: _text('آخر النشاطات', 'Recent activity'),
                      icon: Icons.timeline_rounded,
                      child: Column(
                        children: item.activities
                            .map(
                              (activity) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: _ActivityTile(
                                  isArabic: _isArabic,
                                  message: activity.message,
                                  dateTime: activity.createdAt,
                                ),
                              ),
                            )
                            .toList(growable: false),
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  _SectionCard(
                    title: _text('إضافة متابعة', 'Add follow-up'),
                    icon: Icons.reply_all_rounded,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        DropdownButtonFormField<String>(
                          initialValue: _selectedReasonCode,
                          borderRadius: BorderRadius.circular(18),
                          decoration: InputDecoration(
                            labelText: _text('سبب المتابعة', 'Follow-up reason'),
                            filled: true,
                          ),
                          items: _followUpReasons
                              .map(
                                (reason) => DropdownMenuItem<String>(
                                  value: reason.code,
                                  child: Text(_reasonLabel(reason)),
                                ),
                              )
                              .toList(growable: false),
                          onChanged: state.isMessageSending
                              ? null
                              : (value) {
                                  setState(() {
                                    _selectedReasonCode =
                                        value ?? _selectedReasonCode;
                                  });
                                },
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _messageController,
                          maxLines: 4,
                          textInputAction: TextInputAction.newline,
                          decoration: InputDecoration(
                            labelText: _text('الرسالة', 'Message'),
                            alignLabelWithHint: true,
                            hintText: _text(
                              'اكتب أي تفاصيل جديدة أو توضيح إضافي',
                              'Add any new details or clarification',
                            ),
                            filled: true,
                          ),
                        ),
                        const SizedBox(height: 12),
                        AppButton.filled(
                          text: _text('إرسال المتابعة', 'Send follow-up'),
                          isLoading: state.isMessageSending,
                          onPressed: () => _sendMessage(item),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ReasonOption {
  const _ReasonOption({
    required this.code,
    required this.labelAr,
    required this.labelEn,
  });

  final String code;
  final String labelAr;
  final String labelEn;
}

class _CaseDetailsHero extends StatelessWidget {
  const _CaseDetailsHero({required this.item, required this.isArabic});

  final DriverSupportCaseEntity item;
  final bool isArabic;

  String _text(String ar, String en) => isArabic ? ar : en;

  String _formatDate(DateTime? value) {
    if (value == null) return '--';
    return DateFormat('dd/MM/yyyy - hh:mm a').format(value.toLocal());
  }

  String _labelize(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) return '--';
    return normalized
        .replaceAll('_', ' ')
        .replaceAllMapped(
          RegExp(r'([a-z])([A-Z])'),
          (match) => '${match.group(1)} ${match.group(2)}',
        );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final title = item.orderNumber.isEmpty ? item.id : item.orderNumber;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            scheme.primary.withValues(alpha: 0.03),
            scheme.tertiary.withValues(alpha: 0.012),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 22,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _HeroPill(
                icon: Icons.priority_high_rounded,
                label: _labelize(item.priority),
                color: scheme.secondary,
              ),
              _HeroPill(
                icon: Icons.flag_rounded,
                label: _labelize(item.status),
                color: scheme.primary,
              ),
              _HeroPill(
                icon: Icons.balance_rounded,
                label: _labelize(item.type),
                color: scheme.tertiary,
              ),
            ],
          ),
          const SizedBox(height: 10),
          _HeroInfoLine(
            label: _text('السبب', 'Reason'),
            value: _formatDate(item.createdAt),
          ),
          const SizedBox(height: 8),
          _HeroInfoLine(
            label: _text('آخر تحديث', 'Last update'),
            value: _formatDate(item.updatedAt ?? item.createdAt),
          ),
          if ((item.queue ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            _HeroInfoLine(
              label: _text('القسم', 'Queue'),
              value: item.queue!.trim(),
            ),
          ],
        ],
      ),
    );
  }
}

class _HeroPill extends StatelessWidget {
  const _HeroPill({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroInfoLine extends StatelessWidget {
  const _HeroInfoLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: scheme.surface.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: scheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: scheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.14),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: scheme.primary, size: 16),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({
    required this.isArabic,
    required this.message,
    required this.dateTime,
  });

  final bool isArabic;
  final String message;
  final DateTime? dateTime;

  String _formatDate(DateTime? value) {
    if (value == null) return '--';
    return DateFormat('dd/MM/yyyy - hh:mm a').format(value.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              color: scheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.trim().isEmpty ? '--' : message.trim(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.3,
                    fontSize: 13.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(dateTime),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DriverSupportCaseDetailsLoadingView extends StatelessWidget {
  const _DriverSupportCaseDetailsLoadingView();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SkeletonStateWidget(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 22),
        children: [
          _SkeletonBox(
            height: 158,
            borderRadius: 22,
            color: scheme.outlineVariant.withValues(alpha: 0.16),
          ),
          const SizedBox(height: 10),
          _SkeletonBox(
            height: 104,
            borderRadius: 22,
            color: scheme.outlineVariant.withValues(alpha: 0.12),
          ),
          const SizedBox(height: 10),
          _SkeletonBox(
            height: 128,
            borderRadius: 22,
            color: scheme.outlineVariant.withValues(alpha: 0.12),
          ),
          const SizedBox(height: 10),
          _SkeletonBox(
            height: 198,
            borderRadius: 22,
            color: scheme.outlineVariant.withValues(alpha: 0.12),
          ),
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    required this.height,
    required this.borderRadius,
    required this.color,
  });

  final double height;
  final double borderRadius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
