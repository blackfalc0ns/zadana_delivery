import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';

import '../../domain/entities/verify_reset_otp_request_entity.dart';
import '../../domain/entities/verify_reset_otp_response_entity.dart';
import '../../domain/repo/verify_reset_otp_repository.dart';
import '../data_source/verify_reset_otp_remote_data_source.dart';
import '../mapper/mapper_verify_reset_otp.dart';

@Injectable(as: VerifyResetOtpRepository)
class VerifyResetOtpRepositoryImpl implements VerifyResetOtpRepository {
  const VerifyResetOtpRepositoryImpl(this._dataSource);

  final VerifyResetOtpRemoteDataSource _dataSource;

  @override
  Future<ApiResult<VerifyResetOtpResponseEntity>> verify(
    VerifyResetOtpRequestEntity request,
  ) {
    return safeApiCall(() async {
      final response = await _dataSource.verify(request.toDto());
      return response.toEntity();
    });
  }
}
