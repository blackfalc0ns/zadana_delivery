class DriverTrackingState {
  const DriverTrackingState({
    this.isTracking = false,
    this.isStarting = false,
    this.isStopping = false,
    this.lastSentLatitude,
    this.lastSentLongitude,
    this.lastSentAccuracyMeters,
    this.lastSentAt,
    this.activeOrderId,
    this.activePhase,
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

  DriverTrackingState copyWith({
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
    bool clearActiveOrderId = false,
    bool clearActivePhase = false,
  }) {
    return DriverTrackingState(
      isTracking: isTracking ?? this.isTracking,
      isStarting: isStarting ?? this.isStarting,
      isStopping: isStopping ?? this.isStopping,
      lastSentLatitude: lastSentLatitude ?? this.lastSentLatitude,
      lastSentLongitude: lastSentLongitude ?? this.lastSentLongitude,
      lastSentAccuracyMeters:
          lastSentAccuracyMeters ?? this.lastSentAccuracyMeters,
      lastSentAt: lastSentAt ?? this.lastSentAt,
      activeOrderId: clearActiveOrderId
          ? null
          : activeOrderId ?? this.activeOrderId,
      activePhase: clearActivePhase ? null : activePhase ?? this.activePhase,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }
}
