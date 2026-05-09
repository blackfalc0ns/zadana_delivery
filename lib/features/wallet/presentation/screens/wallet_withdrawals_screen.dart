import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/core/errors/error_widgets/empty_state_widget.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/app_button.dart';
import 'package:zadana_delivery/core/widgets/custom_app_bar.dart';
import 'package:zadana_delivery/core/widgets/custom_progress_indicator.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_wallet_withdrawal_request_entity.dart';
import 'package:zadana_delivery/features/wallet/presentation/manager/wallet_state.dart';
import 'package:zadana_delivery/features/wallet/presentation/manager/wallet_view_model.dart';
import 'package:zadana_delivery/features/wallet/presentation/mock/wallet_localization_examples.dart';

class WalletWithdrawalsScreen extends StatelessWidget {
  const WalletWithdrawalsScreen({super.key, required this.viewModel});

  final WalletViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return BlocProvider.value(
      value: viewModel,
      child: Scaffold(
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              CustomAppBar.modern(
                title: locale.wallet_withdrawal_requests,
                onBackPressed: () => Navigator.of(context).maybePop(),
              ),
              Expanded(
                child: BlocBuilder<WalletViewModel, WalletState>(
                  builder: (context, state) {
                    if (state.isWithdrawalsLoading &&
                        state.withdrawals.isEmpty) {
                      return const Center(child: CustomProgressIndicator());
                    }

                    if (state.withdrawals.isEmpty) {
                      return Center(
                        child: EmptyStateWidget(
                          title: locale.wallet_withdrawals_empty_title,
                          description: locale.wallet_withdrawals_empty_subtitle,
                          icon: Icons.outbox_outlined,
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () => viewModel.loadWithdrawals(refresh: true),
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                        children: [
                          ...state.withdrawals.map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _WithdrawalRequestCard(item: item),
                            ),
                          ),
                          if (state.isLoadingMoreWithdrawals)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 18),
                              child: Center(
                                child: CustomProgressIndicator.compact(
                                  size: 22,
                                ),
                              ),
                            )
                          else if (viewModel.hasWithdrawalsMore)
                            AppButton.outlined(
                              text: locale.wallet_load_more,
                              onPressed: viewModel.loadMoreWithdrawals,
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WithdrawalRequestCard extends StatelessWidget {
  const _WithdrawalRequestCard({required this.item});

  final DriverWalletWithdrawalRequestEntity item;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final colors = context.colorScheme;
    final statusColor = _statusColor(item.status, colors);
    final localeName = Localizations.localeOf(context).toLanguageTag();
    final amount = NumberFormat.currency(
      locale: localeName,
      symbol: '${locale.currency} ',
      decimalDigits: item.amount.truncateToDouble() == item.amount ? 0 : 2,
    ).format(item.amount);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.paymentMethod.maskedLabel,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.paymentMethod.providerName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                amount,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _WithdrawalPill(
                label: locale.walletWithdrawalStatusLabel(item.status),
                color: statusColor,
              ),
              _WithdrawalPill(
                label: DateFormat('d MMM, h:mm a').format(item.createdAt),
                color: colors.primary,
              ),
            ],
          ),
          if ((item.failureReason ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                item.failureReason!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colors.error,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _statusColor(String status, ColorScheme colors) {
    switch (status.trim().toLowerCase()) {
      case 'paid':
        return AppColors.success;
      case 'processing':
      case 'pending':
        return AppColors.warning;
      case 'cancelled':
      case 'failed':
        return colors.error;
      default:
        return colors.primary;
    }
  }
}

class _WithdrawalPill extends StatelessWidget {
  const _WithdrawalPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}
