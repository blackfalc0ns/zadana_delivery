import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/errors/error_presentation.dart';
import 'package:zadana_delivery/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/custom_app_bar.dart';
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
import 'package:zadana_delivery/features/wallet/presentation/widgets/wallet_screen_content.dart';

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
                    child: WalletScreenContent(
                      state: state,
                      viewModel: _viewModel,
                      onRefresh: _viewModel.refreshWallet,
                      onOpenTransactions: _openTransactionsPage,
                      onOpenWithdrawals: _openWithdrawalsPage,
                      onOpenCreatePaymentMethod: _openCreatePaymentMethodPage,
                      onOpenWithdrawal: _openWithdrawalPage,
                      onShowPaymentMethodActions: _showPaymentMethodActionsById,
                      formatCurrency: (value) => _formatCurrency(context, value),
                      formatSignedCurrency: (value, isIncoming) =>
                          _formatSignedCurrency(context, value, isIncoming),
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
    final blockMessage = _withdrawalBlockMessage(context);
    if (!_viewModel.canRequestWithdrawal) {
      if (blockMessage != null) {
        CustomSnackbar.showError(context: context, message: blockMessage);
      }
      return;
    }

    final request = await Navigator.of(context)
        .push<DriverWalletCreateWithdrawalRequestEntity>(
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
    if (!mounted || !success) return;

    CustomSnackbar.showInfo(
      context: context,
      message: context.localization.wallet_method_pending_approval,
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
    if (!mounted || !success) return;

    CustomSnackbar.showInfo(
      context: context,
      message: context.localization.wallet_method_pending_approval,
    );
  }

  Future<void> _showPaymentMethodActions(
    DriverPayoutMethodEntity method,
  ) async {
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
                    Navigator.of(sheetContext).pop();
                    final success = await _viewModel.makePrimary(method.id);
                    if (!screenContext.mounted || !success) return;
                    CustomSnackbar.showInfo(
                      context: screenContext,
                      message: screenContext.localization.wallet_method_pending_approval,
                    );
                  },
                ),
              ListTile(
                leading: const Icon(Icons.delete_outline_rounded),
                title: Text(locale.delete),
                onTap: () async {
                  final screenContext = context;
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
                  final success = await _viewModel.deletePaymentMethod(
                    method.id,
                  );
                  if (!screenContext.mounted || !success) return;
                  CustomSnackbar.showInfo(
                    context: screenContext,
                    message: screenContext.localization.wallet_method_pending_approval,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showPaymentMethodActionsById(String methodId) async {
    DriverPayoutMethodEntity? method;
    for (final item in _viewModel.paymentMethods) {
      if (item.id == methodId) {
        method = item;
        break;
      }
    }
    if (method == null) return;
    await _showPaymentMethodActions(method);
  }

  Future<void> _openTransactionsPage() async {
    final screenContext = context;
    await _viewModel.ensureTransactionsLoaded();
    if (!screenContext.mounted) return;

    await Navigator.of(screenContext, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => WalletTransactionsScreen(viewModel: _viewModel),
      ),
    );
  }

  Future<void> _openWithdrawalsPage() async {
    final screenContext = context;
    await _viewModel.ensureWithdrawalsLoaded();
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

  String? _withdrawalBlockMessage(BuildContext context) {
    switch (_viewModel.withdrawalBlockReason) {
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
}
