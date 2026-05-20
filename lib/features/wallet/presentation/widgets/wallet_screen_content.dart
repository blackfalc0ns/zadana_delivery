import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/custom_progress_indicator.dart';
import 'package:zadana_delivery/core/widgets/custom_snack_bar.dart';
import 'package:zadana_delivery/features/wallet/presentation/manager/wallet_state.dart';
import 'package:zadana_delivery/features/wallet/presentation/manager/wallet_view_model.dart';
import 'package:zadana_delivery/features/wallet/presentation/widgets/wallet_ambient_background.dart';
import 'package:zadana_delivery/features/wallet/presentation/widgets/wallet_balance_hero_card.dart';
import 'package:zadana_delivery/features/wallet/presentation/widgets/wallet_feedback_widgets.dart';
import 'package:zadana_delivery/features/wallet/presentation/widgets/wallet_layout_widgets.dart';
import 'package:zadana_delivery/features/wallet/presentation/widgets/wallet_payment_method_tile.dart';
import 'package:zadana_delivery/features/wallet/presentation/widgets/wallet_section_shell.dart';
import 'package:zadana_delivery/features/wallet/presentation/widgets/wallet_summary_metric_card.dart';
import 'package:zadana_delivery/features/wallet/presentation/widgets/wallet_transaction_tile.dart';

class WalletScreenContent extends StatelessWidget {
  const WalletScreenContent({
    super.key,
    required this.state,
    required this.viewModel,
    required this.onRefresh,
    required this.onOpenTransactions,
    required this.onOpenWithdrawals,
    required this.onOpenCreatePaymentMethod,
    required this.onOpenWithdrawal,
    required this.onShowPaymentMethodActions,
    required this.formatCurrency,
    required this.formatSignedCurrency,
  });

