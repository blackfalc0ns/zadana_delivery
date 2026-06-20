import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/errors/error_presentation.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/core/services/file_upload_service.dart';
import 'package:zadana_delivery/core/widgets/app_button.dart';
import 'package:zadana_delivery/core/widgets/custom_snack_bar.dart';
import 'package:zadana_delivery/core/widgets/loading/loading_overlay.dart';
import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_attachment_entity.dart';
import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_reason_entity.dart';
import 'package:zadana_delivery/features/driver_support/domain/usecase/get_driver_support_reasons_usecase.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_support/order_support_attachments_section.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_support/order_support_mode.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_support/order_support_mode_tile.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_support/order_support_reason_field.dart';

/// The main support composer form that lets the driver create
/// an issue report or financial dispute for an order.
class OrderSupportComposer extends StatefulWidget {
  const OrderSupportComposer({
    super.key,
    required this.loadingContext,
    required this.onSubmit,
  });

  /// Context used to show/hide the loading overlay.
  final BuildContext loadingContext;

  /// Callback invoked on submission. Returns true if submission succeeded.
  final Future<bool> Function(
    OrderSupportMode mode,
    String reasonCode,
    String message,
    List<DriverSupportAttachmentEntity> attachments,
  ) onSubmit;

  @override
  State<OrderSupportComposer> createState() => _OrderSupportComposerState();
}

class _OrderSupportComposerState extends State<OrderSupportComposer> {
  late final TextEditingController _messageController;
  final ImagePicker _imagePicker = getIt<ImagePicker>();
  final FileUploadService _fileUploadService = getIt<FileUploadService>();
  final GetDriverSupportReasonsUseCase _getSupportReasonsUseCase =
      getIt<GetDriverSupportReasonsUseCase>();
  final Map<String, List<DriverSupportReasonEntity>> _reasonsCache =
      <String, List<DriverSupportReasonEntity>>{};

  OrderSupportMode _mode = OrderSupportMode.issue;
  String? _selectedReasonCode;
  bool _isSubmitting = false;
  bool _isLoadingReasons = false;
  String? _reasonsErrorMessage;
  List<XFile> _selectedImages = const <XFile>[];

  List<DriverSupportReasonEntity> get _reasonOptions =>
      _reasonsCache[_mode.reasonType] ?? const <DriverSupportReasonEntity>[];

  DriverSupportReasonEntity? get _selectedReason {
    final code = _selectedReasonCode;
    if (code == null) return null;
    for (final option in _reasonOptions) {
      if (option.code == code) return option;
    }
    return null;
  }

  bool get _requiresNote => _selectedReason?.requiresNote ?? false;
  bool get _hasReasons => _reasonOptions.isNotEmpty;
  bool get _canSubmit => !_isSubmitting && !_isLoadingReasons && _hasReasons;

