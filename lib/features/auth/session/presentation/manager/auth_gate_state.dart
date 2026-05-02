import 'package:zadana_delivery/core/network/failures.dart';
import 'package:zadana_delivery/features/auth/account_status/domain/entities/driver_account_status_entity.dart';

class AuthGateState {
  const AuthGateState({
    this.isLoading = false,
    this.isLoggingOut = false,
    this.logoutSucceeded = false,
    this.targetRoute,
    this.failure,
    this.accountStatus,
  });

  final bool isLoading;
  final bool isLoggingOut;
  final bool logoutSucceeded;
  final String? targetRoute;
  final Failure? failure;
  final DriverAccountStatusEntity? accountStatus;

  AuthGateState copyWith({
    bool? isLoading,
    bool? isLoggingOut,
    bool? logoutSucceeded,
    String? targetRoute,
    Failure? failure,
    DriverAccountStatusEntity? accountStatus,
    bool clearTargetRoute = false,
    bool clearFailure = false,
    bool clearAccountStatus = false,
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
      accountStatus: clearAccountStatus
          ? null
          : accountStatus ?? this.accountStatus,
    );
  }
}
