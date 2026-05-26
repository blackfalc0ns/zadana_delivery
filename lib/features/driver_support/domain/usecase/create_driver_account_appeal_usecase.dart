import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/models/localized_message.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_case_message_request_entity.dart';
import 'package:zadana_delivery/features/driver_support/domain/repo/driver_support_repository.dart';

@injectable
class CreateDriverAccountAppealUseCase {
  const CreateDriverAccountAppealUseCase(this._repository);

  final DriverSupportRepository _repository;

  Future<ApiResult<LocalizedMessage>> call({
    required DriverSupportCaseMessageRequestEntity request,
  }) {
    return _repository.createAccountAppeal(request: request);
  }
}
