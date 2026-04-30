import 'package:get_it/get_it.dart';
import 'package:zadana_delivery/core/helpers/permision_service.dart';
import 'package:zadana_delivery/core/services/driver_realtime_service.dart';
import 'package:zadana_delivery/core/services/driver_runtime_services_controller.dart';
import 'package:zadana_delivery/core/services/token_service.dart';
import 'package:zadana_delivery/features/driver_home/domain/usecase/watch_driver_home_usecase.dart';
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
import 'package:zadana_delivery/features/order_details/domain/usecase/update_assignment_status_usecase.dart';
import 'package:zadana_delivery/features/order_details/domain/usecase/verify_delivery_otp_usecase.dart';
import 'package:zadana_delivery/features/order_details/domain/usecase/verify_pickup_otp_usecase.dart';

void registerManualDependencies(GetIt getIt) {
  if (!getIt.isRegistered<DriverRealtimeService>()) {
    getIt.registerLazySingleton<DriverRealtimeService>(
      () => DriverRealtimeService(getIt<TokenService>()),
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

}
