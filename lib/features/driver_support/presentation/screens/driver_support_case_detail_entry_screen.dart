import 'package:flutter/material.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/core/widgets/custom_app_bar.dart';
import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_case_entity.dart';
import 'package:zadana_delivery/features/driver_support/domain/usecase/get_driver_support_case_details_usecase.dart';
import 'package:zadana_delivery/features/driver_support/presentation/screens/driver_support_case_details_screen.dart';

class DriverSupportCaseDetailEntryScreen extends StatefulWidget {
  const DriverSupportCaseDetailEntryScreen({super.key, required this.caseId});

  final String caseId;

  @override
  State<DriverSupportCaseDetailEntryScreen> createState() =>
      _DriverSupportCaseDetailEntryScreenState();
}

class _DriverSupportCaseDetailEntryScreenState
    extends State<DriverSupportCaseDetailEntryScreen> {
  late Future<DriverSupportCaseEntity?> _loadFuture;

  @override
  void initState() {
    super.initState();
    _loadFuture = _loadCase();
  }

  Future<DriverSupportCaseEntity?> _loadCase() async {
    final result = await getIt<GetDriverSupportCaseDetailsUseCase>().call(
      widget.caseId,
    );
    switch (result) {
      case ApiSuccessResult<DriverSupportCaseEntity>():
        return result.data;
      case ApiErrorResult<DriverSupportCaseEntity>():
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DriverSupportCaseEntity?>(
      future: _loadFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData && snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            appBar: CustomAppBar.modern(
              title: 'Support case',
              onBackPressed: () => Navigator.of(context).maybePop(),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final supportCase = snapshot.data;
        if (supportCase == null) {
          return Scaffold(
            appBar: CustomAppBar.modern(
              title: 'Support case',
              onBackPressed: () => Navigator.of(context).maybePop(),
            ),
            body: Center(
              child: FilledButton(
                onPressed: () {
                  setState(() {
                    _loadFuture = _loadCase();
                  });
                },
                child: const Text('Retry loading support case'),
              ),
            ),
          );
        }

        return DriverSupportCaseDetailsScreen(initialCase: supportCase);
      },
    );
  }
}
