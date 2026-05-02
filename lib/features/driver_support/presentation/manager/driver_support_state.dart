import 'package:zadana_delivery/core/network/failures.dart';
import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_case_entity.dart';
import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_cases_page_entity.dart';

class DriverSupportState {
  const DriverSupportState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.isMessageSending = false,
    this.cases,
    this.selectedCase,
    this.failure,
    this.successMessage,
  });

  final bool isLoading;
  final bool isRefreshing;
  final bool isMessageSending;
  final DriverSupportCasesPageEntity? cases;
  final DriverSupportCaseEntity? selectedCase;
  final Failure? failure;
  final String? successMessage;

  DriverSupportState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    bool? isMessageSending,
    DriverSupportCasesPageEntity? cases,
    DriverSupportCaseEntity? selectedCase,
    Failure? failure,
    String? successMessage,
    bool clearFailure = false,
    bool clearSuccessMessage = false,
  }) {
    return DriverSupportState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isMessageSending: isMessageSending ?? this.isMessageSending,
      cases: cases ?? this.cases,
      selectedCase: selectedCase ?? this.selectedCase,
      failure: clearFailure ? null : failure ?? this.failure,
      successMessage: clearSuccessMessage
          ? null
          : successMessage ?? this.successMessage,
    );
  }
}
