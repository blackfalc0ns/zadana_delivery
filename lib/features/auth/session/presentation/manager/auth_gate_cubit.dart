import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/core/services/token_service.dart';
import 'package:zadana_delivery/features/auth/account_status/domain/usecase/get_driver_account_status_usecase.dart';

import 'auth_gate_event.dart';
import 'auth_gate_state.dart';

@injectable
class AuthGateCubit extends Cubit<AuthGateState> {
  AuthGateCubit(this._tokenService, this._getDriverAccountStatusUseCase)
    : super(const AuthGateState());

  final TokenService _tokenService;
  final GetDriverAccountStatusUseCase _getDriverAccountStatusUseCase;

  Future<void> doIntent(AuthGateEvent event) async {
    switch (event) {
      case AuthGateStartedEvent():
        await _resolve();
    }
  }

  Future<void> _resolve() async {
    emit(state.copyWith(isLoading: true, clearTargetRoute: true));
    await Future<void>.delayed(const Duration(milliseconds: 350));

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
            targetRoute: (status.primaryZoneId ?? '').trim().isNotEmpty
                ? AppRoutes.mainShell
                : AppRoutes.driverProfileCompletion,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(isLoading: false, targetRoute: AppRoutes.mainShell),
        );
    }
  }
}
