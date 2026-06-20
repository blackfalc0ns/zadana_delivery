/// Represents the support case type that the driver can create.
enum OrderSupportMode { issue, dispute }

extension OrderSupportModeX on OrderSupportMode {
  String get reasonType =>
      this == OrderSupportMode.issue ? 'report' : 'dispute';
}
