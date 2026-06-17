import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/custom_snack_bar.dart';
import 'package:zadana_delivery/features/profile/presentation/manager/profile_cubit.dart';
import 'package:zadana_delivery/features/profile/presentation/manager/profile_form_event.dart';
import 'package:zadana_delivery/features/profile/presentation/manager/profile_state.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_action_item_data.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_document_item_data.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_form_scaffold.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_loading_skeleton.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/security_documents_fields.dart';

class SecurityDocumentsScreen extends StatefulWidget {
  const SecurityDocumentsScreen({super.key});

  @override
  State<SecurityDocumentsScreen> createState() =>
      _SecurityDocumentsScreenState();
}

class _SecurityDocumentsScreenState extends State<SecurityDocumentsScreen> {
  late final ProfileCubit _cubit;
  final _formKey = GlobalKey<FormState>();
  Map<String, String> _originalDocumentPaths = const {};
  bool _didSeedOriginalPaths = false;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<ProfileCubit>()..doIntent(const ProfileFormLoadEvent());
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (!_didSeedOriginalPaths && state.profile != null) {
            _didSeedOriginalPaths = true;
            _originalDocumentPaths = Map<String, String>.from(
              state.documentPaths,
            );
          }

          if (state.isSuccess) {
            CustomSnackbar.showInfo(
              context: context,
              message: context.localization.profile_change_pending_approval,
            );
            Navigator.of(context).pop();
            return;
          }

          if (state.failure != null && state.profile != null) {
            if (state.failure!.isConnectivityIssue) return;
            final message = state.failure!.code == 'image_picker'
                ? locale.driver_profile_picker_error
                : state.failure!.errorMessage;
            CustomSnackbar.showError(context: context, message: message);
            _cubit.clearError();
          }
        },
        builder: (context, state) {
          final showGlobalError =
              !state.isLoading &&
              state.profile == null &&
              state.failure != null;

          if (state.profile == null && state.isLoading) {
            return ProfileFormLoadingSkeleton(
              title: locale.profile_security_documents_title,
              includeDocumentGrid: true,
            );
          }

          if (showGlobalError) {
            return Scaffold(
              backgroundColor: context.colorScheme.surface,
              body: SafeArea(
                child: ApiErrorWidget(
                  exception: state.failure!.asException,
                  onRetry: () => _cubit.doIntent(const ProfileFormLoadEvent()),
                  onGoBack: () =>
                      _cubit.doIntent(const ProfileFormClearErrorEvent()),
                ),
              ),
            );
          }

          final complianceDocs = state.profile?.documents ?? const [];
          final nationalIdDoc = complianceDocs
              .where((d) => d.normalizedDocumentType == 'nationalid')
              .firstOrNull;
          final driverLicenseDoc = complianceDocs
              .where((d) => d.normalizedDocumentType == 'driverlicense')
              .firstOrNull;
          final vehicleLicenseDoc = complianceDocs
              .where((d) => d.normalizedDocumentType == 'vehiclelicense')
              .firstOrNull;

          final documents = [
            ProfileDocumentItemData(
              type: ProfileDocumentType.portrait,
              icon: Icons.person_rounded,
              path: state.documentPaths['portrait'] ?? '',
            ),
            ProfileDocumentItemData(
              type: ProfileDocumentType.idFront,
              icon: Icons.badge_outlined,
              path: state.documentPaths['idFront'] ?? '',
              complianceDocument: nationalIdDoc,
            ),
            ProfileDocumentItemData(
              type: ProfileDocumentType.idBack,
              icon: Icons.badge_outlined,
              path: state.documentPaths['idBack'] ?? '',
              complianceDocument: nationalIdDoc,
            ),
            ProfileDocumentItemData(
              type: ProfileDocumentType.license,
              icon: Icons.assignment_ind_outlined,
              path: state.documentPaths['license'] ?? '',
              complianceDocument: driverLicenseDoc,
            ),
            ProfileDocumentItemData(
              type: ProfileDocumentType.vehicle,
              icon: Icons.description_outlined,
              path: state.documentPaths['vehicle'] ?? '',
              complianceDocument: vehicleLicenseDoc,
            ),
          ];

          final uploadedCount = documents.where((item) => item.hasFile).length;

          final isFormDirty = _didSeedOriginalPaths &&
              !_mapsEqual(state.documentPaths, _originalDocumentPaths);

          return ProfileFormScaffold(
            title: locale.profile_security_documents_title,
            headerTitle: locale.profile_documents_uploaded_count(uploadedCount),
            headerSubtitle: locale.driver_profile_uploads_card_subtitle,
            headerIcon: Icons.verified_user_outlined,
            headerColorToken: ProfileColorToken.tertiary,
            formKey: _formKey,
            isSaving: state.isSaving || state.isLoading,
            isFormDirty: isFormDirty,
            onSave: _save,
            children: [
              SecurityDocumentsFields(
                documents: documents,
                onSelect: (type) =>
                    _cubit.doIntent(ProfileFormPickDocumentEvent(type)),
                onPreview: _showDocumentPreview,
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _save() async {
    final paths = _cubit.state.documentPaths;
    if ((paths['portrait'] ?? '').trim().isEmpty ||
        (paths['idFront'] ?? '').trim().isEmpty ||
        (paths['idBack'] ?? '').trim().isEmpty ||
        (paths['license'] ?? '').trim().isEmpty ||
        (paths['vehicle'] ?? '').trim().isEmpty) {
      CustomSnackbar.showError(
        context: context,
        message: context.localization.driver_profile_images_required_error,
      );
      return;
    }

    await _cubit.doIntent(const ProfileFormSaveDocumentsEvent());
  }

  bool _mapsEqual(Map<String, String> a, Map<String, String> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (a[key] != b[key]) return false;
    }
    return true;
  }

  Future<void> _showDocumentPreview(ProfileDocumentItemData item) async {
    if (!item.hasFile) return;

    final locale = context.localization;
    final normalizedPath = item.path.trim();
    final isRemote =
        normalizedPath.startsWith('http://') ||
        normalizedPath.startsWith('https://');

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final colorScheme = dialogContext.colorScheme;
        return Dialog(
          insetPadding: const EdgeInsets.all(20),
          backgroundColor: colorScheme.surface,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.type.localizedTitle(locale),
                        style: Theme.of(dialogContext).textTheme.titleMedium,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(28),
                  ),
                  child: InteractiveViewer(
                    maxScale: 4,
                    child: isRemote
                        ? Image.network(
                            normalizedPath,
                            fit: BoxFit.contain,
                            errorBuilder: (_, _, _) => _PreviewError(
                              message: locale.profile_not_uploaded_yet,
                            ),
                          )
                        : Image.file(
                            File(normalizedPath),
                            fit: BoxFit.contain,
                            errorBuilder: (_, _, _) => _PreviewError(
                              message: locale.profile_not_uploaded_yet,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PreviewError extends StatelessWidget {
  const _PreviewError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Container(
      constraints: const BoxConstraints(minHeight: 260),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.broken_image_outlined, size: 42, color: colorScheme.error),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
