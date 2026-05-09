import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:zadana_delivery/core/helpers/permision_service.dart';
import 'package:zadana_delivery/core/services/app_navigator_service.dart';
import 'package:zadana_delivery/core/services/driver_local_notification_service.dart';
import 'package:zadana_delivery/core/services/driver_notification_bootstrap_service.dart';
import 'package:zadana_delivery/core/services/driver_notification_dedup_service.dart';
import 'package:zadana_delivery/core/services/driver_notification_device_service.dart';
import 'package:zadana_delivery/core/services/driver_notification_launch_payload_service.dart';
import 'package:zadana_delivery/core/services/driver_notification_overlay_service.dart';
import 'package:zadana_delivery/core/services/driver_notification_router_service.dart';
import 'package:zadana_delivery/core/services/driver_notification_session_service.dart';
import 'package:zadana_delivery/core/services/driver_realtime_service.dart';
import 'package:zadana_delivery/core/services/driver_runtime_services_controller.dart';
import 'package:zadana_delivery/core/services/language_service.dart';
import 'package:zadana_delivery/core/services/token_service.dart';
import 'package:zadana_delivery/features/driver_home/data/data_source/driver_home_remote_data_source.dart';
import 'package:zadana_delivery/features/driver_home/domain/usecase/watch_driver_home_usecase.dart';
import 'package:zadana_delivery/features/driver_support/domain/repo/driver_support_repository.dart';
import 'package:zadana_delivery/features/driver_support/domain/usecase/create_driver_order_dispute_usecase.dart';
import 'package:zadana_delivery/features/driver_support/domain/usecase/get_driver_support_case_details_usecase.dart';
import 'package:zadana_delivery/features/driver_support/domain/usecase/get_driver_support_cases_usecase.dart';
import 'package:zadana_delivery/features/driver_support/domain/usecase/get_driver_support_reasons_usecase.dart';
import 'package:zadana_delivery/features/driver_support/domain/usecase/report_driver_order_issue_usecase.dart';
import 'package:zadana_delivery/features/driver_support/domain/usecase/send_driver_support_case_message_usecase.dart';
import 'package:zadana_delivery/features/driver_support/presentation/manager/driver_support_cubit.dart';
import 'package:zadana_delivery/features/driver_tracking/data/data_source/driver_tracking_remote_data_source.dart';
import 'package:zadana_delivery/features/driver_tracking/data/data_source/driver_tracking_remote_data_source_impl.dart';
import 'package:zadana_delivery/features/driver_tracking/data/repo/driver_tracking_repository_impl.dart';
import 'package:zadana_delivery/features/driver_tracking/domain/repo/driver_tracking_repository.dart';
import 'package:zadana_delivery/features/driver_tracking/domain/usecase/push_driver_location_usecase.dart';
import 'package:zadana_delivery/features/driver_tracking/domain/usecase/start_driver_tracking_usecase.dart';
import 'package:zadana_delivery/features/driver_tracking/domain/usecase/stop_driver_tracking_usecase.dart';
import 'package:zadana_delivery/features/driver_tracking/domain/usecase/sync_driver_tracking_status_usecase.dart';
import 'package:zadana_delivery/features/driver_tracking/presentation/manager/driver_tracking_cubit.dart';
import 'package:zadana_delivery/features/order_details/domain/repo/order_details_repository.dart';
import 'package:zadana_delivery/features/order_details/domain/usecase/mark_order_arrived_at_customer_usecase.dart';
import 'package:zadana_delivery/features/order_details/domain/usecase/mark_order_arrived_at_vendor_usecase.dart';
import 'package:zadana_delivery/features/order_details/domain/usecase/mark_order_delivered_usecase.dart';
import 'package:zadana_delivery/features/order_details/domain/usecase/mark_order_delivery_failed_usecase.dart';
import 'package:zadana_delivery/features/order_details/domain/usecase/mark_order_on_the_way_usecase.dart';
import 'package:zadana_delivery/features/order_details/domain/usecase/mark_order_picked_up_usecase.dart';
import 'package:zadana_delivery/features/order_details/domain/usecase/resend_delivery_otp_usecase.dart';
import 'package:zadana_delivery/features/order_details/domain/usecase/resend_pickup_otp_usecase.dart';
import 'package:zadana_delivery/features/order_details/domain/usecase/update_assignment_status_usecase.dart';
import 'package:zadana_delivery/features/order_details/domain/usecase/verify_delivery_otp_usecase.dart';
import 'package:zadana_delivery/features/order_details/domain/usecase/verify_pickup_otp_usecase.dart';
import 'package:zadana_delivery/features/wallet/data/data_source/wallet_remote_data_source.dart';
import 'package:zadana_delivery/features/wallet/data/data_source/wallet_remote_data_source_impl.dart';
import 'package:zadana_delivery/features/wallet/data/repo/wallet_repository_impl.dart';
import 'package:zadana_delivery/features/wallet/domain/repo/wallet_repository.dart';
import 'package:zadana_delivery/features/wallet/domain/usecase/create_driver_wallet_payment_method_usecase.dart';
import 'package:zadana_delivery/features/wallet/domain/usecase/create_driver_wallet_withdrawal_usecase.dart';
import 'package:zadana_delivery/features/wallet/domain/usecase/delete_driver_wallet_payment_method_usecase.dart';
import 'package:zadana_delivery/features/wallet/domain/usecase/get_driver_wallet_payment_methods_usecase.dart';
import 'package:zadana_delivery/features/wallet/domain/usecase/get_driver_wallet_summary_usecase.dart';
import 'package:zadana_delivery/features/wallet/domain/usecase/get_driver_wallet_transactions_usecase.dart';
import 'package:zadana_delivery/features/wallet/domain/usecase/get_driver_wallet_withdrawals_usecase.dart';
import 'package:zadana_delivery/features/wallet/domain/usecase/make_driver_wallet_payment_method_primary_usecase.dart';
import 'package:zadana_delivery/features/wallet/domain/usecase/update_driver_wallet_payment_method_usecase.dart';
import 'package:zadana_delivery/features/wallet/presentation/manager/wallet_view_model.dart';

