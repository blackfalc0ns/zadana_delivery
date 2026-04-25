import 'package:zadana_delivery/core/network/failures.dart';

import '../../domain/entities/register_response_entity.dart';
import '../models/register_profile_draft.dart';

class RegisterState {
  const RegisterState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.response,
    this.failure,
    this.draft = RegisterProfileDraft.empty,
  });

  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final RegisterResponseEntity? response;
  final Failure? failure;
  final RegisterProfileDraft draft;

  RegisterState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    RegisterResponseEntity? response,
    Failure? failure,
    RegisterProfileDraft? draft,
    bool clearError = false,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      response: response ?? this.response,
      failure: clearError ? null : failure ?? this.failure,
      draft: draft ?? this.draft,
    );
  }
}
