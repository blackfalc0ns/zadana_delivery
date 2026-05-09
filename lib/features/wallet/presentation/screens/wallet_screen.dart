import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/errors/error_presentation.dart';
import 'package:zadana_delivery/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_delivery/core/errors/error_widgets/empty_state_widget.dart';
import 'package:zadana_delivery/core/errors/error_widgets/skeleton_state_widget.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/custom_app_bar.dart';
import 'package:zadana_delivery/core/widgets/custom_progress_indicator.dart';
import 'package:zadana_delivery/core/widgets/custom_snack_bar.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_payout_method_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_payout_method_upsert_request_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_wallet_create_withdrawal_request_entity.dart';
import 'package:zadana_delivery/features/wallet/presentation/manager/wallet_state.dart';
import 'package:zadana_delivery/features/wallet/presentation/manager/wallet_view_model.dart';
import 'package:zadana_delivery/features/wallet/presentation/screens/wallet_payment_method_form_screen.dart';
import 'package:zadana_delivery/features/wallet/presentation/screens/wallet_transactions_screen.dart';
import 'package:zadana_delivery/features/wallet/presentation/screens/wallet_withdrawal_form_screen.dart';
import 'package:zadana_delivery/features/wallet/presentation/screens/wallet_withdrawals_screen.dart';
import 'package:zadana_delivery/features/wallet/presentation/widgets/wallet_balance_hero_card.dart';
import 'package:zadana_delivery/features/wallet/presentation/widgets/wallet_payment_method_tile.dart';
import 'package:zadana_delivery/features/wallet/presentation/widgets/wallet_section_shell.dart';
import 'package:zadana_delivery/features/wallet/presentation/widgets/wallet_summary_metric_card.dart';
import 'package:zadana_delivery/features/wallet/presentation/widgets/wallet_transaction_tile.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  late final WalletViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<WalletViewModel>()..loadInitial();
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
      child: BlocConsumer<WalletViewModel, WalletState>(
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

          final summary = _viewModel.summary;
          final paymentMethods = _viewModel.paymentMethods;

          return Scaffold(
            body: SafeArea(
              top: false,
              child: Column(
                children: [
                  CustomAppBar.modern(
                    title: locale.wallet_title,
                    onBackPressed: () => Navigator.of(context).maybePop(),
                  ),
                  if (state.isRefreshing)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Center(
                        child: CustomProgressIndicator.compact(size: 22),
                      ),
                    ),
                  Expanded(
                    child: summary == null && state.isLoading
                        ? const _WalletLoadingSkeleton()
                        : RefreshIndicator(
                            onRefresh: _viewModel.refreshWallet,
                            child: ListView(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                              physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics(),
                              ),
                              children: [
                                WalletBalanceHeroCard(
                                  title: locale.wallet_current_balance,
                                  subtitle: locale.wallet_subtitle_secure,
                                  balanceValue: _formatCurrency(
                                    context,
                                    summary?.currentBalance ?? 0,
                                  ),
                                  availableLabel:
                                      locale.wallet_available_to_withdraw,
                                  availableValue: _formatCurrency(
                                    context,
                                    summary?.availableToWithdraw ?? 0,
                                  ),
                                  pendingLabel: locale.wallet_pending_balance,
                                  pendingValue: _formatCurrency(
                                    context,
                                    summary?.pendingBalance ?? 0,
                                  ),
                                  ctaLabel: locale.wallet_withdraw_cta,
                                  onWithdraw: () => _openWithdrawalPage(
                                    summary?.availableToWithdraw ?? 0,
                                  ),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF0B8FA3),
                                      Color(0xFF05657D),
                                      Color(0xFF02384E),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  glowColor: const Color(0x332BBBD0),
                                ),
                                const SizedBox(height: 18),
                                WalletSectionShell(
                                  title: locale.wallet_earnings_summary,
                                  child: Column(
                                    children: [
                                      WalletSummaryMetricCard(
                                        label: locale.wallet_metric_today,
                                        value: _formatCurrency(
                                          context,
                                          summary?.todayEarnings ?? 0,
                                        ),
                                        icon: Icons.today_rounded,
                                        tint: AppColors.success,
                                      ),
                                      const SizedBox(height: 10),
                                      WalletSummaryMetricCard(
                                        label: locale.wallet_metric_week,
                                        value: _formatCurrency(
                                          context,
                                          summary?.weekEarnings ?? 0,
                                        ),
                                        icon: Icons.date_range_rounded,
                                        tint: AppColors.info,
                                      ),
                                      const SizedBox(height: 10),
                                      WalletSummaryMetricCard(
                                        label: locale.wallet_metric_month,
                                        value: _formatCurrency(
                                          context,
                                          summary?.monthEarnings ?? 0,
                                        ),
                                        icon: Icons.insights_rounded,
                                        tint: AppColors.secondary,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                WalletSectionShell(
                                  title: locale.wallet_withdrawal_requests,
                                  trailing: TextButton(
                                    onPressed: _openWithdrawalsPage,
                                    child: Text(locale.wallet_view_all),
                                  ),
                                  child: Column(
                                    children: [
                                      WalletSummaryMetricCard(
                                        label: locale.wallet_pending_requests,
                                        value:
                                            '${summary?.withdrawalSummary.pendingCount ?? 0}',
                                        icon: Icons.pending_actions_rounded,
                                        tint: AppColors.warning,
                                      ),
                                      const SizedBox(height: 10),
                                      WalletSummaryMetricCard(
                                        label:
                                            locale.wallet_pending_requests_amount,
                                        value: _formatCurrency(
                                          context,
                                          summary?.withdrawalSummary.pendingAmount ??
                                              0,
                                        ),
                                        icon: Icons.hourglass_top_rounded,
                                        tint: AppColors.info,
                                      ),
                                      const SizedBox(height: 10),
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
                                const SizedBox(height: 20),
                                WalletSectionShell(
                                  title: locale.wallet_transaction_history,
                                  trailing: TextButton(
                                    onPressed: _openTransactionsPage,
                                    child: Text(locale.wallet_view_all),
                                  ),
                                  child: (summary?.recentTransactions.isNotEmpty ??
                                          false)
                                      ? Column(
                                          children: summary!.recentTransactions
                                              .map(
                                                (item) => Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        bottom: 10,
                                                      ),
                                                  child: WalletTransactionTile(
                                                    item: item,
                                                    amountText:
                                                        _formatSignedCurrency(
                                                          context,
                                                          item.amount,
                                                          item.isIncoming,
                                                        ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        )
                                      : _EmptyWalletSection(
                                          icon: Icons.receipt_long_outlined,
                                          title:
                                              locale.wallet_transactions_empty_title,
                                          subtitle: locale
                                              .wallet_transactions_empty_subtitle,
                                        ),
                                ),
                                const SizedBox(height: 10),
                                WalletSectionShell(
                                  title: locale.wallet_payment_methods,
                                  trailing: TextButton.icon(
                                    onPressed: _openCreatePaymentMethodPage,
                                    icon: const Icon(Icons.add_rounded, size: 18),
                                    label: Text(locale.wallet_add_method),
                                  ),
                                  child: paymentMethods.isNotEmpty
                                      ? Column(
                                          children: paymentMethods
                                              .map(
                                                (item) => Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        bottom: 10,
                                                      ),
                                                  child: Stack(
                                                    children: [
                                                      WalletPaymentMethodTile(
                                                        item: item,
                                                      ),
                                                      PositionedDirectional(
                                                        top: 8,
                                                        end: 8,
                                                        child: IconButton(
                                                          onPressed: state
                                                                      .activePaymentMethodId ==
                                                                  item.id
                                                              ? null
                                                              : () =>
                                                                  _showPaymentMethodActions(
                                                                    item,
                                                                  ),
                                                          icon: state
                                                                      .activePaymentMethodId ==
                                                                  item.id
                                                              ? const SizedBox(
                                                                  width: 18,
                                                                  height: 18,
                                                                  child:
                                                                      CustomProgressIndicator.compact(
                                                                        size:
                                                                            18,
                                                                      ),
                                                                )
                                                              : const Icon(
                                                                  Icons
                                                                      .more_horiz_rounded,
                                                                ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        )
                                      : _EmptyWalletSection(
                                          icon:
                                              Icons.account_balance_wallet_outlined,
                                          title:
                                              locale.wallet_methods_empty_title,
                                          subtitle: locale
                                              .wallet_methods_empty_subtitle,
                                        ),
                                ),
                                const SizedBox(height: 10),
                                if ((summary?.pendingBalance ?? 0) > 0 ||
                                    paymentMethods.any((item) => !item.isVerified))
                                  WalletSectionShell(
                                    title: locale.wallet_alerts,
                                    child: Column(
                                      children: [
                                        if ((summary?.pendingBalance ?? 0) > 0)
                                          _InlineWalletAlert(
                                            icon: Icons.lock_clock_rounded,
                                            title: locale
                                                .wallet_alert_payout_title,
                                            subtitle: locale
                                                .wallet_alert_payout_subtitle,
                                          ),
                                        if (paymentMethods.any(
                                          (item) => !item.isVerified,
                                        ))
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 10,
                                            ),
                                            child: _InlineWalletAlert(
                                              icon: Icons.verified_user_outlined,
                                              title: locale
                                                  .wallet_alert_verification_title,
                                              subtitle: locale
                                                  .wallet_alert_verification_subtitle,
                                            ),
                                          ),
                                      ],
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

  String _formatCurrency(BuildContext context, double value) {
    final localeName = Localizations.localeOf(context).toLanguageTag();
    return NumberFormat.currency(
      locale: localeName,
      symbol: '${context.localization.currency} ',
      decimalDigits: value.truncateToDouble() == value ? 0 : 2,
    ).format(value);
  }

  String _formatSignedCurrency(
    BuildContext context,
    double value,
    bool isIncoming,
  ) {
    final amount = _formatCurrency(context, value.abs());
    return isIncoming ? '+$amount' : '-$amount';
  }

  Future<void> _openWithdrawalPage(double availableBalance) async {
    final request = await Navigator.of(
      context,
    ).push<DriverWalletCreateWithdrawalRequestEntity>(
      MaterialPageRoute(
        builder: (_) => WalletWithdrawalFormScreen(
          viewModel: _viewModel,
          availableBalance: availableBalance,
          primaryMethod: _viewModel.primaryPaymentMethod,
        ),
      ),
    );
    if (request == null || !mounted) return;

    final success = await _viewModel.createWithdrawal(request);
    if (!mounted || !success) return;

    CustomSnackbar.showSuccess(
      context: context,
      message: context.localization.wallet_withdraw_success,
    );
  }

  Future<void> _showCreatePaymentMethodDialog() async {
    final request = await Navigator.of(context, rootNavigator: true)
        .push<DriverPayoutMethodUpsertRequestEntity>(
      MaterialPageRoute(
        builder: (_) =>
            WalletPaymentMethodFormScreen(viewModel: _viewModel),
      ),
    );
    if (request == null || !mounted) return;

    final success = await _viewModel.createPaymentMethod(request);
    if (!mounted) return;
    if (!success) return;

    CustomSnackbar.showSuccess(
      context: context,
      message: context.localization.wallet_method_saved,
    );
  }

  Future<void> _showEditPaymentMethodDialog(
    DriverPayoutMethodEntity method,
  ) async {
    final request = await Navigator.of(context, rootNavigator: true)
        .push<DriverPayoutMethodUpsertRequestEntity>(
      MaterialPageRoute(
        builder: (_) => WalletPaymentMethodFormScreen(
          viewModel: _viewModel,
          existingMethod: method,
        ),
      ),
    );
    if (request == null || !mounted) return;

    final success = await _viewModel.updatePaymentMethod(method.id, request);
    if (!mounted) return;
    if (!success) return;

    CustomSnackbar.showSuccess(
      context: context,
      message: context.localization.wallet_method_updated,
    );
  }

  Future<void> _showPaymentMethodActions(DriverPayoutMethodEntity method) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        final locale = sheetContext.localization;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: Text(locale.profile_update_action),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _showEditPaymentMethodDialog(method);
                },
              ),
              if (!method.isPrimary)
                ListTile(
                  leading: const Icon(Icons.star_outline_rounded),
                  title: Text(locale.wallet_make_primary),
                  onTap: () async {
                    final screenContext = context;
                    final successMessage =
                        screenContext.localization.wallet_primary_updated;
                    Navigator.of(sheetContext).pop();
                    final success = await _viewModel.makePrimary(method.id);
                    if (!screenContext.mounted || !success) return;
                    CustomSnackbar.showSuccess(
                      context: screenContext,
                      message: successMessage,
                    );
                  },
                ),
              ListTile(
                leading: const Icon(Icons.delete_outline_rounded),
                title: Text(locale.delete),
                onTap: () async {
                  final screenContext = context;
                  final successMessage =
                      screenContext.localization.wallet_method_deleted;
                  Navigator.of(sheetContext).pop();
                  final confirmed = await showDialog<bool>(
                    context: screenContext,
                    builder: (dialogContext) => AlertDialog(
                      title: Text(locale.wallet_delete_method_title),
                      content: Text(locale.wallet_delete_method_message),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              Navigator.of(dialogContext).pop(false),
                          child: Text(locale.cancel),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.of(dialogContext).pop(true),
                          child: Text(locale.delete),
                        ),
                      ],
                    ),
                  );
                  if (confirmed != true || !screenContext.mounted) return;
                  final success = await _viewModel.deletePaymentMethod(method.id);
                  if (!screenContext.mounted || !success) return;
                  CustomSnackbar.showSuccess(
                    context: screenContext,
                    message: successMessage,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openTransactionsPage() async {
    final screenContext = context;
    if (_viewModel.state.transactions.isEmpty) {
      await _viewModel.loadTransactions(refresh: true);
    }
    if (!screenContext.mounted) return;

    await Navigator.of(screenContext, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => WalletTransactionsScreen(viewModel: _viewModel),
      ),
    );
  }

  Future<void> _openWithdrawalsPage() async {
    final screenContext = context;
    if (_viewModel.state.withdrawals.isEmpty) {
      await _viewModel.loadWithdrawals(refresh: true);
    }
    if (!screenContext.mounted) return;

    await Navigator.of(screenContext, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => WalletWithdrawalsScreen(viewModel: _viewModel),
      ),
    );
  }

  Future<void> _openCreatePaymentMethodPage() async {
    await _showCreatePaymentMethodDialog();
  }
}

class _WalletLoadingSkeleton extends StatelessWidget {
  const _WalletLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return SkeletonStateWidget(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Container(
            height: 220,
            decoration: BoxDecoration(
              color: colors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          const SizedBox(height: 18),
          ...List.generate(
            4,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 120,
                    height: 18,
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: index == 2 ? 220 : 120,
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyWalletSection extends StatelessWidget {
  const _EmptyWalletSection({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: Center(
        child: EmptyStateWidget(
          title: title,
          description: subtitle,
          icon: icon,
        ),
      ),
    );
  }
}

class _InlineWalletAlert extends StatelessWidget {
  const _InlineWalletAlert({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.45)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: colors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
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