  final WalletState state;
  final WalletViewModel viewModel;
  final Future<void> Function() onRefresh;
  final VoidCallback onOpenTransactions;
  final VoidCallback onOpenWithdrawals;
  final VoidCallback onOpenCreatePaymentMethod;
  final ValueChanged<double> onOpenWithdrawal;
  final ValueChanged<String> onShowPaymentMethodActions;
  final String Function(double value) formatCurrency;
  final String Function(double value, bool isIncoming) formatSignedCurrency;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final summary = viewModel.summary;
    final paymentMethods = viewModel.paymentMethods;
    final canWithdraw = viewModel.canRequestWithdrawal;
    final withdrawalBlockMessage = _withdrawalBlockMessage(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            const WalletAmbientBackground(),
            Column(
              children: [
                Expanded(
                  child: state.isRefreshing && summary == null
                      ? const Center(
                          child: CustomProgressIndicator(),
                        )
                      : summary == null && state.isLoading
                      ? const Center(
                          child: CustomProgressIndicator(),
                        )
                      : RefreshIndicator(
                          onRefresh: onRefresh,
                          child: ListView(
                            padding: const EdgeInsets.fromLTRB(16, 10, 16, 28),
                            physics: const AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics(),
                            ),
                            children: [
                              WalletBalanceHeroCard(
                                title: locale.wallet_current_balance,
                                subtitle: _heroSubtitle(context),
                                balanceValue: formatCurrency(
                                  summary?.currentBalance ?? 0,
                                ),
                                availableLabel:
                                    locale.wallet_available_to_withdraw,
                                availableValue: formatCurrency(
                                  viewModel.withdrawableAmount,
                                ),
                                pendingLabel: locale.wallet_pending_balance,
                                pendingValue: formatCurrency(
                                  summary?.pendingBalance ?? 0,
                                ),
                                codLabel: locale.wallet_cod_owed_balance,
                                codValue: formatCurrency(
                                  summary?.codOwedBalance ?? 0,
                                ),
                                ctaLabel: locale.wallet_withdraw_cta,
                                statusLabel: canWithdraw
                                    ? locale.wallet_status_ready
                                    : locale.wallet_status_blocked,
                                onWithdraw: canWithdraw
                                    ? () => onOpenWithdrawal(
                                        viewModel.withdrawableAmount,
                                      )
                                    : null,
                                onDisabledWithdrawTap:
                                    withdrawalBlockMessage == null
                                    ? null
                                    : () => CustomSnackbar.showError(
                                        context: context,
                                        message: withdrawalBlockMessage,
                                      ),
                                withdrawHelperText: canWithdraw
                                    ? null
                                    : withdrawalBlockMessage,
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF16829A),
                                    Color(0xFF10697E),
                                    Color(0xFF0A5165),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                glowColor: const Color(0x403FD0E1),
                              ),
                              if (viewModel.isWalletEmpty) ...[
                                const SizedBox(height: 16),
                                const WalletSurface(
                                  child: WalletStarterCardShell(),
                                ),
                              ],
                              if (viewModel.hasAlerts) ...[
                                const SizedBox(height: 16),
                                WalletSurface(
                                  child: WalletSectionShell(
                                    title: locale.wallet_alerts,
                                    subtitle: _alertSubtitle(context),
                                    child: Column(
                                      children: [
                                        if ((summary?.codOwedBalance ?? 0) > 0)
                                          InlineWalletAlert(
                                            icon: Icons.payments_outlined,
                                            title:
                                                locale.wallet_cod_block_title,
                                            subtitle: locale
                                                .wallet_cod_block_subtitle,
                                          ),
                                        if ((summary?.pendingBalance ?? 0) > 0)
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: (summary?.codOwedBalance ??
                                                          0) >
                                                      0
                                                  ? 10
                                                  : 0,
                                            ),
                                            child: InlineWalletAlert(
                                              icon: Icons.lock_clock_rounded,
                                              title: locale
                                                  .wallet_alert_payout_title,
                                              subtitle: locale
                                                  .wallet_alert_payout_subtitle,
                                            ),
                                          ),
                                        if (paymentMethods.any(
                                          (item) => !item.isVerified,
                                        ))
                                          const SizedBox(height: 10),
                                        if (paymentMethods.any(
                                          (item) => !item.isVerified,
                                        ))
                                          InlineWalletAlert(
                                            icon:
                                                Icons.verified_user_outlined,
                                            title: locale
                                                .wallet_alert_verification_title,
                                            subtitle: locale
                                                .wallet_alert_verification_subtitle,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                              const SizedBox(height: 16),
                              WalletSurface(
                                child: WalletSectionShell(
                                  title: locale.wallet_earnings_summary,
                                  subtitle: _heroSubtitle(context),
                                  child: WalletAdaptiveGrid(
                                    children: [
                                      WalletSummaryMetricCard(
                                        label: locale.wallet_metric_today,
                                        value: formatCurrency(
                                          summary?.todayEarnings ?? 0,
                                        ),
                                        icon: Icons.today_rounded,
                                        tint: AppColors.success,
                                      ),
                                      WalletSummaryMetricCard(
                                        label: locale.wallet_metric_week,
                                        value: formatCurrency(
                                          summary?.weekEarnings ?? 0,
                                        ),
                                        icon: Icons.date_range_rounded,
                                        tint: AppColors.info,
                                      ),
                                      WalletSummaryMetricCard(
                                        label: locale.wallet_metric_month,
                                        value: formatCurrency(
                                          summary?.monthEarnings ?? 0,
                                        ),
                                        icon: Icons.insights_rounded,
                                        tint: AppColors.secondary,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              WalletSurface(
                                child: WalletSectionShell(
                                  title: locale.wallet_withdrawal_requests,
                                  subtitle: canWithdraw
                                      ? locale.wallet_available_to_withdraw
                                      : withdrawalBlockMessage,
                                  trailing: TextButton(
                                    onPressed: onOpenWithdrawals,
                                    child: Text(locale.wallet_view_all),
                                  ),
                                  child: WalletAdaptiveGrid(
                                    children: [
                                      WalletSummaryMetricCard(
                                        label: locale.wallet_pending_requests,
                                        value:
                                            '${summary?.withdrawalSummary.pendingCount ?? 0}',
                                        icon: Icons.pending_actions_rounded,
                                        tint: AppColors.warning,
                                      ),
                                      WalletSummaryMetricCard(
                                        label: locale
                                            .wallet_pending_requests_amount,
                                        value: formatCurrency(
                                          summary?.withdrawalSummary
                                                  .pendingAmount ??
                                              0,
                                        ),
                                        icon: Icons.hourglass_top_rounded,
                                        tint: AppColors.info,
                                      ),
                                      WalletSummaryMetricCard(
                                        label: locale.wallet_total_requests,
                                        value:
                                            '${summary?.withdrawalSummary.totalRequests ?? 0}',
                                        icon: Icons.receipt_long_rounded,
                                        tint: AppColors.secondary,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              WalletSurface(
                                child: WalletSectionShell(
                                  title: locale.wallet_transaction_history,
                                  trailing: TextButton(
                                    onPressed: onOpenTransactions,
                                    child: Text(locale.wallet_view_all),
                                  ),
                                  child: viewModel
                                          .recentTransactionsPreview
                                          .isNotEmpty
                                      ? Column(
                                          children: viewModel
                                              .recentTransactionsPreview
                                              .map(
                                                (item) => Padding(
                                                  key: ValueKey<String>(item.id),
                                                  padding:
                                                      const EdgeInsets.only(
                                                        bottom: 10,
                                                      ),
                                                  child: WalletTransactionTile(
                                                    item: item,
                                                    amountText:
                                                        formatSignedCurrency(
                                                          item.amount,
                                                          item.isIncoming,
                                                        ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        )
                                      : EmptyWalletSection(
                                          icon: Icons.receipt_long_outlined,
                                          title: locale
                                              .wallet_transactions_empty_title,
                                          subtitle: locale
                                              .wallet_transactions_empty_subtitle,
                                        ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              WalletSurface(
                                child: WalletSectionShell(
                                  title: locale.wallet_payment_methods,
                                  subtitle:
                                      _paymentMethodsStatusLabel(context),
                                  trailing: TextButton.icon(
                                    onPressed: onOpenCreatePaymentMethod,
                                    icon: const Icon(
                                      Icons.add_rounded,
                                      size: 16,
                                    ),
                                    label: Text(locale.wallet_add_method),
                                  ),
                                  child: paymentMethods.isNotEmpty
                                      ? Column(
                                          children: paymentMethods
                                              .map(
                                                (item) => Padding(
                                                  key: ValueKey<String>(item.id),
                                                  padding:
                                                      const EdgeInsets.only(
                                                        bottom: 10,
                                                      ),
                                                  child: GestureDetector(
                                                    onTap: state.activePaymentMethodId ==
                                                            item.id
                                                        ? null
                                                        : () =>
                                                              onShowPaymentMethodActions(
                                                                item.id,
                                                              ),
                                                    child: WalletPaymentMethodTile(
                                                      item: item,
                                                      isLoading:
                                                          state.activePaymentMethodId ==
                                                              item.id,
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        )
                                      : EmptyWalletSection(
                                          icon: Icons
                                              .account_balance_wallet_outlined,
                                          title:
                                              locale.wallet_methods_empty_title,
                                          subtitle: locale
                                              .wallet_methods_empty_subtitle,
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String? _withdrawalBlockMessage(BuildContext context) {
    switch (viewModel.withdrawalBlockReason) {
      case WalletWithdrawalBlockReason.none:
        return null;
      case WalletWithdrawalBlockReason.noPrimaryMethod:
        return context.localization.wallet_withdraw_blocked_no_primary;
      case WalletWithdrawalBlockReason.codBlocked:
        return context.localization.wallet_withdraw_blocked_cod;
      case WalletWithdrawalBlockReason.noBalance:
        return context.localization.wallet_withdraw_blocked_no_balance;
    }
  }

  String _heroSubtitle(BuildContext context) {
    final locale = context.localization;
    switch (viewModel.heroState) {
      case WalletHeroState.ready:
        return locale.wallet_subtitle_ready;
      case WalletHeroState.addPrimaryMethod:
        return locale.wallet_subtitle_add_primary;
      case WalletHeroState.codBlocked:
        return locale.wallet_subtitle_cod_blocked;
      case WalletHeroState.noWithdrawable:
        return locale.wallet_subtitle_no_withdrawable;
    }
  }

  String _alertSubtitle(BuildContext context) {
    switch (viewModel.alertState) {
      case WalletAlertState.codBlocked:
        return context.localization.wallet_cod_block_subtitle;
      case WalletAlertState.verificationRequired:
        return context.localization.wallet_alert_verification_subtitle;
      case WalletAlertState.pendingPayout:
      case WalletAlertState.none:
        return context.localization.wallet_alert_payout_subtitle;
    }
  }

  String _paymentMethodsStatusLabel(BuildContext context) {
    final locale = context.localization;
    switch (viewModel.paymentMethodsState) {
      case WalletPaymentMethodsState.empty:
        return locale.wallet_add_method;
      case WalletPaymentMethodsState.verificationRequired:
        return locale.wallet_unverified_method;
      case WalletPaymentMethodsState.hasPrimaryMethod:
        return locale.wallet_primary_method;
      case WalletPaymentMethodsState.completed:
        return locale.wallet_status_completed;
    }
  }
}
