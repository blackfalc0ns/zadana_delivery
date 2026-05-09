import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/core/services/driver_realtime_service.dart';
import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_case_message_request_entity.dart';
import 'package:zadana_delivery/features/driver_support/domain/usecase/get_driver_support_case_details_usecase.dart';
import 'package:zadana_delivery/features/driver_support/domain/usecase/get_driver_support_cases_usecase.dart';
import 'package:zadana_delivery/features/driver_support/domain/usecase/send_driver_support_case_message_usecase.dart';
import 'package:zadana_delivery/features/driver_support/presentation/manager/driver_support_event.dart';
import 'package:zadana_delivery/features/driver_support/presentation/manager/driver_support_state.dart';

class DriverSupportCubit extends Cubit<DriverSupportState> {
  DriverSupportCubit(
    this._getCasesUseCase,
    this._getCaseDetailsUseCase,
    this._sendMessageUseCase,
    DriverRealtimeService driverRealtimeService,
  ) : super(const DriverSupportState()) {
    _supportCaseChangedSubscription = driverRealtimeService.supportCaseChanged
        .listen((payload) {
          final selectedCaseId = state.selectedCase?.id.trim() ?? '';
          final payloadCaseId =
              payload['supportCaseId']?.toString().trim() ??
              payload['caseId']?.toString().trim() ??
              '';

          if (selectedCaseId.isNotEmpty && selectedCaseId == payloadCaseId) {
            unawaited(_loadCaseDetails(selectedCaseId, refresh: true));
            return;
          }

          if (state.cases != null) {
            unawaited(_loadCases(refresh: true));
          }
        });
  }

  final GetDriverSupportCasesUseCase _getCasesUseCase;
  final GetDriverSupportCaseDetailsUseCase _getCaseDetailsUseCase;
  final SendDriverSupportCaseMessageUseCase _sendMessageUseCase;
  late final StreamSubscription<Map<String, dynamic>>
  _supportCaseChangedSubscription;

  Future<bool> doIntent(DriverSupportEvent event) async {
    switch (event) {
      case DriverSupportLoadCasesEvent():
        return _loadCases(refresh: event.refresh);
      case DriverSupportLoadCaseDetailsEvent():
        return _loadCaseDetails(event.caseId, refresh: event.refresh);
      case DriverSupportSendMessageEvent():
        return _sendMessage(
          orderId: event.orderId,
          caseId: event.caseId,
          request: event.request,
        );
      case DriverSupportClearErrorEvent():
        emit(state.copyWith(clearFailure: true));
        return true;
      case DriverSupportConsumeSuccessEvent():
        emit(state.copyWith(clearSuccessMessage: true));
        return true;
    }
  }

  Future<bool> _loadCases({bool refresh = false}) async {
    emit(
      state.copyWith(
        isLoading: !refresh,
        isRefreshing: refresh,
        clearFailure: true,
      ),
    );
    final result = await _getCasesUseCase.call();
    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isLoading: false,
            isRefreshing: false,
            cases: result.data,
            clearFailure: true,
          ),
        );
        return true;
      case ApiErrorResult():
        emit(
          state.copyWith(
            isLoading: false,
            isRefreshing: false,
            failure: result.failure,
          ),
        );
        return false;
    }
  }

  Future<bool> _loadCaseDetails(String caseId, {bool refresh = false}) async {
    emit(
      state.copyWith(
        isLoading: !refresh,
        isRefreshing: refresh,
        clearFailure: true,
      ),
    );
    final result = await _getCaseDetailsUseCase.call(caseId);
    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isLoading: false,
            isRefreshing: false,
            selectedCase: result.data,
            clearFailure: true,
          ),
        );
        return true;
      case ApiErrorResult():
        emit(
          state.copyWith(
            isLoading: false,
            isRefreshing: false,
            failure: result.failure,
          ),
        );
        return false;
    }
  }

  Future<bool> _sendMessage({
    required String orderId,
    required String caseId,
    required DriverSupportCaseMessageRequestEntity request,
  }) async {
    emit(
      state.copyWith(
        isMessageSending: true,
        clearFailure: true,
        clearSuccessMessage: true,
      ),
    );
    final result = await _sendMessageUseCase.call(
      orderId: orderId,
      caseId: caseId,
      request: request,
    );
    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isMessageSending: false,
            selectedCase: result.data,
            successMessage: 'تم إرسال المتابعة بنجاح',
            clearFailure: true,
          ),
        );
        return true;
      case ApiErrorResult():
        emit(state.copyWith(isMessageSending: false, failure: result.failure));
        return false;
    }
  }

  @override
  Future<void> close() async {
    await _supportCaseChangedSubscription.cancel();
    return super.close();
  }
}
