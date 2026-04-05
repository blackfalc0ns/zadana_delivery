import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/l10n/translations/app_localizations.dart';
import 'package:zadana_delivery/core/widgets/custom_app_bar.dart';
import 'package:zadana_delivery/features/wallet/presentation/mock/wallet_fake_data.dart';
import 'package:zadana_delivery/features/wallet/presentation/widgets/wallet_alert_tile.dart';
import 'package:zadana_delivery/features/wallet/presentation/widgets/wallet_balance_hero_card.dart';
import 'package:zadana_delivery/features/wallet/presentation/widgets/wallet_payment_method_tile.dart';
import 'package:zadana_delivery/features/wallet/presentation/widgets/wallet_section_shell.dart';
import 'package:zadana_delivery/features/wallet/presentation/widgets/wallet_summary_metric_card.dart';
import 'package:zadana_delivery/features/wallet/presentation/widgets/wallet_transaction_tile.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final walletTheme = context.walletTheme;
    final snapshot = WalletFakeData.success;

    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            CustomAppBar.modern(
              title: locale.wallet_title,
              onBackPressed: () => Navigator.of(context).maybePop(),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                physics: const BouncingScrollPhysics(),
                children: [
                  WalletBalanceHeroCard(
                    title: locale.wallet_current_balance,
                    subtitle: locale.wallet_subtitle,
                    balanceValue: _formatCurrency(context, snapshot.currentBalance),
                    availableLabel: locale.wallet_available_to_withdraw,
                    availableValue: _formatCurrency(
                      context,
                      snapshot.availableToWithdraw,
                    ),
                    pendingLabel: locale.wallet_pending_balance,
                    pendingValue: _formatCurrency(
                      context,
                      snapshot.pendingBalance,
                    ),
                    ctaLabel: locale.wallet_withdraw_cta,
                    onWithdraw: () => _onWithdrawPressed(context),
                    gradient: walletTheme.heroGradient,
                    glowColor: walletTheme.heroGlow,
                  ),
                  const SizedBox(height: 18),
                  WalletSectionShell(
                    title: locale.wallet_earnings_summary,
                    child: Column(
                      children: [
                        WalletSummaryMetricCard(
                          label: locale.wallet_metric_today,
                          value: _formatCurrency(context, snapshot.todayEarnings),
                          icon: Icons.today_rounded,
                          tint: walletTheme.successTint,
                        ),
                        const SizedBox(height: 10),
                        WalletSummaryMetricCard(
                          label: locale.wallet_metric_week,
                          value: _formatCurrency(context, snapshot.weekEarnings),
                          icon: Icons.date_range_rounded,
                          tint: walletTheme.infoTint,
                        ),
                        const SizedBox(height: 10),
                        WalletSummaryMetricCard(
                          label: locale.wallet_metric_month,
                          value: _formatCurrency(context, snapshot.monthEarnings),
                          icon: Icons.insights_rounded,
                          tint: walletTheme.bonusTint,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  WalletSectionShell(
                    title: locale.wallet_transaction_history,
                    child: Column(
                      children: snapshot.transactions
                          .map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: WalletTransactionTile(
                                item: item,
                                amountText: _formatSignedCurrency(
                                  context,
                                  item.amount,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  WalletSectionShell(
                    title: locale.wallet_payment_methods,
                    child: Column(
                      children: snapshot.paymentMethods
                          .map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: WalletPaymentMethodTile(item: item),
                            ),
                          )
                          .toList(),
                    ),
                  ),
               
                  WalletSectionShell(
                    title: locale.wallet_alerts,
                    child: Column(
                      children: snapshot.alerts
                          .map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: WalletAlertTile(
                                title: _alertTitle(locale, item.titleKey),
                                subtitle: _alertSubtitle(
                                  locale,
                                  item.subtitleKey,
                                ),
                                action: item.action,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCurrency(BuildContext context, double value) {
    final localeName = Localizations.localeOf(context).toLanguageTag();
    return NumberFormat.currency(
      locale: localeName,
      symbol: '${context.localization.egp} ',
      decimalDigits: value.truncateToDouble() == value ? 0 : 2,
    ).format(value);
  }

  String _formatSignedCurrency(BuildContext context, double value) {
    final amount = _formatCurrency(context, value.abs());
    return value >= 0 ? '+$amount' : '-$amount';
  }

  String _alertTitle(AppLocalizations locale, String key) {
    switch (key) {
      case 'wallet_alert_verification_title':
        return locale.wallet_alert_verification_title;
      case 'wallet_alert_payout_title':
        return locale.wallet_alert_payout_title;
      case 'wallet_alert_incentive_title':
        return locale.wallet_alert_incentive_title;
      default:
        return key;
    }
  }

  String _alertSubtitle(AppLocalizations locale, String key) {
    switch (key) {
      case 'wallet_alert_verification_subtitle':
        return locale.wallet_alert_verification_subtitle;
      case 'wallet_alert_payout_subtitle':
        return locale.wallet_alert_payout_subtitle;
      case 'wallet_alert_incentive_subtitle':
        return locale.wallet_alert_incentive_subtitle;
      default:
        return key;
    }
  }

  void _onWithdrawPressed(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.localization.wallet_withdraw_success)),
    );
  }
}
