import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/order_details/domain/entities/order_assignment_details_entity.dart';
import 'package:zadana_delivery/features/order_details/domain/repo/order_details_repository.dart';

@injectable
class GetOrderAssignmentDetailsUseCase {
  const GetOrderAssignmentDetailsUseCase(this._repository);

  final OrderDetailsRepository _repository;

  Future<ApiResult<OrderAssignmentDetailsEntity>> call(String assignmentId) {
    return _repository.getAssignmentDetails(assignmentId);
  }
}
