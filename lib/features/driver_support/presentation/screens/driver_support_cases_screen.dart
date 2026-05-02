import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/config/routing/routing_extensions.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/errors/error_presentation.dart';
import 'package:zadana_delivery/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_delivery/core/errors/error_widgets/skeleton_state_widget.dart';
import 'package:zadana_delivery/core/widgets/custom_app_bar.dart';
import 'package:zadana_delivery/core/widgets/custom_snack_bar.dart';
import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_case_entity.dart';
import 'package:zadana_delivery/features/driver_support/presentation/manager/driver_support_cubit.dart';
import 'package:zadana_delivery/features/driver_support/presentation/manager/driver_support_event.dart';
import 'package:zadana_delivery/features/driver_support/presentation/manager/driver_support_state.dart';

class DriverSupportCasesScreen extends StatefulWidget {
  const DriverSupportCasesScreen({super.key});

  @override
  State<DriverSupportCasesScreen> createState() =>
      _DriverSupportCasesScreenState();
}

class _DriverSupportCasesScreenState extends State<DriverSupportCasesScreen> {
  late final DriverSupportCubit _cubit;

  bool get _isArabic => Localizations.localeOf(context).languageCode == 'ar';

  @override
  void initState() {
    super.initState();
    _cubit = getIt<DriverSupportCubit>();
    unawaited(_cubit.doIntent(const DriverSupportLoadCasesEvent()));
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  String _text(String ar, String en) => _isArabic ? ar : en;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<DriverSupportCubit, DriverSupportState>(
        listenWhen: (previous, current) => previous.failure != current.failure,
        listener: (context, state) {
          final exception = state.failure?.asException;
          if (exception == null || !exception.errorType.showSnackBar) return;
          CustomSnackbar.showError(
            context: context,
            message: ErrorMessagePresenter.snackBarMessage(context, exception),
          );
        },
        builder: (context, state) {
          final exception = state.failure?.asException;
          final items = state.cases?.items ?? const <DriverSupportCaseEntity>[];

          if (state.isLoading && items.isEmpty) {
            return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.surface,
              appBar: CustomAppBar.modern(
                title: _text('الشكاوى والنزاعات', 'My cases'),
                onBackPressed: context.pop,
              ),
              body: const _DriverSupportCasesLoadingView(),
            );
          }

          if (!state.isLoading &&
              items.isEmpty &&
              exception != null &&
              exception.errorType.showFullScreen) {
            return Scaffold(
              appBar: CustomAppBar.modern(
                title: _text('الشكاوى والنزاعات', 'My cases'),
                onBackPressed: context.pop,
              ),
              body: ApiErrorWidget(
                exception: exception,
                onRetry: () =>
                    _cubit.doIntent(const DriverSupportLoadCasesEvent()),
                onGoBack: context.pop,
              ),
            );
          }

          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            appBar: CustomAppBar.modern(
              title: _text('الشكاوى والنزاعات', 'My cases'),
              onBackPressed: context.pop,
            ),
            body: RefreshIndicator(
              onRefresh: () => _cubit.doIntent(
                const DriverSupportLoadCasesEvent(refresh: true),
              ),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                children: [
                  _CasesHero(
                    title: _text(
                      'كل شكاواك في مكان واحد',
                      'All your cases in one place',
                    ),
                    subtitle: _text(
                      'راجع آخر التحديثات بسرعة.',
                      'Review the latest updates quickly.',
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (items.isEmpty)
                    _EmptyState(
                      title: _text(
                        'لا توجد شكاوى أو نزاعات حتى الآن',
                        'No cases yet',
                      ),
                      subtitle: _text(
                        'أي شكوى أو نزاع ترسله من الطلب سيظهر هنا مباشرة.',
                        'Any issue or dispute you create from an order will appear here.',
                      ),
                    )
                  else
                    ...items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _CaseCard(
                          item: item,
                          isArabic: _isArabic,
                          onTap: () => Navigator.of(context).pushNamed(
                            AppRoutes.driverSupportCaseDetails,
                            arguments: item,
                          ),
                        ),
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

class _CasesHero extends StatelessWidget {
  const _CasesHero({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            scheme.primary.withValues(alpha: 0.045),
            scheme.secondary.withValues(alpha: 0.025),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.16)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: scheme.primary.withValues(alpha: 0.08),
              ),
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              color: scheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.35,
                    fontSize: 12,
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

class _CaseCard extends StatelessWidget {
  const _CaseCard({
    required this.item,
    required this.isArabic,
    required this.onTap,
  });

  final DriverSupportCaseEntity item;
  final bool isArabic;
  final VoidCallback onTap;

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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: scheme.outlineVariant.withValues(alpha: 0.14),
            ),
            boxShadow: [
              BoxShadow(
                color: scheme.shadow.withValues(alpha: 0.025),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
              
                children: [
                  // Icon(
                  //   isArabic
                  //       ? Icons.arrow_back_ios_new_rounded
                  //       : Icons.arrow_forward_ios_rounded,
                  //   size: 14,
                  //   color: scheme.onSurfaceVariant,
                  // ),
                  // const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                fontSize: 20,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            _MetaPill(
                              icon: Icons.flag_rounded,
                              label: _labelize(item.status),
                              foreground: scheme.primary,
                              background: scheme.primary.withValues(alpha: 0.08),
                            ),
                            _MetaPill(
                              icon: Icons.balance_rounded,
                              label: _labelize(item.type),
                              foreground: scheme.secondary,
                              background: scheme.secondary.withValues(alpha: 0.08),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.schedule_rounded,
                    size: 13,
                    color: scheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      _formatDate(item.updatedAt ?? item.createdAt),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: scheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({
    required this.icon,
    required this.label,
    required this.foreground,
    required this.background,
  });

  final IconData icon;
  final String label;
  final Color foreground;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: foreground),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.22),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Icon(Icons.mark_email_unread_outlined, color: scheme.primary),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _DriverSupportCasesLoadingView extends StatelessWidget {
  const _DriverSupportCasesLoadingView();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SkeletonStateWidget(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          _SkeletonBox(
            height: 118,
            borderRadius: 28,
            color: scheme.outlineVariant.withValues(alpha: 0.16),
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < 4; i++) ...[
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: scheme.outlineVariant.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _SkeletonBox(
                          height: 20,
                          borderRadius: 12,
                          color: scheme.surface,
                        ),
                      ),
                      const SizedBox(width: 12),
                      _SkeletonBox(
                        width: 84,
                        height: 30,
                        borderRadius: 999,
                        color: scheme.surface,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _SkeletonBox(
                    height: 72,
                    borderRadius: 20,
                    color: scheme.surface,
                  ),
                  const SizedBox(height: 12),
                  _SkeletonBox(
                    width: 170,
                    height: 14,
                    borderRadius: 10,
                    color: scheme.surface,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    this.width = double.infinity,
    required this.height,
    required this.borderRadius,
    required this.color,
  });

  final double width;
  final double height;
  final double borderRadius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
