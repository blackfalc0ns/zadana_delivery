import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zadana_delivery/config/routing/routing_extensions.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/errors/error_presentation.dart';
import 'package:zadana_delivery/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/services/file_upload_service.dart';
import 'package:zadana_delivery/core/widgets/custom_app_bar.dart';
import 'package:zadana_delivery/core/widgets/custom_snack_bar.dart';
import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_attachment_entity.dart';
import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_case_entity.dart';
import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_case_message_request_entity.dart';
import 'package:zadana_delivery/features/driver_support/presentation/manager/driver_support_cubit.dart';
import 'package:zadana_delivery/features/driver_support/presentation/manager/driver_support_event.dart';
import 'package:zadana_delivery/features/driver_support/presentation/manager/driver_support_state.dart';
import 'package:zadana_delivery/features/driver_support/presentation/widgets/driver_support_case_details/driver_support_activity_tile.dart';
import 'package:zadana_delivery/features/driver_support/presentation/widgets/driver_support_case_details/driver_support_attachment_tile.dart';
import 'package:zadana_delivery/features/driver_support/presentation/widgets/driver_support_case_details/driver_support_case_details_hero.dart';
import 'package:zadana_delivery/features/driver_support/presentation/widgets/driver_support_case_details/driver_support_case_details_loading_view.dart';
import 'package:zadana_delivery/features/driver_support/presentation/widgets/driver_support_case_details/driver_support_case_section_card.dart';
import 'package:zadana_delivery/features/driver_support/presentation/widgets/driver_support_case_details/driver_support_follow_up_form.dart';

class DriverSupportCaseDetailsScreen extends StatefulWidget {
  const DriverSupportCaseDetailsScreen({super.key, required this.initialCase});

  final DriverSupportCaseEntity initialCase;

  @override
  State<DriverSupportCaseDetailsScreen> createState() =>
      _DriverSupportCaseDetailsScreenState();
}

