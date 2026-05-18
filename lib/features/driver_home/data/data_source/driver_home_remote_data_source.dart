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

  /// Ensures the home realtime SignalR connection is active.
  /// Should be called on app resume to recover from silently dropped connections.
  Future<void> ensureRealtimeConnected();

  /// Called when a delivery-offer push notification arrives via OneSignal.
  /// Forces a home refresh to pick up the offer that SignalR may have missed.
  Future<void> notifyOfferPushReceived();

  Future<void> disconnectRealtime();
}
