import 'package:zadana_delivery/core/network/failures.dart';
import 'package:zadana_delivery/features/auth/register/presentation/models/register_profile_draft.dart';

class DriverProfileCompletionState {
  const DriverProfileCompletionState({
    this.isInitialized = false,
    this.isLoading = false,
    this.failure,
    this.currentStep = 0,
    this.draft = RegisterProfileDraft.empty,
    this.fullName = '',
    this.email = '',
    this.phone = '',
    this.successMessage,
    this.targetRoute,
  });

  final bool isInitialized;
  final bool isLoading;
  final Failure? failure;
  final int currentStep;
  final RegisterProfileDraft draft;
  final String fullName;
  final String email;
  final String phone;
  final String? successMessage;
  final String? targetRoute;

  DriverProfileCompletionState copyWith({
    bool? isInitialized,
    bool? isLoading,
    Failure? failure,
    int? currentStep,
    RegisterProfileDraft? draft,
    String? fullName,
    String? email,
    String? phone,
    String? successMessage,
    String? targetRoute,
    bool clearFailure = false,
    bool clearSuccess = false,
    bool clearNavigation = false,
  }) {
    return DriverProfileCompletionState(
      isInitialized: isInitialized ?? this.isInitialized,
      isLoading: isLoading ?? this.isLoading,
      failure: clearFailure ? null : failure ?? this.failure,
      currentStep: currentStep ?? this.currentStep,
      draft: draft ?? this.draft,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      successMessage: clearSuccess
          ? null
          : successMessage ?? this.successMessage,
      targetRoute: clearNavigation ? null : targetRoute ?? this.targetRoute,
    );
  }
}
