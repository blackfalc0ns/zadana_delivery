class DriverTrackingStateEntity {
  const DriverTrackingStateEntity({
    required this.isTracking,
    required this.isStarting,
    required this.isStopping,
    required this.activeOrderId,
    required this.activePhase,
    this.lastSentLatitude,
    this.lastSentLongitude,
    this.lastSentAccuracyMeters,
    this.lastSentAt,
    this.failure,
  });

  final bool isTracking;
  final bool isStarting;
  final bool isStopping;
  final double? lastSentLatitude;
  final double? lastSentLongitude;
  final double? lastSentAccuracyMeters;
  final DateTime? lastSentAt;
  final String? activeOrderId;
  final String? activePhase;
  final String? failure;

  DriverTrackingStateEntity copyWith({
    bool? isTracking,
    bool? isStarting,
    bool? isStopping,
    double? lastSentLatitude,
    double? lastSentLongitude,
    double? lastSentAccuracyMeters,
    DateTime? lastSentAt,
    String? activeOrderId,
    String? activePhase,
    String? failure,
    bool clearFailure = false,
  }) {
    return DriverTrackingStateEntity(
      isTracking: isTracking ?? this.isTracking,
      isStarting: isStarting ?? this.isStarting,
      isStopping: isStopping ?? this.isStopping,
      lastSentLatitude: lastSentLatitude ?? this.lastSentLatitude,
      lastSentLongitude: lastSentLongitude ?? this.lastSentLongitude,
      lastSentAccuracyMeters:
          lastSentAccuracyMeters ?? this.lastSentAccuracyMeters,
      lastSentAt: lastSentAt ?? this.lastSentAt,
      activeOrderId: activeOrderId ?? this.activeOrderId,
      activePhase: activePhase ?? this.activePhase,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }
}

class DriverTrackingCommandEntity {
  const DriverTrackingCommandEntity({
    required this.orderId,
    required this.phase,
    required this.foregroundIntervalSeconds,
    required this.backgroundIntervalSeconds,
    required this.useHighAccuracy,
  });

  final String orderId;
  final String phase;
  final int foregroundIntervalSeconds;
  final int backgroundIntervalSeconds;
  final bool useHighAccuracy;

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'phase': phase,
      'foregroundIntervalSeconds': foregroundIntervalSeconds,
      'backgroundIntervalSeconds': backgroundIntervalSeconds,
      'useHighAccuracy': useHighAccuracy,
    };
  }
}