class _DriverSupportCaseDetailsScreenState
    extends State<DriverSupportCaseDetailsScreen> {
  late final DriverSupportCubit _cubit;
  late final TextEditingController _messageController;
  final ImagePicker _imagePicker = getIt<ImagePicker>();
  final FileUploadService _fileUploadService = getIt<FileUploadService>();
  String _selectedReasonCode = 'follow_up';
  List<XFile> _selectedImages = const <XFile>[];

  bool get _isArabic => Localizations.localeOf(context).languageCode == 'ar';

  static const List<String> _followUpReasonCodes = [
    'follow_up',
    'additional_info',
    'proof_submitted',
  ];

  @override
  void initState() {
    super.initState();
    _cubit = getIt<DriverSupportCubit>();
    _messageController = TextEditingController();
    unawaited(
      _cubit.doIntent(
        DriverSupportLoadCaseDetailsEvent(
          widget.initialCase.id,
          caseType: widget.initialCase.type,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cubit.close();
    _messageController.dispose();
    super.dispose();
  }

  String _reasonLabel(String code) => switch (code) {
    'follow_up' => context.localization.driver_support_follow_up_reason_general,
    'additional_info' =>
      context.localization.driver_support_follow_up_reason_additional_info,
    'proof_submitted' =>
      context.localization.driver_support_follow_up_reason_proof_submitted,
    _ => code,
  };

  String _imageFileName(XFile image) {
    final file = File(image.path);
    return file.uri.pathSegments.isEmpty
        ? context.localization.driver_support_attachment_file_name
        : file.uri.pathSegments.last;
  }

  Future<void> _sendMessage(DriverSupportCaseEntity item) async {
    final locale = context.localization;
    final message = _messageController.text.trim();
    final reasonCode = _selectedReasonCode.trim();
    if (message.isEmpty || reasonCode.isEmpty) {
      CustomSnackbar.showError(
        context: context,
        message: locale.driver_support_follow_up_required_error,
      );
      return;
    }

    List<DriverSupportAttachmentEntity> attachments;
    try {
      attachments = await _uploadSelectedImages();
    } catch (_) {
      return;
    }
    if (!mounted) return;

    final success = await _cubit.doIntent(
      DriverSupportSendMessageEvent(
        orderId: item.orderId,
        caseId: item.id,
        request: DriverSupportCaseMessageRequestEntity(
          reasonCode: reasonCode,
          message: message,
          attachments: attachments,
        ),
      ),
    );
    if (!mounted || !success) return;
    _messageController.clear();
    setState(() {
      _selectedImages = const <XFile>[];
    });
  }

  Future<void> _pickImages() async {
    if (_cubit.state.isMessageSending) return;

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
        message: context.localization.driver_support_pick_files_error,
      );
    }
  }

  Future<List<DriverSupportAttachmentEntity>> _uploadSelectedImages() async {
    if (_selectedImages.isEmpty) return const <DriverSupportAttachmentEntity>[];

    try {
      final attachments = <DriverSupportAttachmentEntity>[];
      for (final image in _selectedImages) {
        final url = await _fileUploadService.uploadFile(
          image.path,
          directory: DriverUploadDirectory.proofs,
        );
        attachments.add(
          DriverSupportAttachmentEntity(
            fileName: _imageFileName(image),
            fileUrl: url,
          ),
        );
      }
      return attachments;
    } catch (error) {
      if (!mounted) return const <DriverSupportAttachmentEntity>[];
      CustomSnackbar.showError(
        context: context,
        message: error is Exception
            ? error.toString().replaceFirst('Exception: ', '')
            : context.localization.driver_support_upload_files_error,
      );
      rethrow;
    }
  }

  void _removeImage(XFile image) {
    if (_cubit.state.isMessageSending) return;
    setState(() {
      _selectedImages = _selectedImages
          .where((item) => item.path != image.path)
          .toList(growable: false);
    });
  }

  Future<void> _openAttachment(String url) async {
    final value = url.trim();
    if (value.isEmpty) return;

    final uri = Uri.tryParse(value);
    if (uri != null &&
        await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      return;
    }

    if (!mounted) return;
    CustomSnackbar.showError(
      context: context,
      message: context.localization.driver_support_open_attachment_error,
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<DriverSupportCubit, DriverSupportState>(
        listenWhen: (previous, current) =>
            previous.failure != current.failure ||
            previous.successMessage != current.successMessage,
        listener: (context, state) {
          final successMessage = state.successMessage?.trim() ?? '';
          if (successMessage.isNotEmpty) {
            CustomSnackbar.showSuccess(
              context: context,
              message: successMessage,
            );
            unawaited(
              _cubit.doIntent(const DriverSupportConsumeSuccessEvent()),
            );
          }

          final exception = state.failure?.asException;
          if (exception == null || !exception.errorType.showSnackBar) return;
          CustomSnackbar.showError(
            context: context,
            message: ErrorMessagePresenter.snackBarMessage(context, exception),
          );
        },
        builder: (context, state) {
          final item = state.selectedCase ?? widget.initialCase;
          final exception = state.failure?.asException;

          if (state.isLoading && state.selectedCase == null) {
            return Scaffold(
              backgroundColor: context.colorScheme.surface,
              appBar: CustomAppBar.modern(
                title: locale.driver_support_case_details_title,
                onBackPressed: context.pop,
              ),
              body: const DriverSupportCaseDetailsLoadingView(),
            );
          }

          if (!state.isLoading &&
              exception != null &&
              exception.errorType.showFullScreen &&
              state.selectedCase == null) {
            return Scaffold(
              appBar: CustomAppBar.modern(
                title: locale.driver_support_case_details_title,
                onBackPressed: context.pop,
              ),
              body: ApiErrorWidget(
                exception: exception,
                onRetry: () => _cubit.doIntent(
                  DriverSupportLoadCaseDetailsEvent(
                    widget.initialCase.id,
                    caseType: widget.initialCase.type,
                  ),
                ),
                onGoBack: context.pop,
              ),
            );
          }

          return Scaffold(
            backgroundColor: context.colorScheme.surface,
            appBar: CustomAppBar.modern(
              title: locale.driver_support_case_details_title,
              onBackPressed: context.pop,
            ),
            body: RefreshIndicator(
              onRefresh: () => _cubit.doIntent(
                DriverSupportLoadCaseDetailsEvent(
                  item.id,
                  refresh: true,
                  caseType: item.type,
                ),
              ),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 22),
                children: [
                  DriverSupportCaseDetailsHero(item: item, isArabic: _isArabic),
                  const SizedBox(height: 10),
                  DriverSupportCaseSectionCard(
                    title: locale.driver_support_case_description_title,
                    icon: Icons.description_outlined,
                    child: Text(
                      item.message.trim().isEmpty
                          ? locale.driver_support_not_available
                          : item.message.trim(),
                    ),
                  ),
                  if ((item.adminNote ?? '').trim().isNotEmpty) ...[
                    const SizedBox(height: 10),
                    DriverSupportCaseSectionCard(
                      title: locale.driver_support_case_admin_note_title,
                      icon: Icons.campaign_outlined,
                      child: Text(item.adminNote!.trim()),
                    ),
                  ],
                  if ((item.decisionNotes ?? '').trim().isNotEmpty) ...[
                    const SizedBox(height: 10),
                    DriverSupportCaseSectionCard(
                      title: locale.driver_support_case_decision_notes_title,
                      icon: Icons.rule_folder_outlined,
                      child: Text(item.decisionNotes!.trim()),
                    ),
                  ],
                  if (item.attachments.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    DriverSupportCaseSectionCard(
                      title: locale.driver_support_case_attachments_title,
                      icon: Icons.attach_file_rounded,
                      child: Column(
                        children: item.attachments
                            .map(
                              (attachment) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: DriverSupportAttachmentTile(
                                  fileName: attachment.fileName,
                                  onTap: () =>
                                      _openAttachment(attachment.fileUrl),
                                ),
                              ),
                            )
                            .toList(growable: false),
                      ),
                    ),
                  ],
                  if (item.activities.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    DriverSupportCaseSectionCard(
                      title: locale.driver_support_case_recent_activity_title,
                      icon: Icons.timeline_rounded,
                      child: Column(
                        children: item.activities
                            .map(
                              (activity) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: DriverSupportActivityTile(
                                  isArabic: _isArabic,
                                  activity: activity,
                                ),
                              ),
                            )
                            .toList(growable: false),
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  DriverSupportCaseSectionCard(
                    title: locale.driver_support_case_add_follow_up_title,
                    icon: Icons.reply_all_rounded,
                    child: DriverSupportFollowUpForm(
                      reasonCodes: _followUpReasonCodes,
                      selectedReasonCode: _selectedReasonCode,
                      messageController: _messageController,
                      selectedImages: _selectedImages,
                      isSubmitting: state.isMessageSending,
                      reasonLabelBuilder: _reasonLabel,
                      fileNameBuilder: _imageFileName,
                      onReasonChanged: (value) {
                        setState(() {
                          _selectedReasonCode = value ?? _selectedReasonCode;
                        });
                      },
                      onPickImages: _pickImages,
                      onRemoveImage: _removeImage,
                      onSubmit: () => _sendMessage(item),
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
}
