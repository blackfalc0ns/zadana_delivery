import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';

import '../../domain/usecase/get_driver_zones_usecase.dart';
import 'register_zones_state.dart';

@injectable
class RegisterZonesCubit extends Cubit<RegisterZonesState> {
  RegisterZonesCubit(this._getDriverZonesUseCase)
    : super(const RegisterZonesState());

  final GetDriverZonesUseCase _getDriverZonesUseCase;

  Future<void> loadZones() async {
    emit(state.copyWith(isLoading: true, clearFailure: true));
    final result = await _getDriverZonesUseCase.call();

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isLoading: false,
            zones: result.data,
            clearFailure: true,
          ),
        );
      case ApiErrorResult():
        emit(state.copyWith(isLoading: false, failure: result.failure));
    }
  }
}
