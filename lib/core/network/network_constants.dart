abstract class NetworkConstants {
  static const String baseUrl = "https://api.zadna0.com/api";
  static const String authorization = 'Authorization';
  static const String bearer = "Bearer";
  static const String notificationsHub = '/hubs/notifications';
  static const String orderTrackingHub = '/hubs/order-tracking';
  static const String nativeNotificationsChannel =
      'zadana_delivery/native_notifications';
  static const String tripOverlayChannel = 'zadana_delivery/trip_overlay';
  static const String driverDeliveryOfferEvent = 'ReceiveDeliveryOffer';
  static const String driverNotificationEvent = 'ReceiveNotification';
  static const String driverOrderStatusChangedEvent =
      'ReceiveOrderStatusChanged';
  static const String driverOrderSupportCaseChangedEvent =
      'ReceiveOrderSupportCaseChanged';
  static const String driverSupportCaseChangedEvent =
      'ReceiveDriverSupportCaseChanged';
  static const String driverArrivalStateChangedEvent =
      'ReceiveDriverArrivalStateChanged';
  static const String driverAssignmentUpdatedEvent = 'ReceiveAssignmentUpdated';
  static const String driverHomeUpdatedEvent = 'ReceiveDriverHomeUpdated';
  static const String driverWalletUpdatedEvent = 'ReceiveDriverWalletUpdated';
  static const String orderTrackingStatusChangedEvent =
      'ReceiveOrderTrackingStatusChanged';
  static const String orderTrackingArrivalStateEvent =
      'ReceiveOrderTrackingArrivalState';
  static const String driverOfferNotificationType = 'driver-offer';
}

abstract class EndPoints {
  static const String registrationUploadTokenIssue =
      '/registration-upload-tokens/issue';
  static const String fileUpload = '/files/upload';
  static const String driverRegister = '/drivers/register';
  static const String driverLogin = '/drivers/auth/login';
  static const String driverVerifyOtp = '/drivers/auth/verify-otp';
  static const String driverResendOtp = '/drivers/auth/resend-otp';
  static const String driverForgotPassword = '/drivers/auth/forgot-password';
  static const String driverVerifyResetOtp = '/drivers/auth/verify-reset-otp';
  static const String driverResetPassword = '/drivers/auth/reset-password';
  static const String driverRefreshToken = '/drivers/auth/refresh-token';
  static const String driverLogout = '/drivers/auth/logout';
  static const String driverProfile = '/drivers/auth/me';
  static const String driverProfilePhoto = '/drivers/auth/me/profile-photo';
  static const String driverStatus = '/drivers/me/status';
  static const String driverHome = '/drivers/home';
  static const String driverAvailability = '/drivers/me/availability';
  static const String driverLocation = '/drivers/location';
  static const String driverCompletedOrders = '/drivers/orders/completed';
  static const String driverAssignmentDetails =
      '/drivers/assignments/{assignmentId}';
  static const String driverCurrentAssignment = '/drivers/assignments/current';
  static const String driverAssignmentStatus =
      '/drivers/assignments/{assignmentId}/status';
  static const String driverAssignmentVerifyOtp =
      '/drivers/assignments/{assignmentId}/verify-otp';
  static const String driverAssignmentResendOtp =
      '/drivers/assignments/{assignmentId}/resend-otp';
  static const String driverOrderArrivedAtVendor =
      '/drivers/orders/{orderId}/arrived-at-vendor';
  static const String driverOrderArrivedAtCustomer =
      '/drivers/orders/{orderId}/arrived-at-customer';
  static const String driverOrderPickedUp =
      '/drivers/orders/{orderId}/picked-up';
  static const String driverOrderOnTheWay =
      '/drivers/orders/{orderId}/on-the-way';
  static const String driverOrderDelivered =
      '/drivers/orders/{orderId}/delivered';
  static const String driverOrderDeliveryFailed =
      '/drivers/orders/{orderId}/delivery-failed';
  static const String driverNotifications = '/drivers/notifications';
  static const String driverNotificationDevices =
      '/drivers/notifications/devices';
  static const String driverNotificationRead =
      '/drivers/notifications/{notificationId}/read';
  static const String driverNotificationsReadAll =
      '/drivers/notifications/read-all';
  static const String driverNotificationsUnreadCount =
      '/drivers/notifications/unread-count';
  static const String driverWallet = '/drivers/wallet';
  static const String driverWalletTransactions = '/drivers/wallet/transactions';
  static const String driverWalletPaymentMethods =
      '/drivers/wallet/payment-methods';
  static const String driverWalletPaymentMethodPrimary =
      '/drivers/wallet/payment-methods/{id}/make-primary';
  static const String driverWalletWithdrawals = '/drivers/wallet/withdrawals';
  static const String driverWalletWithdrawalSettings =
      '/drivers/wallet/withdrawal-settings';
  static const String driverWalletPayoutPreference =
      '/drivers/wallet/payout-preference';
  static const String driverWalletWithdrawalCancel =
      '/drivers/wallet/withdrawals/{withdrawalId}/cancel';
  static const String driverSupportCases = '/drivers/support/cases';
  static const String driverSupportCaseDetails =
      '/drivers/support/cases/{caseId}';
  static const String driverSupportAccountCases =
      '/drivers/support/account-cases';
  static const String driverSupportAccountCaseDetails =
      '/drivers/support/account-cases/{caseId}';
  static const String driverSupportReasons = '/drivers/support/reasons/{type}';
  static const String driverOrderReportIssue =
      '/drivers/support/orders/{orderId}/report-issue';
  static const String driverOrderDispute =
      '/drivers/support/orders/{orderId}/dispute';
  static const String driverSupportCaseMessages =
      '/drivers/support/orders/{orderId}/cases/{caseId}/messages';
  static const String driverSupportAccountCaseMessages =
      '/drivers/support/account-cases/{caseId}/messages';
  static const String driverSupportAccountAppeals =
      '/drivers/support/account-appeals';
  static const String driverAccountSupportAppeals =
      '/drivers/account-support/appeals';
  static const String driverUnifiedProfile = '/drivers/me/profile';
  static const String driverProfilePersonal = '/drivers/me/profile/personal';
  static const String driverProfileVehicle = '/drivers/me/profile/vehicle';
  static const String driverProfileDocuments = '/drivers/me/profile/documents';
  static const String driverZones = '/geography/regions';
  static const String driverZoneCities =
      '/geography/driver/regions/{regionCode}/cities';

  static const String register = "/customers/auth/register";
  static const String login = '/customers/auth/login';
  static const String forgetPassword = '/customers/auth/forgot-password';
  static const String resetPassword = '/customers/auth/reset-password';
  static const String verifyOtp = '/customers/auth/verify-otp';
  static const String getProfile = '/customers/auth/me';
  static const String getAddress = '/location/address';
  static const String searchLocations = '/location/search';
}
