import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/custom_app_bar.dart';
import 'package:zadana_delivery/core/widgets/custom_progress_indicator.dart';
import 'package:zadana_delivery/features/completed_orders/domain/entities/completed_order.dart';
import 'package:zadana_delivery/features/completed_orders/presentation/manager/completed_orders_state.dart';
import 'package:zadana_delivery/features/completed_orders/presentation/manager/completed_orders_view_model.dart';
import 'package:zadana_delivery/features/completed_orders/presentation/widgets/completed_order_card.dart';
import 'package:zadana_delivery/features/completed_orders/presentation/widgets/completed_order_details_sheet.dart';
import 'package:zadana_delivery/features/completed_orders/presentation/widgets/completed_orders_empty_state.dart';
import 'package:zadana_delivery/features/completed_orders/presentation/widgets/completed_orders_filter_bar.dart';
import 'package:zadana_delivery/features/completed_orders/presentation/widgets/completed_orders_loading_skeleton.dart';

class CompletedOrdersScreen extends StatefulWidget {
  const CompletedOrdersScreen({super.key});

  @override
  State<CompletedOrdersScreen> createState() => _CompletedOrdersScreenState();
}

class _CompletedOrdersScreenState extends State<CompletedOrdersScreen> {
  late final CompletedOrdersViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<CompletedOrdersViewModel>()..loadInitial();
  }

  @override
  void dispose() {
    _viewModel.close();
    super.dispose();
  }

  Future<void> _openOrderDetails(CompletedOrder order) async {
    final detailedOrder = await _viewModel.loadOrderDetails(order.id);
    if (!mounted) return;

    if (detailedOrder != null) {
      await showCompletedOrderDetailsSheet(context, detailedOrder);
    }
  }

  Future<void> _showRetryErrorDialog({
    required CompletedOrdersState state,
    required VoidCallback onRetry,
  }) async {
    final failure = state.failure;
    if (failure == null || !mounted) return;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          backgroundColor: Theme.of(dialogContext).colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ApiErrorWidget(
              exception: failure.asException,
              onRetry: () {
                Navigator.of(dialogContext).pop();
                onRetry();
              },
              onGoBack: () {
                Navigator.of(dialogContext).pop();
                _viewModel.clearError();
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return BlocProvider.value(
      value: _viewModel,
      child: BlocConsumer<CompletedOrdersViewModel, CompletedOrdersState>(
        listener: (context, state) {
          if (state.failure == null) return;

          if (_viewModel.showGlobalError) return;

          final detailsOrderId = state.lastDetailsOrderId;
          final failedOrder = detailsOrderId == null
              ? null
              : _viewModel.findOrderById(detailsOrderId);
          if (failedOrder != null) {
            _showRetryErrorDialog(
              state: state,
              onRetry: () => _openOrderDetails(failedOrder),
            );
            return;
          }

          _showRetryErrorDialog(
            state: state,
            onRetry: _viewModel.retryCurrentRequest,
          );
        },
        builder: (context, state) {
          final showGlobalError = _viewModel.showGlobalError;
          final orders = state.orders;
          final totalDistance = _viewModel.totalDistance;

          if (showGlobalError) {
            return Scaffold(
              backgroundColor: context.colorScheme.surface,
              body: SafeArea(
                child: ApiErrorWidget(
                  exception: state.failure!.asException,
                  onRetry: _viewModel.retryCurrentRequest,
                  onGoBack: _viewModel.clearError,
                ),
              ),
            );
          }

          return Scaffold(
            body: SafeArea(
              top: false,
              child: Stack(
                children: [
                  Column(
                    children: [
                      CustomAppBar(
                        title: locale.completed_orders_title,
                        showBackButton: false,
                        showShadow: false,
                        titleFontSize: FontSize.size18,
                      ),
                      if (state.isRefreshing)
                        const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Center(
                            child: CustomProgressIndicator.compact(size: 22),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
                        child: CompletedOrdersFilterBar(
                          selectedStatus: state.selectedStatus,
                          onStatusChanged: _viewModel.selectStatus,
                        ),
                      ),
                      Expanded(
                        child: state.isLoading
                            ? const Center(child: CustomProgressIndicator())
                            : state.isFilterLoading
                            ? const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: CompletedOrdersLoadingSkeleton(),
                              )
                            : Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      16,
                                      0,
                                      16,
                                      10,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: _SummaryCard(
                                            value: '${state.totalCount}',
                                            label: locale
                                                .completed_orders_summary_orders,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: _SummaryCard(
                                            value: totalDistance
                                                .toStringAsFixed(1),
                                            label: locale
                                                .completed_orders_summary_distance,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: orders.isEmpty
                                        ? Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: CompletedOrdersEmptyState(
                                              title: locale
                                                  .completed_orders_empty_title,
                                              subtitle: locale
                                                  .completed_orders_empty_subtitle,
                                              status: state.selectedStatus,
                                            ),
                                          )
                                        : RefreshIndicator(
                                            onRefresh: _viewModel.refreshOrders,
                                            child: ListView.separated(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                    16,
                                                    0,
                                                    16,
                                                    28,
                                                  ),
                                              physics:
                                                  const AlwaysScrollableScrollPhysics(
                                                    parent:
                                                        BouncingScrollPhysics(),
                                                  ),
                                              itemCount: orders.length,
                                              separatorBuilder: (_, _) =>
                                                  const SizedBox(height: 12),
                                              itemBuilder: (context, index) {
                                                final order = orders[index];
                                                return CompletedOrderCard(
                                                  order: order,
                                                  onTap: state.isDetailsLoading
                                                      ? null
                                                      : () => _openOrderDetails(
                                                          order,
                                                        ),
                                                );
                                              },
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                  if (state.isDetailsLoading)
                    Positioned.fill(
                      child: ColoredBox(
                        color: Colors.black.withValues(alpha: 0.08),
                        child: const Center(
                          child: CustomProgressIndicator(size: 84),
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

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          width: .5,
          color: scheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size17,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: getMediumStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size10,
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