  String _reasonLabel(DriverSupportReasonEntity option) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return isArabic ? option.labelAr : option.labelEn;
  }

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    unawaited(_loadReasonsForMode(_mode));
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  // ─── Reason loading ──────────────────────────────────────────────────

  Future<void> _loadReasonsForMode(
    OrderSupportMode mode, {
    bool forceRefresh = false,
  }) async {
    final type = mode.reasonType;
    if (!forceRefresh && _reasonsCache.containsKey(type)) {
      final options = _reasonsCache[type]!;
      if (mounted) {
        setState(() {
          _reasonsErrorMessage = null;
          if (mode == _mode) {
            _selectedReasonCode = _resolveNextSelectedReasonCode(
              options,
              _selectedReasonCode,
            );
          }
        });
      }
      return;
    }

    if (mounted) {
      setState(() {
        _isLoadingReasons = true;
        _reasonsErrorMessage = null;
        if (mode == _mode) {
          _selectedReasonCode = null;
        }
      });
    }

    final result = await _getSupportReasonsUseCase.call(type);
    if (!mounted) return;

    switch (result) {
      case ApiSuccessResult<List<DriverSupportReasonEntity>>():
        final options = result.data;
        setState(() {
          _isLoadingReasons = false;
          _reasonsErrorMessage = null;
          _reasonsCache[type] = options;
          if (mode == _mode) {
            _selectedReasonCode = _resolveNextSelectedReasonCode(
              options,
              _selectedReasonCode,
            );
          }
        });
      case ApiErrorResult<List<DriverSupportReasonEntity>>():
        setState(() {
          _isLoadingReasons = false;
          _reasonsErrorMessage = ErrorMessagePresenter.snackBarMessage(
            context,
            result.failure.asException,
          );
        });
    }
  }

  String? _resolveNextSelectedReasonCode(
    List<DriverSupportReasonEntity> options,
    String? currentCode,
  ) {
    if (options.isEmpty) return null;
    for (final option in options) {
      if (option.code == currentCode) return currentCode;
    }
    return options.first.code;
  }

  // ─── Mode switching ──────────────────────────────────────────────────

  void _changeMode(OrderSupportMode mode) {
    if (_isSubmitting || mode == _mode) return;
    setState(() {
      _mode = mode;
      _selectedReasonCode = null;
      _reasonsErrorMessage = null;
    });
    unawaited(_loadReasonsForMode(mode));
  }

  // ─── Submit ──────────────────────────────────────────────────────────

  Future<void> _submit() async {
    final locale = context.localization;
    final reasonCode = (_selectedReasonCode ?? '').trim();
    final message = _messageController.text.trim();

    if (_isLoadingReasons) return;

    if ((_reasonsErrorMessage ?? '').trim().isNotEmpty) {
      CustomSnackbar.showError(
        context: context,
        message: locale.order_support_error_reasons_loading,
      );
      return;
    }
    if (!_hasReasons) {
      CustomSnackbar.showError(
        context: context,
        message: locale.order_support_error_no_reasons,
      );
      return;
    }
    if (reasonCode.isEmpty) {
      CustomSnackbar.showError(
        context: context,
        message: locale.order_support_error_choose_reason,
      );
      return;
    }
    if (_requiresNote && message.isEmpty) {
      CustomSnackbar.showError(
        context: context,
        message: locale.order_support_error_message_required,
      );
      return;
    }

    setState(() => _isSubmitting = true);
    LoadingOverlay.show(widget.loadingContext);
    try {
      final attachments = await _uploadSelectedImages();
      final success = await widget.onSubmit(
        _mode,
        reasonCode,
        message,
        attachments,
      );
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      if (success) {
        Navigator.of(context).pop(_mode.name);
      }
    } catch (error) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      CustomSnackbar.showError(
        context: context,
        message: error is Exception
            ? error.toString().replaceFirst('Exception: ', '')
            : locale.order_support_error_upload_failed,
      );
    } finally {
      if (widget.loadingContext.mounted) {
        LoadingOverlay.hide(widget.loadingContext);
      }
    }
  }

  // ─── Image picking ───────────────────────────────────────────────────

  Future<void> _pickImages() async {
    if (_isSubmitting) return;
    final locale = context.localization;

    try {
      final images = await _imagePicker.pickMultiImage(imageQuality: 82);
      if (!mounted || images.isEmpty) return;
      setState(() {
        final existingPaths = _selectedImages.map((item) => item.path).toSet();
        final merged = List<XFile>.from(_selectedImages);
        for (final image in images) {
          if (existingPaths.add(image.path)) {
            merged.add(image);
          }
        }
        _selectedImages = merged;
      });
    } catch (_) {
      if (!mounted) return;
      CustomSnackbar.showError(
        context: context,
        message: locale.order_support_error_picker_failed,
      );
    }
  }

  Future<List<DriverSupportAttachmentEntity>> _uploadSelectedImages() async {
    if (_selectedImages.isEmpty) return const <DriverSupportAttachmentEntity>[];

    final attachments = <DriverSupportAttachmentEntity>[];
    for (final image in _selectedImages) {
      final url = await _fileUploadService.uploadFile(
        image.path,
        directory: DriverUploadDirectory.proofs,
      );
      final file = File(image.path);
      final fileName = file.uri.pathSegments.isEmpty
          ? 'attachment.jpg'
          : file.uri.pathSegments.last;
      attachments.add(
        DriverSupportAttachmentEntity(fileName: fileName, fileUrl: url),
      );
    }
    return attachments;
  }

  void _removeImage(XFile image) {
    if (_isSubmitting) return;
    setState(() {
      _selectedImages = _selectedImages
          .where((item) => item.path != image.path)
          .toList(growable: false);
    });
  }

  // ─── Build ───────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final locale = context.localization;

    final messageLabel = _requiresNote
        ? locale.order_support_message_label_required
        : locale.order_support_message_label_optional;

    final submitLabel = _mode == OrderSupportMode.issue
        ? locale.order_support_submit_issue
        : locale.order_support_submit_dispute;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildDragHandle(scheme),
          _buildHeader(theme, scheme, locale),
          const SizedBox(height: 14),
          const SizedBox(height: 2),
          _buildModeSelector(scheme, locale),
          const SizedBox(height: 14),
          OrderSupportReasonField(
            isLoading: _isLoadingReasons,
            errorMessage: _reasonsErrorMessage,
            reasons: _reasonOptions,
            selectedReasonCode: _selectedReasonCode,
            isSubmitting: _isSubmitting,
            reasonLabelBuilder: _reasonLabel,
            onChanged: (value) => setState(() => _selectedReasonCode = value),
            onRetry: () => _loadReasonsForMode(_mode, forceRefresh: true),
          ),
          const SizedBox(height: 12),
          _buildMessageField(theme, scheme, messageLabel),
          const SizedBox(height: 14),
          OrderSupportAttachmentsSection(
            selectedImages: _selectedImages,
            isSubmitting: _isSubmitting,
            onPickImages: _pickImages,
            onRemoveImage: _removeImage,
          ),
          const SizedBox(height: 16),
          _buildActions(scheme, locale, submitLabel),
        ],
      ),
    );
  }

  Widget _buildDragHandle(ColorScheme scheme) {
    return Center(
      child: Container(
        width: 54,
        height: 5,
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: scheme.outlineVariant.withValues(alpha: 0.22),
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme scheme, dynamic locale) {
    return Column(
      children: [
        Center(
          child: Text(
            locale.order_support_composer_title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 17,
              letterSpacing: -0.3,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Center(
          child: Text(
            locale.order_support_composer_subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
              height: 1.4,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildModeSelector(ColorScheme scheme, dynamic locale) {
    return Row(
      children: [
        Expanded(
          child: OrderSupportModeTile(
            title: locale.order_support_mode_issue_title,
            subtitle: locale.order_support_mode_issue_subtitle,
            icon: Icons.report_problem_outlined,
            isSelected: _mode == OrderSupportMode.issue,
            selectedColor: scheme.primary,
            onTap: _isSubmitting
                ? null
                : () => _changeMode(OrderSupportMode.issue),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OrderSupportModeTile(
            title: locale.order_support_mode_dispute_title,
            subtitle: locale.order_support_mode_dispute_subtitle,
            icon: Icons.gavel_rounded,
            isSelected: _mode == OrderSupportMode.dispute,
            selectedColor: scheme.secondary,
            onTap: _isSubmitting
                ? null
                : () => _changeMode(OrderSupportMode.dispute),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageField(
    ThemeData theme,
    ColorScheme scheme,
    String messageLabel,
  ) {
    final locale = context.localization;
    return TextField(
      controller: _messageController,
      maxLines: 3,
      minLines: 3,
      textInputAction: TextInputAction.newline,
      decoration: InputDecoration(
        labelText: messageLabel,
        alignLabelWithHint: true,
        hintText: locale.order_support_message_hint,
        hintStyle: theme.textTheme.titleMedium?.copyWith(
          color: scheme.onSurfaceVariant.withValues(alpha: 0.48),
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: scheme.outlineVariant.withValues(alpha: 0.28),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        helperText: _requiresNote ? locale.order_support_message_helper : null,
      ),
    );
  }

  Widget _buildActions(
    ColorScheme scheme,
    dynamic locale,
    String submitLabel,
  ) {
    return Row(
      children: [
        Expanded(
          child: AppButton.outlined(
            text: locale.cancel,
            height: 50,
            borderRadius: 12,
            color: scheme.outline,
            textColor: scheme.onSurface,
            onPressed:
                _isSubmitting ? null : () => Navigator.of(context).maybePop(),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: AppButton.filled(
            text: submitLabel,
            height: 50,
            borderRadius: 12,
            color: scheme.primary,
            textColor: Colors.white,
            onPressed: _canSubmit ? _submit : null,
          ),
        ),
      ],
    );
  }
}
