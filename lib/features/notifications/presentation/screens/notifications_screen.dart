import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/errors/error_presentation.dart';
import 'package:zadana_delivery/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_delivery/core/errors/error_widgets/empty_state_widget.dart';
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

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<NotificationsViewModel>()..loadInitial();
  }

  @override
  void dispose() {
    _viewModel.close();
    super.dispose();
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
            backgroundColor: const Color(0xFFF7FAFC),
            appBar: CustomAppBar.modern(
              title: locale.notifications,
              backgroundColor: const Color(0xFFF7FAFC),
              actions: [
                if (state.unreadCount > 0)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8),
                    child: Center(
                      child: TextButton(
                        onPressed: state.isMarkingAllRead
                            ? null
                            : () async {
                                await _viewModel.markAllAsRead();
                              },
                        child: state.isMarkingAllRead
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CustomProgressIndicator.compact(
                                  size: 18,
                                ),
                              )
                            : Text(locale.notifications_mark_all_read),
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
                              physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics(),
                              ),
                              padding: const EdgeInsets.fromLTRB(
                                Spacing.base,
                                Spacing.base,
                                Spacing.base,
                                Spacing.xl,
                              ),
                              children: [
                                NotificationsSummaryCard(
                                  unreadCount: state.unreadCount,
                                  totalCount: state.notifications?.total ?? 0,
                                ),
                                const SizedBox(height: Spacing.lg),
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
                                        bottom: Spacing.md,
                                      ),
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
}
