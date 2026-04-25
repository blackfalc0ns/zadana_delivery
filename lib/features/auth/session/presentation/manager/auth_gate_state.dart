class AuthGateState {
  const AuthGateState({this.isLoading = false, this.targetRoute});

  final bool isLoading;
  final String? targetRoute;

  AuthGateState copyWith({
    bool? isLoading,
    String? targetRoute,
    bool clearTargetRoute = false,
  }) {
    return AuthGateState(
      isLoading: isLoading ?? this.isLoading,
      targetRoute: clearTargetRoute ? null : targetRoute ?? this.targetRoute,
    );
  }
}
