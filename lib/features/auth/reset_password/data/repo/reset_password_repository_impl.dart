import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';

import '../../domain/entities/reset_password_request_entity.dart';
import '../../domain/entities/reset_password_response_entity.dart';
import '../../domain/repo/reset_password_repository.dart';
import '../data_source/reset_password_remote_data_source.dart';
import '../mapper/mapper_reset_password.dart';

@Injectable(as: ResetPasswordRepository)
class ResetPasswordRepositoryImpl implements ResetPasswordRepository {
  const ResetPasswordRepositoryImpl(this._dataSource);

  final ResetPasswordRemoteDataSource _dataSource;

  @override
  Future<ApiResult<ResetPasswordResponseEntity>> reset(
    ResetPasswordRequestEntity request,
  ) {
    return safeApiCall(() async {
      final response = await _dataSource.reset(request.toDto());
      return response.toEntity();
    });
  }
}
