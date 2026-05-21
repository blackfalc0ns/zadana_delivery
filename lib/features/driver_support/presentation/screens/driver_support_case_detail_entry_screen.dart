import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/custom_app_bar.dart';
import 'package:zadana_delivery/features/driver_support/presentation/manager/driver_support_cubit.dart';
import 'package:zadana_delivery/features/driver_support/presentation/manager/driver_support_event.dart';
import 'package:zadana_delivery/features/driver_support/presentation/manager/driver_support_state.dart';
import 'package:zadana_delivery/features/driver_support/presentation/screens/driver_support_case_details_screen.dart';

class DriverSupportCaseDetailEntryScreen extends StatefulWidget {
  const DriverSupportCaseDetailEntryScreen({
    super.key,
    required this.caseId,
    this.caseType,
  });

  final String caseId;
  final String? caseType;

  @override
  State<DriverSupportCaseDetailEntryScreen> createState() =>
      _DriverSupportCaseDetailEntryScreenState();
}

class _DriverSupportCaseDetailEntryScreenState
    extends State<DriverSupportCaseDetailEntryScreen> {
  late final DriverSupportCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<DriverSupportCubit>();
    _cubit.doIntent(
      DriverSupportLoadCaseDetailsEvent(
        widget.caseId,
        caseType: widget.caseType,
      ),
    );
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
      child: BlocBuilder<DriverSupportCubit, DriverSupportState>(
        builder: (context, state) {
          if (state.isLoading && state.selectedCase == null) {
            return Scaffold(
              appBar: CustomAppBar.modern(
                title: locale.driver_support_case_entry_title,
                onBackPressed: () => Navigator.of(context).maybePop(),
              ),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          final supportCase = state.selectedCase;
          if (supportCase == null) {
            return Scaffold(
              appBar: CustomAppBar.modern(
                title: locale.driver_support_case_entry_title,
                onBackPressed: () => Navigator.of(context).maybePop(),
              ),
              body: Center(
                child: FilledButton(
                  onPressed: () {
                    _cubit.doIntent(
                      DriverSupportLoadCaseDetailsEvent(
                        widget.caseId,
                        caseType: widget.caseType,
                      ),
                    );
                  },
                  child: Text(locale.driver_support_case_entry_retry),
                ),
              ),
            );
          }

          return DriverSupportCaseDetailsScreen(initialCase: supportCase);
        },
      ),
    );
  }
}