void registerManualDependencies(GetIt getIt) {
  if (!getIt.isRegistered<AppNavigatorService>()) {
    getIt.registerLazySingleton<AppNavigatorService>(AppNavigatorService.new);
  }

  if (!getIt.isRegistered<DriverNotificationDedupService>()) {
    getIt.registerLazySingleton<DriverNotificationDedupService>(
      DriverNotificationDedupService.new,
    );
  }

  if (!getIt.isRegistered<DriverRealtimeService>()) {
    getIt.registerLazySingleton<DriverRealtimeService>(
      () => DriverRealtimeService(getIt<TokenService>()),
    );
  }

  if (!getIt.isRegistered<DriverNotificationRouterService>()) {
    getIt.registerLazySingleton<DriverNotificationRouterService>(
      () => DriverNotificationRouterService(
        getIt<AppNavigatorService>(),
        getIt<DriverNotificationDedupService>(),
      ),
    );
  }

  if (!getIt.isRegistered<DriverLocalNotificationService>()) {
    getIt.registerLazySingleton<DriverLocalNotificationService>(
      () => DriverLocalNotificationService(
        getIt<DriverNotificationRouterService>(),
      ),
    );
  }

  if (!getIt.isRegistered<DriverNotificationDeviceService>()) {
    getIt.registerLazySingleton<DriverNotificationDeviceService>(
      () => DriverNotificationDeviceService(
        getIt<Dio>(),
        getIt(),
        getIt<TokenService>(),
        getIt<LanguageService>(),
      ),
    );
  }

  if (!getIt.isRegistered<DriverNotificationLaunchPayloadService>()) {
    getIt.registerLazySingleton<DriverNotificationLaunchPayloadService>(
      DriverNotificationLaunchPayloadService.new,
    );
  }

  if (!getIt.isRegistered<DriverNotificationOverlayService>()) {
    getIt.registerLazySingleton<DriverNotificationOverlayService>(
      () => DriverNotificationOverlayService(
        getIt<AppNavigatorService>(),
        getIt<DriverNotificationRouterService>(),
        getIt<DriverNotificationDedupService>(),
        getIt<DriverRealtimeService>(),
      ),
    );
  }

  if (!getIt.isRegistered<DriverNotificationBootstrapService>()) {
    getIt.registerLazySingleton<DriverNotificationBootstrapService>(
      () => DriverNotificationBootstrapService(
        getIt<AppNavigatorService>(),
        getIt<DriverLocalNotificationService>(),
        getIt<DriverNotificationDeviceService>(),
        getIt<DriverNotificationLaunchPayloadService>(),
        getIt<DriverNotificationOverlayService>(),
        getIt<DriverNotificationRouterService>(),
        getIt<TokenService>(),
      ),
    );
  }

  if (!getIt.isRegistered<DriverTrackingRemoteDataSource>()) {
    getIt.registerLazySingleton<DriverTrackingRemoteDataSource>(
      () => DriverTrackingRemoteDataSourceImpl(
        getIt<LocationPermissionService>(),
      ),
    );
  }

  if (!getIt.isRegistered<DriverTrackingRepository>()) {
    getIt.registerLazySingleton<DriverTrackingRepository>(
      () =>
          DriverTrackingRepositoryImpl(getIt<DriverTrackingRemoteDataSource>()),
    );
  }

  if (!getIt.isRegistered<DriverRuntimeServicesController>()) {
    getIt.registerLazySingleton<DriverRuntimeServicesController>(
      () => DriverRuntimeServicesController(
        getIt<DriverTrackingRepository>(),
        getIt<DriverRealtimeService>(),
      ),
    );
  }

  if (!getIt.isRegistered<DriverNotificationSessionService>()) {
    getIt.registerLazySingleton<DriverNotificationSessionService>(
      () => DriverNotificationSessionService(
        getIt<TokenService>(),
        getIt<DriverNotificationBootstrapService>(),
        getIt<DriverNotificationDeviceService>(),
        getIt<DriverRuntimeServicesController>(),
        getIt<DriverRealtimeService>(),
        getIt<DriverHomeRemoteDataSource>(),
        getIt<DriverNotificationRouterService>(),
        getIt<DriverNotificationDedupService>(),
      ),
    );
  }

  if (!getIt.isRegistered<StartDriverTrackingUseCase>()) {
    getIt.registerFactory<StartDriverTrackingUseCase>(
      () => StartDriverTrackingUseCase(getIt<DriverTrackingRepository>()),
    );
  }

  if (!getIt.isRegistered<StopDriverTrackingUseCase>()) {
    getIt.registerFactory<StopDriverTrackingUseCase>(
      () => StopDriverTrackingUseCase(getIt<DriverTrackingRepository>()),
    );
  }

  if (!getIt.isRegistered<SyncDriverTrackingStatusUseCase>()) {
    getIt.registerFactory<SyncDriverTrackingStatusUseCase>(
      () => SyncDriverTrackingStatusUseCase(getIt<DriverTrackingRepository>()),
    );
  }

  if (!getIt.isRegistered<PushDriverLocationUseCase>()) {
    getIt.registerFactory<PushDriverLocationUseCase>(
      () => PushDriverLocationUseCase(getIt<DriverTrackingRepository>()),
    );
  }

  if (!getIt.isRegistered<DriverTrackingCubit>()) {
    getIt.registerFactory<DriverTrackingCubit>(
      () => DriverTrackingCubit(
        getIt<WatchDriverHomeUseCase>(),
        getIt<StartDriverTrackingUseCase>(),
        getIt<StopDriverTrackingUseCase>(),
        getIt<SyncDriverTrackingStatusUseCase>(),
        getIt<PushDriverLocationUseCase>(),
        getIt<DriverTrackingRepository>(),
      ),
    );
  }

  if (!getIt.isRegistered<MarkOrderPickedUpUseCase>()) {
    getIt.registerFactory<MarkOrderPickedUpUseCase>(
      () => MarkOrderPickedUpUseCase(getIt<OrderDetailsRepository>()),
    );
  }

  if (!getIt.isRegistered<MarkOrderArrivedAtVendorUseCase>()) {
    getIt.registerFactory<MarkOrderArrivedAtVendorUseCase>(
      () => MarkOrderArrivedAtVendorUseCase(getIt<OrderDetailsRepository>()),
    );
  }

  if (!getIt.isRegistered<MarkOrderArrivedAtCustomerUseCase>()) {
    getIt.registerFactory<MarkOrderArrivedAtCustomerUseCase>(
      () => MarkOrderArrivedAtCustomerUseCase(getIt<OrderDetailsRepository>()),
    );
  }

  if (!getIt.isRegistered<MarkOrderOnTheWayUseCase>()) {
    getIt.registerFactory<MarkOrderOnTheWayUseCase>(
      () => MarkOrderOnTheWayUseCase(getIt<OrderDetailsRepository>()),
    );
  }

  if (!getIt.isRegistered<MarkOrderDeliveredUseCase>()) {
    getIt.registerFactory<MarkOrderDeliveredUseCase>(
      () => MarkOrderDeliveredUseCase(getIt<OrderDetailsRepository>()),
    );
  }

  if (!getIt.isRegistered<MarkOrderDeliveryFailedUseCase>()) {
    getIt.registerFactory<MarkOrderDeliveryFailedUseCase>(
      () => MarkOrderDeliveryFailedUseCase(getIt<OrderDetailsRepository>()),
    );
  }

  if (!getIt.isRegistered<UpdateAssignmentStatusUseCase>()) {
    getIt.registerFactory<UpdateAssignmentStatusUseCase>(
      () => UpdateAssignmentStatusUseCase(getIt<OrderDetailsRepository>()),
    );
  }

  if (!getIt.isRegistered<VerifyDeliveryOtpUseCase>()) {
    getIt.registerFactory<VerifyDeliveryOtpUseCase>(
      () => VerifyDeliveryOtpUseCase(getIt<OrderDetailsRepository>()),
    );
  }

  if (!getIt.isRegistered<VerifyPickupOtpUseCase>()) {
    getIt.registerFactory<VerifyPickupOtpUseCase>(
      () => VerifyPickupOtpUseCase(getIt<OrderDetailsRepository>()),
    );
  }

  if (!getIt.isRegistered<ResendDeliveryOtpUseCase>()) {
    getIt.registerFactory<ResendDeliveryOtpUseCase>(
      () => ResendDeliveryOtpUseCase(getIt<OrderDetailsRepository>()),
    );
  }

  if (!getIt.isRegistered<ResendPickupOtpUseCase>()) {
    getIt.registerFactory<ResendPickupOtpUseCase>(
      () => ResendPickupOtpUseCase(getIt<OrderDetailsRepository>()),
    );
  }

  if (!getIt.isRegistered<ReportDriverOrderIssueUseCase>()) {
    getIt.registerFactory<ReportDriverOrderIssueUseCase>(
      () => ReportDriverOrderIssueUseCase(getIt<DriverSupportRepository>()),
    );
  }

  if (!getIt.isRegistered<CreateDriverOrderDisputeUseCase>()) {
    getIt.registerFactory<CreateDriverOrderDisputeUseCase>(
      () => CreateDriverOrderDisputeUseCase(getIt<DriverSupportRepository>()),
    );
  }

  if (!getIt.isRegistered<GetDriverSupportCasesUseCase>()) {
    getIt.registerFactory<GetDriverSupportCasesUseCase>(
      () => GetDriverSupportCasesUseCase(getIt<DriverSupportRepository>()),
    );
  }

  if (!getIt.isRegistered<GetDriverSupportCaseDetailsUseCase>()) {
    getIt.registerFactory<GetDriverSupportCaseDetailsUseCase>(
      () =>
          GetDriverSupportCaseDetailsUseCase(getIt<DriverSupportRepository>()),
    );
  }

  if (!getIt.isRegistered<GetDriverSupportReasonsUseCase>()) {
    getIt.registerFactory<GetDriverSupportReasonsUseCase>(
      () => GetDriverSupportReasonsUseCase(getIt<DriverSupportRepository>()),
    );
  }

  if (!getIt.isRegistered<SendDriverSupportCaseMessageUseCase>()) {
    getIt.registerFactory<SendDriverSupportCaseMessageUseCase>(
      () =>
          SendDriverSupportCaseMessageUseCase(getIt<DriverSupportRepository>()),
    );
  }

  if (!getIt.isRegistered<DriverSupportCubit>()) {
    getIt.registerFactory<DriverSupportCubit>(
      () => DriverSupportCubit(
        getIt<GetDriverSupportCasesUseCase>(),
        getIt<GetDriverSupportCaseDetailsUseCase>(),
        getIt<SendDriverSupportCaseMessageUseCase>(),
        getIt<DriverRealtimeService>(),
      ),
    );
  }

  if (!getIt.isRegistered<WalletRemoteDataSource>()) {
    getIt.registerLazySingleton<WalletRemoteDataSource>(
      () => WalletRemoteDataSourceImpl(getIt()),
    );
  }

  if (!getIt.isRegistered<WalletRepository>()) {
    getIt.registerLazySingleton<WalletRepository>(
      () => WalletRepositoryImpl(getIt<WalletRemoteDataSource>()),
    );
  }

  if (!getIt.isRegistered<GetDriverWalletSummaryUseCase>()) {
    getIt.registerFactory<GetDriverWalletSummaryUseCase>(
      () => GetDriverWalletSummaryUseCase(getIt<WalletRepository>()),
    );
  }

  if (!getIt.isRegistered<GetDriverWalletTransactionsUseCase>()) {
    getIt.registerFactory<GetDriverWalletTransactionsUseCase>(
      () => GetDriverWalletTransactionsUseCase(getIt<WalletRepository>()),
    );
  }

  if (!getIt.isRegistered<GetDriverWalletPaymentMethodsUseCase>()) {
    getIt.registerFactory<GetDriverWalletPaymentMethodsUseCase>(
      () => GetDriverWalletPaymentMethodsUseCase(getIt<WalletRepository>()),
    );
  }

  if (!getIt.isRegistered<CreateDriverWalletPaymentMethodUseCase>()) {
    getIt.registerFactory<CreateDriverWalletPaymentMethodUseCase>(
      () => CreateDriverWalletPaymentMethodUseCase(getIt<WalletRepository>()),
    );
  }

  if (!getIt.isRegistered<UpdateDriverWalletPaymentMethodUseCase>()) {
    getIt.registerFactory<UpdateDriverWalletPaymentMethodUseCase>(
      () => UpdateDriverWalletPaymentMethodUseCase(getIt<WalletRepository>()),
    );
  }

  if (!getIt.isRegistered<DeleteDriverWalletPaymentMethodUseCase>()) {
    getIt.registerFactory<DeleteDriverWalletPaymentMethodUseCase>(
      () => DeleteDriverWalletPaymentMethodUseCase(getIt<WalletRepository>()),
    );
  }

  if (!getIt.isRegistered<MakeDriverWalletPaymentMethodPrimaryUseCase>()) {
    getIt.registerFactory<MakeDriverWalletPaymentMethodPrimaryUseCase>(
      () => MakeDriverWalletPaymentMethodPrimaryUseCase(
        getIt<WalletRepository>(),
      ),
    );
  }

  if (!getIt.isRegistered<CreateDriverWalletWithdrawalUseCase>()) {
    getIt.registerFactory<CreateDriverWalletWithdrawalUseCase>(
      () => CreateDriverWalletWithdrawalUseCase(getIt<WalletRepository>()),
    );
  }

  if (!getIt.isRegistered<GetDriverWalletWithdrawalsUseCase>()) {
    getIt.registerFactory<GetDriverWalletWithdrawalsUseCase>(
      () => GetDriverWalletWithdrawalsUseCase(getIt<WalletRepository>()),
    );
  }

  if (!getIt.isRegistered<WalletViewModel>()) {
    getIt.registerFactory<WalletViewModel>(
      () => WalletViewModel(
        getIt<GetDriverWalletSummaryUseCase>(),
        getIt<GetDriverWalletTransactionsUseCase>(),
        getIt<GetDriverWalletPaymentMethodsUseCase>(),
        getIt<CreateDriverWalletPaymentMethodUseCase>(),
        getIt<UpdateDriverWalletPaymentMethodUseCase>(),
        getIt<DeleteDriverWalletPaymentMethodUseCase>(),
        getIt<MakeDriverWalletPaymentMethodPrimaryUseCase>(),
        getIt<CreateDriverWalletWithdrawalUseCase>(),
        getIt<GetDriverWalletWithdrawalsUseCase>(),
        getIt<DriverRealtimeService>(),
      ),
    );
  }
}
