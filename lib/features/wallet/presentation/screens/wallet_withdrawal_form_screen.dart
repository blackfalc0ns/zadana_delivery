import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/app_button.dart';
import 'package:zadana_delivery/core/widgets/custom_app_bar.dart';
import 'package:zadana_delivery/core/widgets/custom_progress_indicator.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_payout_method_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_wallet_create_withdrawal_request_entity.dart';
import 'package:zadana_delivery/features/wallet/presentation/manager/wallet_view_model.dart';
import 'package:zadana_delivery/features/wallet/presentation/wallet_ui_labels.dart';

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

class _WalletWithdrawalFormScreenState
    extends State<WalletWithdrawalFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String? _selectedMethodId;

  List<DriverPayoutMethodEntity> get _methods =>
      widget.viewModel.paymentMethods;

  @override
  void initState() {
    super.initState();
    _selectedMethodId = widget.primaryMethod?.id;
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

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
              final selectedMethod = _selectedMethod;

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
                              const SizedBox(height: 16),
                              _WithdrawFormCard(
                                title: locale.wallet_amount_label,
                                subtitle:
                                    locale.wallet_withdraw_amount_subtitle,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFormField(
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
                                          return locale
                                              .wallet_amount_exceeds_balance;
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: [
                                        _AmountPresetChip(
                                          label: '25%',
                                          onTap: () => _applyPreset(0.25),
                                        ),
                                        _AmountPresetChip(
                                          label: '50%',
                                          onTap: () => _applyPreset(0.5),
                                        ),
                                        _AmountPresetChip(
                                          label: '100%',
                                          onTap: () => _applyPreset(1),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              _WithdrawFormCard(
                                title: locale.wallet_payment_methods,
                                subtitle:
                                    locale.wallet_withdraw_method_subtitle,
                                child: Column(
                                  children: [
                                    if (_methods.isEmpty)
                                      _InlineErrorNote(
                                        message: locale
                                            .wallet_withdraw_blocked_no_primary,
                                      )
                                    else
                                      ..._methods.map(
                                        (method) => Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 10,
                                          ),
                                          child: _MethodSelectionTile(
                                            item: method,
                                            isSelected:
                                                _selectedMethodId == method.id,
                                            onTap: isBusy
                                                ? null
                                                : () => setState(
                                                    () => _selectedMethodId =
                                                        method.id,
                                                  ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              if (selectedMethod != null) ...[
                                const SizedBox(height: 16),
                                _WithdrawFormCard(
                                  title: locale.wallet_use_primary_method,
                                  child: _SelectedMethodSummary(
                                    method: selectedMethod,
                                  ),
                                ),
                              ],
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
                                onPressed: isBusy || selectedMethod == null
                                    ? null
                                    : () {
                                        if (!_formKey.currentState!
                                            .validate()) {
                                          return;
                                        }
                                        Navigator.of(context).pop(
                                          DriverWalletCreateWithdrawalRequestEntity(
                                            paymentMethodId:
                                                selectedMethod.isPrimary
                                                ? null
                                                : selectedMethod.id,
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

  DriverPayoutMethodEntity? get _selectedMethod {
    for (final method in _methods) {
      if (method.id == _selectedMethodId) return method;
    }
    return widget.primaryMethod;
  }

  void _applyPreset(double ratio) {
    final amount = widget.availableBalance * ratio;
    final decimalDigits = amount.truncateToDouble() == amount ? 0 : 2;
    final text = amount.toStringAsFixed(decimalDigits);
    setState(() => _amountController.text = text);
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0B8FA3), Color(0xFF05657D), Color(0xFF02384E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
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
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 6),
            Text(
              subtitle!,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
            ),
          ],
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _AmountPresetChip extends StatelessWidget {
  const _AmountPresetChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: colors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: colors.primary.withValues(alpha: 0.12)),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: colors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _MethodSelectionTile extends StatelessWidget {
  const _MethodSelectionTile({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final DriverPayoutMethodEntity item;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final highlightColor = item.isVerified
        ? AppColors.success
        : AppColors.warning;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Ink(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.primary.withValues(alpha: 0.07)
              : colors.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected
                ? colors.primary
                : colors.outlineVariant.withValues(alpha: 0.32),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(_iconForType(item.type), color: colors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.localization.walletPaymentMethodLabel(item.type),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.maskedLabel,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _MethodBadge(
                        text: item.isPrimary
                            ? context.localization.wallet_primary_method
                            : item.providerName,
                        color: colors.primary,
                      ),
                      _MethodBadge(
                        text: item.isVerified
                            ? context.localization.wallet_status_completed
                            : context.localization.wallet_unverified_method,
                        color: highlightColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? colors.primary : Colors.transparent,
                border: Border.all(
                  color: isSelected ? colors.primary : colors.outlineVariant,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check_rounded,
                      size: 14,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconForType(String type) {
    switch (type.trim().toLowerCase()) {
      case 'bankaccount':
        return Icons.account_balance_rounded;
      case 'mobilewallet':
        return Icons.phone_android_rounded;
      case 'debitcard':
        return Icons.credit_card_rounded;
      case 'instanttransfer':
      default:
        return Icons.bolt_rounded;
    }
  }
}

class _MethodBadge extends StatelessWidget {
  const _MethodBadge({required this.text, required this.color});

  final String text;
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
        text,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SelectedMethodSummary extends StatelessWidget {
  const _SelectedMethodSummary({required this.method});

  final DriverPayoutMethodEntity method;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withValues(alpha: 0.36),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            method.maskedLabel,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            method.providerName,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _InlineErrorNote extends StatelessWidget {
  const _InlineErrorNote({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        message,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: colors.error),
      ),
    );
  }
}
