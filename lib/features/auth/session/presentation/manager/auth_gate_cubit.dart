import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/core/services/token_service.dart';
import 'package:zadana_delivery/features/auth/account_status/domain/usecase/get_driver_account_status_usecase.dart';
import 'package:zadana_delivery/features/auth/logout/domain/usecase/logout_usecase.dart';

import 'auth_gate_event.dart';
import 'auth_gate_state.dart';

@injectable
class AuthGateCubit extends Cubit<AuthGateState> {
  AuthGateCubit(
    this._tokenService,
    this._getDriverAccountStatusUseCase,
    this._logoutUseCase,
  ) : super(const AuthGateState());

  final TokenService _tokenService;
  final GetDriverAccountStatusUseCase _getDriverAccountStatusUseCase;
  final LogoutUseCase _logoutUseCase;

  Future<void> doIntent(AuthGateEvent event) async {
    switch (event) {
      case AuthGateStartedEvent():
        await _resolve();
      case AuthGateLogoutRequestedEvent():
        await _logout();
      case AuthGateFeedbackHandledEvent():
        _clearFeedback();
    }
  }

  Future<void> _resolve() async {
    emit(
      state.copyWith(
        isLoading: true,
        clearTargetRoute: true,
        clearFailure: true,
        resetLogoutSucceeded: true,
      ),
    );

    final accessToken = await _tokenService.getToken();
    if ((accessToken ?? '').trim().isEmpty) {
      emit(state.copyWith(isLoading: false, targetRoute: AppRoutes.login));
      return;
    }

    final result = await _getDriverAccountStatusUseCase.call();

    switch (result) {
      case ApiSuccessResult():
        final status = result.data;
        if (status.isPendingReview) {
          emit(
            state.copyWith(
              isLoading: false,
              targetRoute: AppRoutes.accountPendingApproval,
            ),
          );
          return;
        }

        if (status.isBlocked) {
          emit(
            state.copyWith(
              isLoading: false,
              targetRoute: AppRoutes.accountBlocked,
            ),
          );
          return;
        }

        emit(
          state.copyWith(
            isLoading: false,
            targetRoute: status.shouldGoHome
                ? AppRoutes.mainShell
                : status.hasCompletedProfile
                ? AppRoutes.mainShell
                : AppRoutes.driverProfileCompletion,
          ),
        );
      case ApiErrorResult():
        final code = result.failure.normalizedCode;
        if (code == 'error_unauthorized' ||
            code == 'unauthorized' ||
            code == '401' ||
            code == 'error_forbidden' ||
            code == 'forbidden' ||
            code == '403') {
          await _tokenService.clearTokens();
        }
        emit(state.copyWith(isLoading: false, targetRoute: AppRoutes.login));
    }
  }

  Future<void> _logout() async {
    if (state.isLoggingOut) return;

    emit(
      state.copyWith(
        isLoggingOut: true,
        clearFailure: true,
        clearTargetRoute: true,
        resetLogoutSucceeded: true,
      ),
    );

    final result = await _logoutUseCase.call();
    switch (result) {
      case ApiSuccessResult<void>():
        emit(
          state.copyWith(
            isLoggingOut: false,
            logoutSucceeded: true,
            targetRoute: AppRoutes.login,
            clearFailure: true,
          ),
        );
      case ApiErrorResult<void>():
        emit(
          state.copyWith(
            isLoggingOut: false,
            failure: result.failure,
            resetLogoutSucceeded: true,
          ),
        );
    }
  }

  void _clearFeedback() {
    emit(
      state.copyWith(
        clearFailure: true,
        clearTargetRoute: true,
        resetLogoutSucceeded: true,
      ),
    );
  }
}
