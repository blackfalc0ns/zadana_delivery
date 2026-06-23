import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/errors/error_presentation.dart';
import 'package:zadana_delivery/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_delivery/core/errors/error_widgets/empty_state_widget.dart';
import 'package:zadana_delivery/core/errors/error_widgets/skeleton_state_widget.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/custom_app_bar.dart';
import 'package:zadana_delivery/core/widgets/custom_progress_indicator.dart';
import 'package:zadana_delivery/core/widgets/custom_snack_bar.dart';
import 'package:zadana_delivery/features/notifications/presentation/manager/notifications_state.dart';
import 'package:zadana_delivery/features/notifications/presentation/manager/notifications_view_model.dart';
import 'package:zadana_delivery/features/notifications/presentation/widget/notification_card.dart';
import 'package:zadana_delivery/features/notifications/presentation/widget/notifications_loading_view.dart';
import 'package:zadana_delivery/features/notifications/presentation/widget/notifications_summary_card.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final NotificationsViewModel _viewModel;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<NotificationsViewModel>()..loadInitial();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _viewModel.close();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll >= maxScroll - 200) {
      _viewModel.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return BlocProvider.value(
      value: _viewModel,
      child: BlocConsumer<NotificationsViewModel, NotificationsState>(
        listener: (context, state) {
          final exception = state.failure?.asException;
          if (exception == null || _viewModel.showGlobalError) return;

          CustomSnackbar.showError(
            context: context,
            message: ErrorMessagePresenter.snackBarMessage(context, exception),
          );
          _viewModel.clearError();
        },
        builder: (context, state) {
          if (_viewModel.showGlobalError) {
            return Scaffold(
              body: SafeArea(
                child: ApiErrorWidget(
                  exception: state.failure!.asException,
                  onRetry: _viewModel.loadInitial,
                  onGoBack: _viewModel.clearError,
                ),
              ),
            );
          }

          return Scaffold(
            backgroundColor: const Color(0xFFF6F8FA),
            appBar: CustomAppBar.modern(
              title: locale.notifications,
              backgroundColor: const Color(0xFFF6F8FA),
              actions: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 4),
                  child: Center(
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).pushNamed(AppRoutes.notificationPreferences);
                      },
                      icon: const Icon(Icons.settings_outlined, size: 22),
                      tooltip: 'Settings',
                    ),
                  ),
                ),
                if (_viewModel.items.isNotEmpty)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 12),
                    child: Center(
                      child: IconButton(
                        onPressed: state.isDeletingAll
                            ? null
                            : () async {
                                final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text(locale.notifications),
                                    content: const Text(
                                      'هل أنت متأكد من حذف جميع الإشعارات؟',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(ctx).pop(false),
                                        child: const Text('إلغاء'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(ctx).pop(true),
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.red,
                                        ),
                                        child: const Text('حذف الكل'),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirmed == true) {
                                  await _viewModel.deleteAllNotifications();
                                }
                              },
                        icon: state.isDeletingAll
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CustomProgressIndicator.compact(
                                  size: 18,
                                ),
                              )
                            : const Icon(
                                Icons.delete_outline_rounded,
                                size: 22,
                                color: AppColors.error,
                              ),
                        tooltip: 'Delete all',
                      ),
                    ),
                  ),
              ],
            ),
            body: SafeArea(
              top: false,
              child: Column(
                children: [
                  if (state.isRefreshing)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Center(
                        child: CustomProgressIndicator.compact(size: 22),
                      ),
                    ),
                  Expanded(
                    child: state.isLoading && state.notifications == null
                        ? const NotificationsLoadingView()
                        : RefreshIndicator(
                            onRefresh: _viewModel.refreshNotifications,
                            child: ListView(
                              controller: _scrollController,
                              physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics(),
                              ),
                              padding: const EdgeInsets.fromLTRB(
                                Spacing.base,
                                Spacing.md,
                                Spacing.base,
                                Spacing.xl,
                              ),
                              children: [
                                NotificationsSummaryCard(
                                  unreadCount: state.unreadCount,
                                  totalCount: state.notifications?.total ?? 0,
                                ),
                                const SizedBox(height: Spacing.base),
                                if (_viewModel.items.isEmpty)
                                  SizedBox(
                                    height: 360,
                                    child: Center(
                                      child: EmptyStateWidget(
                                        title: locale.notifications_empty_title,
                                        description: locale
                                            .notifications_empty_description,
                                        icon: Icons.notifications_none_rounded,
                                      ),
                                    ),
                                  )
                                else
                                  ..._viewModel.items.map(
                                    (item) => Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: Spacing.sm,
                                      ),
                                      child: Dismissible(
                                        key: ValueKey(item.id),
                                        background: Container(
                                          alignment:
                                              AlignmentDirectional.centerStart,
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                                start: 24,
                                              ),
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade50,
                                            borderRadius: BorderRadius.circular(
                                              22,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.delete_outline_rounded,
                                            color: Colors.red.shade400,
                                          ),
                                        ),
                                        secondaryBackground: Container(
                                          alignment:
                                              AlignmentDirectional.centerEnd,
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                                end: 24,
                                              ),
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade50,
                                            borderRadius: BorderRadius.circular(
                                              22,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.delete_outline_rounded,
                                            color: Colors.red.shade400,
                                          ),
                                        ),
                                        onDismissed: (_) {
                                          _viewModel.deleteNotification(
                                            item.id,
                                          );
                                        },
                                        child: NotificationCard(
                                          item: item,
                                          isLoading: _viewModel
                                              .isNotificationLoading(item.id),
                                          onTap: item.isRead
                                              ? null
                                              : () async {
                                                  await _viewModel.markAsRead(
                                                    item.id,
                                                  );
                                                },
                                        ),
                                      ),
                                    ),
                                  ),
                                if (state.isLoadingMore)
                                  ..._buildNotificationSkeletons(),
                              ],
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

  List<Widget> _buildNotificationSkeletons() {
    return List.generate(
      3,
      (index) => const Padding(
        padding: EdgeInsets.only(bottom: Spacing.sm),
        child: _NotificationSkeletonCard(),
      ),
    );
  }
}

class _NotificationSkeletonCard extends StatelessWidget {
  const _NotificationSkeletonCard();

  @override
  Widget build(BuildContext context) {
    final mutedColor = Theme.of(
      context,
    ).colorScheme.outlineVariant.withValues(alpha: 0.18);

    return SkeletonStateWidget(
      child: Container(
        padding: const EdgeInsets.all(Spacing.base),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFE5EDF2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: mutedColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 16,
                        decoration: BoxDecoration(
                          color: mutedColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        height: 12,
                        decoration: BoxDecoration(
                          color: mutedColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 180,
                        height: 12,
                        decoration: BoxDecoration(
                          color: mutedColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.sm),
            Container(
              width: 120,
              height: 28,
              decoration: BoxDecoration(
                color: mutedColor,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
