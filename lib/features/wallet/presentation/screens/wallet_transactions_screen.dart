import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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
                          description: locale.wallet_transactions_empty_subtitle,
                          icon: Icons.receipt_long_outlined,
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () => viewModel.loadTransactions(refresh: true),
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                        children: [
                          ...state.transactions.map(
                            (item) => Padding(
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
