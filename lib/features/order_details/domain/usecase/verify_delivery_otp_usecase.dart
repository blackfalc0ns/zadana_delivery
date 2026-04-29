import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/order_details/domain/repo/order_details_repository.dart';

class VerifyDeliveryOtpUseCase {
  const VerifyDeliveryOtpUseCase(this._repository);

  final OrderDetailsRepository _repository;

  Future<ApiResult<void>> call(
    String assignmentId, {
    required String otpCode,
  }) {
    return _repository.verifyDeliveryOtp(
      assignmentId,
      otpCode: otpCode,
    );
  }
}
