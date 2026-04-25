import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';

import '../entities/driver_unified_profile_entity.dart';
import '../entities/update_driver_documents_request_entity.dart';
import '../repo/driver_profile_repository.dart';

@injectable
class UpdateDriverDocumentsUseCase {
  const UpdateDriverDocumentsUseCase(this._repository);

  final DriverProfileRepository _repository;

  Future<ApiResult<DriverUnifiedProfileEntity>> call(
    UpdateDriverDocumentsRequestEntity request,
  ) {
    return _repository.updateDocuments(request);
  }
}
