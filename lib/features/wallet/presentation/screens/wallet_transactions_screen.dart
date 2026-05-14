import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/core/errors/error_widgets/empty_state_widget.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/app_button.dart';
import 'package:zadana_delivery/core/widgets/custom_app_bar.dart';
import 'package:zadana_delivery/core/widgets/custom_progress_indicator.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_wallet_transaction_entity.dart';
import 'package:zadana_delivery/features/wallet/presentation/manager/wallet_state.dart';
import 'package:zadana_delivery/features/wallet/presentation/manager/wallet_view_model.dart';
import 'package:zadana_delivery/features/wallet/presentation/widgets/wallet_transaction_tile.dart';

class WalletTransactionsScreen extends StatelessWidget {
  const WalletTransactionsScreen({super.key, required this.viewModel});

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
                title: locale.wallet_transaction_history,
                onBackPressed: () => Navigator.of(context).maybePop(),
              ),
              Expanded(
                child: BlocBuilder<WalletViewModel, WalletState>(
                  builder: (context, state) {
                    if (state.isTransactionsLoading &&
                        state.transactions.isEmpty) {
                      return const Center(child: CustomProgressIndicator());
                    }

                    if (state.transactions.isEmpty) {
                      return Center(
                        child: EmptyStateWidget(
                          title: locale.wallet_transactions_empty_title,
                          description:
                              locale.wallet_transactions_empty_subtitle,
                          icon: Icons.receipt_long_outlined,
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () =>
                          viewModel.loadTransactions(refresh: true),
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                        children: [
                          _TransactionsOverviewCard(items: state.transactions),
                          const SizedBox(height: 18),
                          ...state.transactions.map(
                            (item) => Padding(
                              key: ValueKey<String>(item.id),
                              padding: const EdgeInsets.only(bottom: 12),
                              child: WalletTransactionTile(
                                item: item,
                                amountText: _formatTransactionAmount(
                                  context,
                                  item,
                                ),
                              ),
                            ),
                          ),
                          if (state.isLoadingMoreTransactions)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 18),
                              child: Center(
                                child: CustomProgressIndicator.compact(
                                  size: 22,
                                ),
                              ),
                            )
                          else if (viewModel.hasTransactionsMore)
                            AppButton.outlined(
                              text: locale.wallet_load_more,
                              onPressed: viewModel.loadMoreTransactions,
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

  String _formatTransactionAmount(
    BuildContext context,
    DriverWalletTransactionEntity item,
  ) {
    final localeName = Localizations.localeOf(context).toLanguageTag();
    final amount = NumberFormat.currency(
      locale: localeName,
      symbol: '${context.localization.currency} ',
      decimalDigits: item.amount.truncateToDouble() == item.amount ? 0 : 2,
    ).format(item.amount.abs());
    return item.isIncoming ? '+$amount' : '-$amount';
  }
}

class _TransactionsOverviewCard extends StatelessWidget {
  const _TransactionsOverviewCard({required this.items});

  final List<DriverWalletTransactionEntity> items;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final colors = context.colorScheme;
    final incomeCount = items.where((item) => item.isIncoming).length;
    final expenseCount = items.length - incomeCount;
    final latestDate = items.isEmpty ? null : items.first.createdAt;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            locale.wallet_subtitle_secure,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _OverviewStat(
                  label: locale.wallet_direction_in,
                  value: '$incomeCount',
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _OverviewStat(
                  label: locale.wallet_direction_out,
                  value: '$expenseCount',
                  color: AppColors.warning,
                ),
              ),
            ],
          ),
          if (latestDate != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                DateFormat('d MMM, h:mm a').format(latestDate),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colors.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _OverviewStat extends StatelessWidget {
  const _OverviewStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: color),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
