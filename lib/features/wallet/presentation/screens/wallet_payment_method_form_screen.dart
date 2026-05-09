import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/app_button.dart';
import 'package:zadana_delivery/core/widgets/custom_app_bar.dart';
import 'package:zadana_delivery/core/widgets/custom_progress_indicator.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_payout_method_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_payout_method_upsert_request_entity.dart';
import 'package:zadana_delivery/features/wallet/presentation/manager/wallet_view_model.dart';

class WalletPaymentMethodFormScreen extends StatefulWidget {
  const WalletPaymentMethodFormScreen({
    super.key,
    required this.viewModel,
    this.existingMethod,
  });

  final WalletViewModel viewModel;
  final DriverPayoutMethodEntity? existingMethod;

  @override
  State<WalletPaymentMethodFormScreen> createState() =>
      _WalletPaymentMethodFormScreenState();
}

class _WalletPaymentMethodFormScreenState
    extends State<WalletPaymentMethodFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _holderController;
  late final TextEditingController _providerController;
  final TextEditingController _identifierController = TextEditingController();
  String _type = 'BankAccount';
  bool _isPrimary = false;

  bool get _isEditing => widget.existingMethod != null;

  @override
  void initState() {
    super.initState();
    _type = widget.existingMethod?.type.isNotEmpty == true
        ? widget.existingMethod!.type
        : 'BankAccount';
    _isPrimary = widget.existingMethod?.isPrimary ?? false;
    _holderController = TextEditingController(
      text: widget.existingMethod?.accountHolderName ?? '',
    );
    _providerController = TextEditingController(
      text: widget.existingMethod?.providerName ?? '',
    );
  }

  @override
  void dispose() {
    _holderController.dispose();
    _providerController.dispose();
    _identifierController.dispose();
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
                (viewModel) => viewModel.state.isSubmittingPaymentMethod,
              );
              return Stack(
                children: [
                  Column(
                    children: [
                      CustomAppBar.modern(
                        title: _isEditing
                            ? locale.wallet_edit_method_title
                            : locale.wallet_add_method,
                        onBackPressed: () => Navigator.of(context).maybePop(),
                      ),
                      Expanded(
                        child: Form(
                          key: _formKey,
                          child: ListView(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                            children: [
                              _WalletFormCard(
                                title: locale.wallet_type_label,
                                child: DropdownButtonFormField<String>(
                                  initialValue: _type,
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'BankAccount',
                                      child: Text('Bank Account'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'DebitCard',
                                      child: Text('Debit Card'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'InstantTransfer',
                                      child: Text('Instant Transfer'),
                                    ),
                                  ],
                                  onChanged: isBusy
                                      ? null
                                      : (value) => setState(
                                          () => _type = value ?? _type,
                                        ),
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              _WalletFormCard(
                                title: locale.wallet_account_holder_label,
                                child: TextFormField(
                                  controller: _holderController,
                                  autocorrect: false,
                                  enableSuggestions: false,
                                  decoration: InputDecoration(
                                    hintText: locale.wallet_account_holder_label,
                                    border: const OutlineInputBorder(),
                                  ),
                                  validator: (value) =>
                                      (value == null || value.trim().isEmpty)
                                      ? locale.this_field_is_required
                                      : null,
                                ),
                              ),
                              const SizedBox(height: 14),
                              _WalletFormCard(
                                title: locale.wallet_provider_name_label,
                                child: TextFormField(
                                  controller: _providerController,
                                  autocorrect: false,
                                  enableSuggestions: false,
                                  decoration: InputDecoration(
                                    hintText: locale.wallet_provider_name_label,
                                    border: const OutlineInputBorder(),
                                  ),
                                  validator: (value) =>
                                      (value == null || value.trim().isEmpty)
                                      ? locale.this_field_is_required
                                      : null,
                                ),
                              ),
                              const SizedBox(height: 14),
                              _WalletFormCard(
                                title: locale.wallet_account_identifier_label,
                                subtitle: _isEditing
                                    ? locale.wallet_identifier_reentry_hint
                                    : locale.wallet_identifier_secure_hint,
                                child: TextFormField(
                                  controller: _identifierController,
                                  autocorrect: false,
                                  enableSuggestions: false,
                                  decoration: InputDecoration(
                                    hintText:
                                        locale.wallet_account_identifier_label,
                                    border: const OutlineInputBorder(),
                                  ),
                                  validator: (value) =>
                                      (value == null || value.trim().isEmpty)
                                      ? locale.this_field_is_required
                                      : null,
                                ),
                              ),
                              const SizedBox(height: 14),
                              if (!_isEditing)
                                _WalletFormCard(
                                  title: locale.wallet_primary_method,
                                  child: SwitchListTile.adaptive(
                                    value: _isPrimary,
                                    contentPadding: EdgeInsets.zero,
                                    onChanged: isBusy
                                        ? null
                                        : (value) => setState(
                                            () => _isPrimary = value,
                                          ),
                                    title: Text(locale.wallet_primary_method),
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
                                text: _isEditing
                                    ? locale.profile_update_action
                                    : locale.wallet_save_action,
                                onPressed: isBusy
                                    ? null
                                    : () {
                                        if (!_formKey.currentState!.validate()) {
                                          return;
                                        }
                                        Navigator.of(context).pop(
                                          DriverPayoutMethodUpsertRequestEntity(
                                            type: _type,
                                            accountHolderName:
                                                _holderController.text.trim(),
                                            accountIdentifier:
                                                _identifierController.text
                                                    .trim(),
                                            providerName:
                                                _providerController.text.trim(),
                                            isPrimary:
                                                _isEditing ? null : _isPrimary,
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

class _WalletFormCard extends StatelessWidget {
  const _WalletFormCard({
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
