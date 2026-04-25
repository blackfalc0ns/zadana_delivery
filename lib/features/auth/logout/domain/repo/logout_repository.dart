import 'package:zadana_delivery/core/network/api_results.dart';

abstract class LogoutRepository {
  Future<ApiResult<void>> logout();
}
