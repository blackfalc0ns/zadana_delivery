import 'package:zadana_delivery/core/models/localized_message.dart';
import 'package:zadana_delivery/features/driver_home/data/models/driver_home_model_dto.dart';

abstract class DriverHomeRemoteDataSource {
  Future<DriverHomeModelDto> getHome();

  Future<LocalizedMessage> updateAvailability({required bool isAvailable});

  Future<LocalizedMessage> acceptOffer(String assignmentId);

  Future<LocalizedMessage> rejectOffer(String assignmentId, {String? reason});

  Stream<DriverHomeModelDto> watchHome();

  void emitHome(DriverHomeModelDto home);

  /// Real-time event streams from the active SignalR connection
  Stream<Map<String, dynamic>> get assignmentUpdatedStream;
  Stream<Map<String, dynamic>> get orderStatusChangedStream;
  Stream<Map<String, dynamic>> get arrivalStateChangedStream;

  Future<void> disconnectRealtime();
}
