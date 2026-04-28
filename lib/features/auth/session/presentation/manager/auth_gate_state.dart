import 'package:zadana_delivery/core/network/failures.dart';

class AuthGateState {
  const AuthGateState({
    this.isLoading = false,
    this.isLoggingOut = false,
    this.logoutSucceeded = false,
    this.targetRoute,
    this.failure,
  });

  final bool isLoading;
  final bool isLoggingOut;
  final bool logoutSucceeded;
  final String? targetRoute;
  final Failure? failure;

  AuthGateState copyWith({
    bool? isLoading,
    bool? isLoggingOut,
    bool? logoutSucceeded,
    String? targetRoute,
    Failure? failure,
    bool clearTargetRoute = false,
    bool clearFailure = false,
    bool resetLogoutSucceeded = false,
  }) {
    return AuthGateState(
      isLoading: isLoading ?? this.isLoading,
      isLoggingOut: isLoggingOut ?? this.isLoggingOut,
      logoutSucceeded: resetLogoutSucceeded
          ? false
          : logoutSucceeded ?? this.logoutSucceeded,
      targetRoute: clearTargetRoute ? null : targetRoute ?? this.targetRoute,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }
}
