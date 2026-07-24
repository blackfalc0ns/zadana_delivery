import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/core/errors/error_widgets/empty_state_widget.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/core/widgets/app_button.dart';
import 'package:zadana_delivery/core/widgets/custom_app_bar.dart';
import 'package:zadana_delivery/core/widgets/custom_progress_indicator.dart';
import 'package:zadana_delivery/core/widgets/custom_snack_bar.dart';
import 'package:zadana_delivery/core/widgets/loading/loading_overlay.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_wallet_withdrawal_request_entity.dart';
import 'package:zadana_delivery/features/wallet/presentation/manager/wallet_state.dart';
import 'package:zadana_delivery/features/wallet/presentation/manager/wallet_view_model.dart';
import 'package:zadana_delivery/features/wallet/presentation/wallet_ui_labels.dart';

class WalletWithdrawalsScreen extends StatelessWidget {
  const WalletWithdrawalsScreen({super.key, required this.viewModel});

  final WalletViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return BlocProvider.value(
      value: viewModel,
      child: Scaffold(
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              CustomAppBar.modern(
                title: locale.wallet_withdrawal_requests,
                onBackPressed: () => Navigator.of(context).maybePop(),
              ),
              Expanded(
                child: BlocBuilder<WalletViewModel, WalletState>(
                  builder: (context, state) {
                    if (state.isWithdrawalsLoading &&
                        state.withdrawals.isEmpty) {
                      return const Center(child: CustomProgressIndicator());
                    }

                    if (state.withdrawals.isEmpty) {
                      return Center(
                        child: EmptyStateWidget(
                          title: locale.wallet_withdrawals_empty_title,
                          description: locale.wallet_withdrawals_empty_subtitle,
                          icon: Icons.outbox_outlined,
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () => viewModel.loadWithdrawals(refresh: true),
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                        children: [
                          _WithdrawalsOverviewCard(
                            pendingCount: viewModel
                                .summary
                                ?.withdrawalSummary
                                .pendingCount,
                            pendingAmount: viewModel
                                .summary
                                ?.withdrawalSummary
                                .pendingAmount,
                            totalRequests: viewModel
                                .summary
                                ?.withdrawalSummary
                                .totalRequests,
                          ),
                          const SizedBox(height: 18),
                          ...state.withdrawals.map(
                            (item) => Padding(
                              key: ValueKey<String>(item.id),
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _WithdrawalRequestCard(
                                item: item,
                                viewModel: viewModel,
                                isCancelling:
                                    state.cancellingWithdrawalId == item.id,
                              ),
                            ),
                          ),
                          if (state.isLoadingMoreWithdrawals)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 18),
                              child: Center(
                                child: CustomProgressIndicator.compact(
                                  size: 22,
                                ),
                              ),
                            )
                          else if (viewModel.hasWithdrawalsMore)
                            AppButton.outlined(
                              text: locale.wallet_load_more,
                              onPressed: viewModel.loadMoreWithdrawals,
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WithdrawalsOverviewCard extends StatelessWidget {
  const _WithdrawalsOverviewCard({
    required this.pendingCount,
    required this.pendingAmount,
    required this.totalRequests,
  });

  final int? pendingCount;
  final double? pendingAmount;
  final int? totalRequests;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final colors = context.colorScheme;
    final localeName = Localizations.localeOf(context).toLanguageTag();

    String formatAmount(double value) {
      return NumberFormat.currency(
        locale: localeName,
        symbol: '${locale.currency} ',
        decimalDigits: value.truncateToDouble() == value ? 0 : 2,
      ).format(value);
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _OverviewMetric(
                  label: locale.wallet_pending_requests,
                  value: '${pendingCount ?? 0}',
                  color: AppColors.warning,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _OverviewMetric(
                  label: locale.wallet_total_requests,
                  value: '${totalRequests ?? 0}',
                  color: colors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _OverviewMetric(
            label: locale.wallet_pending_requests_amount,
            value: formatAmount(pendingAmount ?? 0),
            color: AppColors.info,
            fullWidth: true,
          ),
        ],
      ),
    );
  }
}

class _OverviewMetric extends StatelessWidget {
  const _OverviewMetric({
    required this.label,
    required this.value,
    required this.color,
    this.fullWidth = false,
  });

  final String label;
  final String value;
  final Color color;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: color),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _WithdrawalRequestCard extends StatelessWidget {
  const _WithdrawalRequestCard({
    required this.item,
    required this.viewModel,
    required this.isCancelling,
  });

  final DriverWalletWithdrawalRequestEntity item;
  final WalletViewModel viewModel;
  final bool isCancelling;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final colors = context.colorScheme;
    final statusColor = _statusColor(item.status, colors);
    final localeName = Localizations.localeOf(context).toLanguageTag();
    final amount = NumberFormat.currency(
      locale: localeName,
      symbol: '${locale.currency} ',
      decimalDigits: item.amount.truncateToDouble() == item.amount ? 0 : 2,
    ).format(item.amount);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.outbox_rounded, color: statusColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.paymentMethod.maskedLabel,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.paymentMethod.providerName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                amount,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _WithdrawalPill(
                label: locale.walletWithdrawalStatusLabel(item.status),
                color: statusColor,
              ),
              _WithdrawalPill(
                label: _formatDate(context, item.createdAt),
                color: colors.primary,
              ),
              if (item.status.trim().toLowerCase() == 'paid' &&
                  (item.transferReference ?? '').trim().isNotEmpty)
                _WithdrawalPill(
                  label:
                      '${locale.wallet_transfer_reference}: ${item.transferReference!}',
                  color: colors.secondary,
                ),
            ],
          ),
          if (item.status.trim().toLowerCase() == 'paid' &&
              item.hasTransferProof) ...[
            const SizedBox(height: 12),
            AppButton.outlined(
              text: locale.wallet_download_transfer_proof,
              onPressed: () => _downloadTransferProof(context),
            ),
          ],
          if ((item.failureReason ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                _localizedFailureReason(context, item.failureReason!),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: colors.error),
              ),
            ),
          ],
          if (item.status.trim().toLowerCase() == 'pending') ...[
            const SizedBox(height: 12),
            AppButton.outlined(
              text: context.localization.cancel,
              isLoading: isCancelling,
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: Text(
                      context.localization.wallet_cancel_withdrawal_title,
                    ),
                    content: Text(
                      context.localization.wallet_cancel_withdrawal_message,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext, false),
                        child: Text(context.localization.cancel),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext, true),
                        child: Text(context.localization.confirm),
                      ),
                    ],
                  ),
                );
                if (confirmed == true) {
                  await viewModel.cancelWithdrawal(item.id);
                }
              },
            ),
          ],
        ],
      ),
    );
  }

  Color _statusColor(String status, ColorScheme colors) {
    switch (status.trim().toLowerCase()) {
      case 'paid':
        return AppColors.success;
      case 'processing':
      case 'pending':
        return AppColors.warning;
      case 'cancelled':
      case 'failed':
        return colors.error;
      default:
        return colors.primary;
    }
  }

  String _formatDate(BuildContext context, DateTime date) {
    final localeName = Localizations.localeOf(context).toLanguageTag();
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return DateFormat(
      isArabic ? 'd MMMM yyyy، h:mm a' : 'd MMM yyyy, h:mm a',
      localeName,
    ).format(date);
  }

  String _localizedFailureReason(BuildContext context, String reason) {
    final normalized = reason.trim().toLowerCase();
    if (normalized.contains('cancelled by driver') ||
        normalized.contains('canceled by driver')) {
      return context.localization.wallet_withdrawal_cancelled_by_driver;
    }
    return reason;
  }

  Future<void> _downloadTransferProof(BuildContext context) async {
    LoadingOverlay.show(context);
    final result = await (() async {
      try {
        return await viewModel.downloadTransferProof(item.id);
      } finally {
        LoadingOverlay.hide();
      }
    })();
    if (!context.mounted) return;

    switch (result) {
      case ApiSuccessResult(data: final proof):
        final directory = await getTemporaryDirectory();
        final safeName = proof.fileName.replaceAll(
          RegExp(r'[\\/:*?"<>|]'),
          '_',
        );
        final file = File(
          '${directory.path}${Platform.pathSeparator}$safeName',
        );
        await file.writeAsBytes(proof.bytes, flush: true);
        if (!context.mounted) return;
        CustomSnackbar.showSuccess(
          context: context,
          message: context.localization.wallet_transfer_proof_saved,
        );
        if (Platform.isAndroid) {
          await const MethodChannel(
            'zadana_delivery/transfer_proof',
          ).invokeMethod<bool>('openTransferProof', <String, dynamic>{
            'path': file.path,
            'mimeType': _mimeTypeFor(file.path),
          });
        } else {
          await launchUrl(
            Uri.file(file.path),
            mode: LaunchMode.externalApplication,
          );
        }
      case ApiErrorResult(failure: final failure):
        CustomSnackbar.showError(
          context: context,
          message: failure.errorMessage,
        );
    }
  }

  String _mimeTypeFor(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    return switch (extension) {
      'pdf' => 'application/pdf',
      'png' => 'image/png',
      'jpg' || 'jpeg' => 'image/jpeg',
      _ => 'application/octet-stream',
    };
  }
}

class _WithdrawalPill extends StatelessWidget {
  const _WithdrawalPill({required this.label, required this.color});

  final String label;
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
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
