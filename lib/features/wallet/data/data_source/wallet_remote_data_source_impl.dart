import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/errors/api_exception_mapper.dart';
import 'package:zadana_delivery/core/network/api_services.dart';
import 'package:zadana_delivery/features/wallet/data/data_source/wallet_remote_data_source.dart';
import 'package:zadana_delivery/features/wallet/data/models/driver_payout_method_model_dto.dart';
import 'package:zadana_delivery/features/wallet/data/models/driver_wallet_summary_model_dto.dart';
import 'package:zadana_delivery/features/wallet/data/models/driver_wallet_transactions_page_model_dto.dart';
import 'package:zadana_delivery/features/wallet/data/models/driver_wallet_withdrawal_request_model_dto.dart';
import 'package:zadana_delivery/features/wallet/data/models/driver_wallet_withdrawals_page_model_dto.dart';

@LazySingleton(as: WalletRemoteDataSource)
class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  const WalletRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<DriverWalletSummaryModelDto> getWalletSummary() async {
    try {
      final response = await _apiServices.getDriverWalletSummary();
      return DriverWalletSummaryModelDto.fromJson(_normalizeMap(response));
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<DriverWalletTransactionsPageModelDto> getTransactions({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _apiServices.getDriverWalletTransactions(
        page: page,
        pageSize: pageSize,
      );
      return DriverWalletTransactionsPageModelDto.fromJson(
        _normalizeMap(response),
      );
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<List<DriverPayoutMethodModelDto>> getPaymentMethods() async {
    try {
      final response = await _apiServices.getDriverWalletPaymentMethods();
      if (response is List) {
        return response
            .whereType<Map>()
            .map(
              (item) =>
                  DriverPayoutMethodModelDto.fromJson(_normalizeMap(item)),
            )
            .toList(growable: false);
      }
      return const <DriverPayoutMethodModelDto>[];
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<DriverPayoutMethodModelDto> createPaymentMethod(
    Map<String, dynamic> request,
  ) async {
    try {
      final response = await _apiServices.createDriverWalletPaymentMethod(
        request,
      );
      return DriverPayoutMethodModelDto.fromJson(_normalizeMap(response));
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<DriverPayoutMethodModelDto> updatePaymentMethod(
    String id,
    Map<String, dynamic> request,
  ) async {
    try {
      final response = await _apiServices.updateDriverWalletPaymentMethod(
        id,
        request,
      );
      return DriverPayoutMethodModelDto.fromJson(_normalizeMap(response));
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<void> deletePaymentMethod(String id) async {
    try {
      await _apiServices.deleteDriverWalletPaymentMethod(id);
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<DriverPayoutMethodModelDto> makePaymentMethodPrimary(String id) async {
    try {
      final response = await _apiServices.makeDriverWalletPaymentMethodPrimary(
        id,
      );
      return DriverPayoutMethodModelDto.fromJson(_normalizeMap(response));
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<DriverWalletWithdrawalRequestModelDto> createWithdrawal(
    Map<String, dynamic> request,
  ) async {
    try {
      final response = await _apiServices.createDriverWalletWithdrawal(request);
      return DriverWalletWithdrawalRequestModelDto.fromJson(
        _normalizeMap(response),
      );
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<DriverWalletWithdrawalsPageModelDto> getWithdrawals({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _apiServices.getDriverWalletWithdrawals(
        page: page,
        pageSize: pageSize,
      );
      return DriverWalletWithdrawalsPageModelDto.fromJson(
        _normalizeMap(response),
      );
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<void> cancelWithdrawal(String withdrawalId) async {
    try {
      await _apiServices.cancelDriverWalletWithdrawal(withdrawalId);
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<Map<String, dynamic>> getPayoutPreference() async {
    try {
      return _normalizeMap(await _apiServices.getDriverWalletPayoutPreference());
    } on DioException catch (exception) { throw ApiExceptionMapper.fromDioException(exception); }
  }

  @override
  Future<Map<String, dynamic>> updatePayoutPreference(String payoutDay) async {
    try {
      return _normalizeMap(await _apiServices.updateDriverWalletPayoutPreference({'payoutDay': payoutDay}));
    } on DioException catch (exception) { throw ApiExceptionMapper.fromDioException(exception); }
  }

  Map<String, dynamic> _normalizeMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return const <String, dynamic>{};
  }
}
