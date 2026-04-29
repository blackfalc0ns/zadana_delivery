import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';

import '../../domain/usecase/get_driver_zones_usecase.dart';
import 'register_zones_state.dart';

@injectable
class RegisterRegionsCubit extends Cubit<RegisterRegionsState> {
  RegisterRegionsCubit(this._getDriverRegionsUseCase)
    : super(const RegisterRegionsState());

  final GetDriverRegionsUseCase _getDriverRegionsUseCase;

  Future<void> loadRegionCities() async {
    emit(state.copyWith(isLoading: true, clearFailure: true));
    final result = await _getDriverRegionsUseCase.call();

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isLoading: false,
            regionCities: result.data,
            clearFailure: true,
          ),
        );
      case ApiErrorResult():
        emit(state.copyWith(isLoading: false, failure: result.failure));
    }
  }
}
