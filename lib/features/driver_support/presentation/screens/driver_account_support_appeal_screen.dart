import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/errors/error_presentation.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/helpers/validators.dart';
import 'package:zadana_delivery/core/widgets/app_button.dart';
import 'package:zadana_delivery/core/widgets/custom_app_bar.dart';
import 'package:zadana_delivery/core/widgets/custom_snack_bar.dart';
import 'package:zadana_delivery/core/widgets/loading/loading_overlay.dart';
import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_reason_entity.dart';
import 'package:zadana_delivery/features/driver_support/presentation/manager/driver_account_support_appeal_cubit.dart';
import 'package:zadana_delivery/features/driver_support/presentation/manager/driver_account_support_appeal_state.dart';
import 'package:zadana_delivery/features/driver_support/presentation/models/driver_account_support_appeal_args.dart';

class DriverAccountSupportAppealScreen extends StatefulWidget {
  const DriverAccountSupportAppealScreen({super.key, this.args});

  final DriverAccountSupportAppealArgs? args;

  @override
  State<DriverAccountSupportAppealScreen> createState() =>
      _DriverAccountSupportAppealScreenState();
}

class _DriverAccountSupportAppealScreenState
    extends State<DriverAccountSupportAppealScreen> {
  final _formKey = GlobalKey<FormState>();
  late final DriverAccountSupportAppealCubit _cubit;
  late final TextEditingController _identifierController;
  final _messageController = TextEditingController();

  bool get _requiresAuthentication =>
      widget.args?.requiresAuthentication ?? true;

  bool get _isArabic => Localizations.localeOf(context).languageCode == 'ar';

  @override
  void initState() {
    super.initState();
    _cubit = getIt<DriverAccountSupportAppealCubit>();
    _identifierController = TextEditingController(
      text: widget.args?.identifier?.trim() ?? '',
    );
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _cubit.initialize(widget.args),
    );
  }

  @override
  void dispose() {
    _cubit.close();
    _identifierController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  String _reasonLabel(DriverSupportReasonEntity reason) {
    return _isArabic ? reason.labelAr : reason.labelEn;
  }

  String _selectedReasonLabel(DriverAccountSupportAppealState state) {
    final code = state.selectedReasonCode?.trim() ?? '';
    if (code.isEmpty) return '';
    for (final item in state.reasons) {
      if (item.code.trim() == code) {
        return _reasonLabel(item);
      }
    }
    return '';
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    await _cubit.submit(
      requiresAuthentication: _requiresAuthentication,
      identifier: _identifierController.text.trim(),
      message: _messageController.text.trim(),
    );
  }

  Future<void> _pickReason() async {
    final state = _cubit.state;
    if (state.isSubmitting || state.isLoadingReasons || state.reasons.isEmpty) {
      return;
    }

    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final color = Theme.of(sheetContext).colorScheme;
        return SafeArea(
          child: Container(
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            decoration: BoxDecoration(
              color: color.surface,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: color.shadow.withValues(alpha: 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: color.outlineVariant,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          context
                              .localization
                              .driver_account_support_reason_label,
                          style: getBoldStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size18,
                            color: color.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    itemBuilder: (context, index) {
                      final reason = state.reasons[index];
                      final isSelected =
                          reason.code.trim() ==
                          state.selectedReasonCode?.trim();
                      return Material(
                        color: isSelected
                            ? color.primary.withValues(alpha: 0.08)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(18),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          title: Text(
                            _reasonLabel(reason),
                            style: getSemiBoldStyle(
                              fontFamily: FontConstant.cairo,
                              fontSize: FontSize.size15,
                              color: color.onSurface,
                            ),
                          ),
                          trailing: isSelected
                              ? Icon(
                                  Icons.check_circle_rounded,
                                  color: color.primary,
                                )
                              : null,
                          onTap: () =>
                              Navigator.of(sheetContext).pop(reason.code),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 6),
                    itemCount: state.reasons.length,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted || selected == null) return;
    _cubit.selectReason(selected);
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<DriverAccountSupportAppealCubit, DriverAccountSupportAppealState>(
        listener: (context, state) {
          if (state.failure != null) {
            CustomSnackbar.showError(
              context: context,
              message: ErrorMessagePresenter.snackBarMessage(
                context,
                state.failure!.asException,
              ),
            );
            context.read<DriverAccountSupportAppealCubit>().clearFeedback();
            return;
          }

          if (state.uiError != null) {
            final message = switch (state.uiError!) {
              DriverAccountSupportAppealUiError.reasonRequired =>
                locale.driver_account_support_reason_required,
              DriverAccountSupportAppealUiError.pickFiles =>
                locale.driver_account_support_pick_files_error,
              DriverAccountSupportAppealUiError.uploadFiles =>
                locale.driver_account_support_upload_files_error,
            };
            CustomSnackbar.showError(context: context, message: message);
            context.read<DriverAccountSupportAppealCubit>().clearFeedback();
            return;
          }

          if (state.successMessage != null) {
            CustomSnackbar.showSuccess(
              context: context,
              message: state.successMessage!.resolve(isArabic: _isArabic),
            );
            _messageController.clear();
            context.read<DriverAccountSupportAppealCubit>().clearFeedback();
            Navigator.of(context).pop(true);
          }
        },
        builder: (context, state) {
          final selectedReasonLabel = _selectedReasonLabel(state);
          return Scaffold(
            backgroundColor: context.colorScheme.surface,
            appBar: CustomAppBar.modern(
              title: locale.driver_account_support_title,
            ),
            body: LoadingOverlay(
              isLoading: state.isSubmitting || state.isLoadingReasons,
              barrierColor: Colors.black.withValues(alpha: 0.16),
              child: AbsorbPointer(
                absorbing: state.isSubmitting || state.isLoadingReasons,
                child: SafeArea(
                  child: RefreshIndicator(
                    onRefresh: _cubit.loadReasons,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(
                        Spacing.base,
                        Spacing.base,
                        Spacing.base,
                        Spacing.xl,
                      ),
                      children: [
                        Text(
                          locale.driver_account_support_subtitle,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: Spacing.lg),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (!_requiresAuthentication) ...[
                                TextFormField(
                                  controller: _identifierController,
                                  enabled: !state.isSubmitting,
                                  validator: (value) =>
                                      Validations.validateRequired(
                                        context,
                                        value,
                                      ),
                                  decoration: InputDecoration(
                                    labelText: locale
                                        .driver_account_support_identifier_label,
                                    hintText: locale
                                        .driver_account_support_identifier_hint,
                                    filled: true,
                                  ),
                                ),
                                const SizedBox(height: Spacing.md),
                              ],
                              Text(
                                locale.driver_account_support_reason_label,
                                style: getSemiBoldStyle(
                                  fontFamily: FontConstant.cairo,
                                  color: context.colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: Spacing.sm),
                              InkWell(
                                onTap: _pickReason,
                                borderRadius: BorderRadius.circular(
                                  Spacing.inputRadius,
                                ),
                                child: Ink(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: Spacing.base,
                                    vertical: Spacing.md,
                                  ),
                                  decoration: BoxDecoration(
                                    color: context.colorScheme.surface,
                                    borderRadius: BorderRadius.circular(
                                      Spacing.inputRadius,
                                    ),
                                    border: Border.all(
                                      color: context.colorScheme.outline
                                          .withValues(alpha: 0.2),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          selectedReasonLabel.isNotEmpty
                                              ? selectedReasonLabel
                                              : locale
                                                    .driver_account_support_reason_required,
                                          style: getRegularStyle(
                                            fontFamily: FontConstant.cairo,
                                            fontSize: FontSize.size14,
                                            color:
                                                selectedReasonLabel.isNotEmpty
                                                ? context.colorScheme.onSurface
                                                : context.colorScheme.onSurface
                                                      .withValues(alpha: 0.5),
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: context
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (state.reasons.isEmpty &&
                                  !state.isLoadingReasons) ...[
                                const SizedBox(height: Spacing.sm),
                                Text(
                                  locale.driver_account_support_empty_reasons,
                                  style: context.textTheme.bodySmall?.copyWith(
                                    color: context.colorScheme.error,
                                  ),
                                ),
                              ],
                              const SizedBox(height: Spacing.md),
                              TextFormField(
                                controller: _messageController,
                                enabled: !state.isSubmitting,
                                maxLines: 5,
                                textInputAction: TextInputAction.newline,
                                validator: (value) =>
                                    Validations.validateRequired(
                                      context,
                                      value,
                                    ),
                                decoration: InputDecoration(
                                  labelText: locale
                                      .driver_account_support_message_label,
                                  hintText: locale
                                      .driver_account_support_message_hint,
                                  alignLabelWithHint: true,
                                  filled: true,
                                ),
                              ),
                              const SizedBox(height: Spacing.md),
                              OutlinedButton.icon(
                                onPressed: state.isSubmitting
                                    ? null
                                    : _cubit.pickImages,
                                icon: const Icon(Icons.attach_file_rounded),
                                label: Text(
                                  state.selectedImages.isEmpty
                                      ? locale
                                            .driver_account_support_attach_files
                                      : locale
                                            .driver_account_support_attach_more_files,
                                ),
                              ),
                              if (state.selectedImages.isNotEmpty) ...[
                                const SizedBox(height: Spacing.sm),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: state.selectedImages
                                      .map(
                                        (image) => _SelectedAttachmentChip(
                                          image: image,
                                          onRemove: () =>
                                              _cubit.removeImage(image),
                                        ),
                                      )
                                      .toList(growable: false),
                                ),
                              ],
                              const SizedBox(height: Spacing.xl),
                              AppButton.filled(
                                text:
                                    widget.args?.buttonLabel
                                            ?.trim()
                                            .isNotEmpty ==
                                        true
                                    ? widget.args!.buttonLabel!.trim()
                                    : locale.driver_account_support_submit,
                                onPressed: state.isLoadingReasons
                                    ? null
                                    : _submit,
                                height: 52,
                                borderRadius: 18,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SelectedAttachmentChip extends StatelessWidget {
  const _SelectedAttachmentChip({required this.image, required this.onRemove});

  final XFile image;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    final fileName = image.path.split(RegExp(r'[\\/]')).last;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              fileName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: onRemove,
            borderRadius: BorderRadius.circular(999),
            child: Icon(
              Icons.close_rounded,
              size: 16,
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
