import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';

import '../../domain/entities/forgot_password_request_entity.dart';
import '../../domain/entities/forgot_password_response_entity.dart';
import '../../domain/repo/forgot_password_repository.dart';
import '../data_source/forgot_password_remote_data_source.dart';
import '../mapper/mapper_forgot_password.dart';

@Injectable(as: ForgotPasswordRepository)
class ForgotPasswordRepositoryImpl implements ForgotPasswordRepository {
  const ForgotPasswordRepositoryImpl(this._dataSource);

  final ForgotPasswordRemoteDataSource _dataSource;

  @override
  Future<ApiResult<ForgotPasswordResponseEntity>> sendCode(
    ForgotPasswordRequestEntity request,
  ) {
    return safeApiCall(() async {
      final response = await _dataSource.sendCode(request.toDto());
      return response.toEntity();
    });
  }
}
