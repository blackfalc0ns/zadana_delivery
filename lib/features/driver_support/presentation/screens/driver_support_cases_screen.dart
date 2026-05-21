import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/config/routing/routing_extensions.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/errors/error_presentation.dart';
import 'package:zadana_delivery/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/custom_app_bar.dart';
import 'package:zadana_delivery/core/widgets/custom_snack_bar.dart';
import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_case_entity.dart';
import 'package:zadana_delivery/features/driver_support/presentation/manager/driver_support_cubit.dart';
import 'package:zadana_delivery/features/driver_support/presentation/manager/driver_support_event.dart';
import 'package:zadana_delivery/features/driver_support/presentation/manager/driver_support_state.dart';
import 'package:zadana_delivery/features/driver_support/presentation/widgets/driver_support_cases/driver_support_case_card.dart';
import 'package:zadana_delivery/features/driver_support/presentation/widgets/driver_support_cases/driver_support_cases_empty_state.dart';
import 'package:zadana_delivery/features/driver_support/presentation/widgets/driver_support_cases/driver_support_cases_loading_view.dart';

class DriverSupportCasesScreen extends StatefulWidget {
  const DriverSupportCasesScreen({super.key});

  @override
  State<DriverSupportCasesScreen> createState() =>
      _DriverSupportCasesScreenState();
}

class _DriverSupportCasesScreenState extends State<DriverSupportCasesScreen> {
  late final DriverSupportCubit _cubit;

  bool get _isArabic => Localizations.localeOf(context).languageCode == 'ar';

  @override
  void initState() {
    super.initState();
    _cubit = getIt<DriverSupportCubit>();
    unawaited(_cubit.doIntent(const DriverSupportLoadCasesEvent()));
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
      child: BlocConsumer<DriverSupportCubit, DriverSupportState>(
        listenWhen: (previous, current) => previous.failure != current.failure,
        listener: (context, state) {
          final exception = state.failure?.asException;
          if (exception == null || !exception.errorType.showSnackBar) return;
          CustomSnackbar.showError(
            context: context,
            message: ErrorMessagePresenter.snackBarMessage(context, exception),
          );
        },
        builder: (context, state) {
          final exception = state.failure?.asException;
          final items = state.cases?.items ?? const <DriverSupportCaseEntity>[];

          if (state.isLoading && items.isEmpty) {
            return Scaffold(
              backgroundColor: context.colorScheme.surface,
              appBar: CustomAppBar.modern(
                title: locale.driver_support_cases_title,
                onBackPressed: context.pop,
              ),
              body: const DriverSupportCasesLoadingView(),
            );
          }

          if (!state.isLoading &&
              items.isEmpty &&
              exception != null &&
              exception.errorType.showFullScreen) {
            return Scaffold(
              appBar: CustomAppBar.modern(
                title: locale.driver_support_cases_title,
                onBackPressed: context.pop,
              ),
              body: ApiErrorWidget(
                exception: exception,
                onRetry: () =>
                    _cubit.doIntent(const DriverSupportLoadCasesEvent()),
                onGoBack: context.pop,
              ),
            );
          }

          return Scaffold(
            backgroundColor: context.colorScheme.surface,
            appBar: CustomAppBar.modern(
              title: locale.driver_support_cases_title,
              onBackPressed: context.pop,
            ),
            body: RefreshIndicator(
              onRefresh: () => _cubit.doIntent(
                const DriverSupportLoadCasesEvent(refresh: true),
              ),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                children: [
                  const SizedBox(height: 16),
                  if (items.isEmpty)
                    DriverSupportCasesEmptyState(
                      title: locale.driver_support_cases_empty_title,
                      subtitle: locale.driver_support_cases_empty_subtitle,
                    )
                  else
                    ...items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: DriverSupportCaseCard(
                          item: item,
                          isArabic: _isArabic,
                          onTap: () => Navigator.of(context).pushNamed(
                            AppRoutes.driverSupportCaseDetails,
                            arguments: item,
                          ),
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
}
