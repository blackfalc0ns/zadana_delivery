import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/order_details/data/data_source/order_details_remote_data_source.dart';
import 'package:zadana_delivery/features/order_details/data/mapper/order_assignment_details_mapper.dart';
import 'package:zadana_delivery/features/order_details/domain/entities/order_assignment_details_entity.dart';
import 'package:zadana_delivery/features/order_details/domain/repo/order_details_repository.dart';

@Injectable(as: OrderDetailsRepository)
class OrderDetailsRepositoryImpl implements OrderDetailsRepository {
  const OrderDetailsRepositoryImpl(this._remoteDataSource);

  final OrderDetailsRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<OrderAssignmentDetailsEntity>> getAssignmentDetails(
    String assignmentId,
  ) {
    return safeApiCall(() async {
      final details = await _remoteDataSource.getAssignmentDetails(
        assignmentId,
      );
      return details.toEntity();
    });
  }
}
