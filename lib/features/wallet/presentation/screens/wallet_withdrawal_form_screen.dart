import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/app_button.dart';
import 'package:zadana_delivery/core/widgets/custom_app_bar.dart';
import 'package:zadana_delivery/core/widgets/custom_progress_indicator.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_payout_method_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_wallet_create_withdrawal_request_entity.dart';
import 'package:zadana_delivery/features/wallet/presentation/manager/wallet_view_model.dart';

class WalletWithdrawalFormScreen extends StatefulWidget {
  const WalletWithdrawalFormScreen({
    super.key,
    required this.viewModel,
    required this.availableBalance,
    required this.primaryMethod,
  });

  final WalletViewModel viewModel;
  final double availableBalance;
  final DriverPayoutMethodEntity? primaryMethod;

  @override
  State<WalletWithdrawalFormScreen> createState() =>
      _WalletWithdrawalFormScreenState();
}

class _WalletWithdrawalFormScreenState extends State<WalletWithdrawalFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  bool _usePrimary = true;
  DriverPayoutMethodEntity? _selectedMethod;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final methods = widget.viewModel.paymentMethods;

    return BlocProvider.value(
      value: widget.viewModel,
      child: Scaffold(
        body: SafeArea(
          top: false,
          child: BlocBuilder<WalletViewModel, dynamic>(
            builder: (context, _) {
              final isBusy = context.select<WalletViewModel, bool>(
                (viewModel) => viewModel.state.isSubmittingWithdrawal,
              );
              return Stack(
                children: [
                  Column(
                    children: [
                      CustomAppBar.modern(
                        title: locale.wallet_withdraw_title,
                        onBackPressed: () => Navigator.of(context).maybePop(),
                      ),
                      Expanded(
                        child: Form(
                          key: _formKey,
                          child: ListView(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                            children: [
                              _WithdrawInfoCard(
                                availableBalance: widget.availableBalance,
                              ),
                              const SizedBox(height: 14),
                              _WithdrawFormCard(
                                title: locale.wallet_amount_label,
                                subtitle: locale.wallet_withdraw_amount_subtitle,
                                child: TextFormField(
                                  controller: _amountController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  autocorrect: false,
                                  enableSuggestions: false,
                                  decoration: InputDecoration(
                                    hintText: locale.wallet_amount_hint,
                                    border: const OutlineInputBorder(),
                                    suffixText: locale.currency,
                                  ),
                                  validator: (value) {
                                    final text = value?.trim() ?? '';
                                    if (text.isEmpty) {
                                      return locale.this_field_is_required;
                                    }
                                    final amount = double.tryParse(text);
                                    if (amount == null || amount <= 0) {
                                      return locale.wallet_amount_invalid;
                                    }
                                    if (amount > widget.availableBalance) {
                                      return locale.wallet_amount_exceeds_balance;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 14),
                              _WithdrawFormCard(
                                title: locale.wallet_use_primary_method,
                                subtitle: locale.wallet_withdraw_method_subtitle,
                                child: Column(
                                  children: [
                                    SwitchListTile.adaptive(
                                      value: _usePrimary,
                                      contentPadding: EdgeInsets.zero,
                                      onChanged: methods.isEmpty || isBusy
                                          ? null
                                          : (value) => setState(
                                              () => _usePrimary = value,
                                            ),
                                      title: Text(
                                        locale.wallet_use_primary_method,
                                      ),
                                      subtitle: Text(
                                        widget.primaryMethod?.maskedLabel ??
                                            locale.wallet_no_primary_method,
                                      ),
                                    ),
                                    if (!_usePrimary) ...[
                                      const SizedBox(height: 10),
                                      DropdownButtonFormField<
                                        DriverPayoutMethodEntity
                                      >(
                                        initialValue: _selectedMethod,
                                        items: methods
                                            .map(
                                              (item) => DropdownMenuItem(
                                                value: item,
                                                child: Text(item.maskedLabel),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: isBusy
                                            ? null
                                            : (value) => setState(
                                                () => _selectedMethod = value,
                                              ),
                                        validator: (value) => value == null
                                            ? locale.wallet_select_method
                                            : null,
                                        decoration: InputDecoration(
                                          labelText:
                                              locale.wallet_payment_methods,
                                          border: const OutlineInputBorder(),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SafeArea(
                        top: false,
                        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: AppButton.outlined(
                                text: locale.cancel,
                                onPressed: isBusy
                                    ? null
                                    : () => Navigator.of(context).maybePop(),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: AppButton.filled(
                                text: locale.wallet_withdraw_cta,
                                onPressed: isBusy
                                    ? null
                                    : () {
                                        if (!_formKey.currentState!.validate()) {
                                          return;
                                        }
                                        if (_usePrimary &&
                                            widget.primaryMethod == null) {
                                          return;
                                        }
                                        Navigator.of(context).pop(
                                          DriverWalletCreateWithdrawalRequestEntity(
                                            paymentMethodId: _usePrimary
                                                ? null
                                                : _selectedMethod?.id,
                                            amount: double.parse(
                                              _amountController.text.trim(),
                                            ),
                                          ),
                                        );
                                      },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (isBusy)
                    Positioned.fill(
                      child: ColoredBox(
                        color: Colors.black.withValues(alpha: 0.12),
                        child: const Center(child: CustomProgressIndicator()),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _WithdrawInfoCard extends StatelessWidget {
  const _WithdrawInfoCard({required this.availableBalance});

  final double availableBalance;

  @override
  Widget build(BuildContext context) {
    final localeName = Localizations.localeOf(context).toLanguageTag();
    final amount = NumberFormat.currency(
      locale: localeName,
      symbol: '${context.localization.currency} ',
      decimalDigits: availableBalance.truncateToDouble() == availableBalance
          ? 0
          : 2,
    ).format(availableBalance);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0B8FA3),
            Color(0xFF05657D),
            Color(0xFF02384E),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.localization.wallet_available_to_withdraw,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.78),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            context.localization.wallet_withdraw_info_hint,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.78),
            ),
          ),
        ],
      ),
    );
  }
}

class _WithdrawFormCard extends StatelessWidget {
  const _WithdrawFormCard({
    required this.title,
    required this.child,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 6),
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}
