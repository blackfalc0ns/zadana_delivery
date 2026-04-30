import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/order_details/domain/entities/order_assignment_details_entity.dart';
import 'package:zadana_delivery/features/order_details/domain/repo/order_details_repository.dart';

class VerifyPickupOtpUseCase {
  const VerifyPickupOtpUseCase(this._repository);

  final OrderDetailsRepository _repository;

  Future<ApiResult<OrderAssignmentDetailsEntity?>> call(
    String assignmentId, {
    required String otpCode,
  }) {
    return _repository.verifyPickupOtp(assignmentId, otpCode: otpCode);
  }
}
