// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:image_picker/image_picker.dart' as _i183;
import 'package:injectable/injectable.dart' as _i526;
import 'package:pretty_dio_logger/pretty_dio_logger.dart' as _i528;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/auth/account_status/data/data_source/driver_account_status_remote_data_source.dart'
    as _i893;
import '../../features/auth/account_status/data/data_source/driver_account_status_remote_data_source_impl.dart'
    as _i913;
import '../../features/auth/account_status/data/repo/driver_account_status_repository_impl.dart'
    as _i1023;
import '../../features/auth/account_status/domain/repo/driver_account_status_repository.dart'
    as _i661;
import '../../features/auth/account_status/domain/usecase/get_driver_account_status_usecase.dart'
    as _i570;
import '../../features/auth/data/driver_profile_service.dart' as _i550;
import '../../features/auth/forgot_password/data/data_source/forgot_password_remote_data_source.dart'
    as _i247;
import '../../features/auth/forgot_password/data/data_source/forgot_password_remote_data_source_impl.dart'
    as _i925;
import '../../features/auth/forgot_password/data/repo/forgot_password_repository_impl.dart'
    as _i573;
import '../../features/auth/forgot_password/domain/repo/forgot_password_repository.dart'
    as _i899;
import '../../features/auth/forgot_password/domain/usecase/forgot_password_usecase.dart'
    as _i731;
import '../../features/auth/forgot_password/presentation/manager/forgot_password_view_model.dart'
    as _i65;
import '../../features/auth/login/data/data_source/login_remote_data_source.dart'
    as _i520;
import '../../features/auth/login/data/data_source/login_remote_data_source_impl.dart'
    as _i1060;
import '../../features/auth/login/data/repo/login_repository_impl.dart' as _i17;
import '../../features/auth/login/domain/repo/login_repository.dart' as _i137;
import '../../features/auth/login/domain/usecase/login_usecase.dart' as _i817;
import '../../features/auth/login/presentation/manager/login_view_model.dart'
    as _i808;
import '../../features/auth/logout/data/data_source/logout_remote_data_source.dart'
    as _i513;
import '../../features/auth/logout/data/data_source/logout_remote_data_source_impl.dart'
    as _i19;
import '../../features/auth/logout/data/repo/logout_repository_impl.dart'
    as _i767;
import '../../features/auth/logout/domain/repo/logout_repository.dart' as _i751;
import '../../features/auth/logout/domain/usecase/logout_usecase.dart' as _i78;
import '../../features/auth/otp/data/data_source/driver_verify_otp_remote_data_source.dart'
    as _i548;
import '../../features/auth/otp/data/data_source/driver_verify_otp_remote_data_source_impl.dart'
    as _i798;
import '../../features/auth/otp/data/repo/driver_verify_otp_repository_impl.dart'
    as _i801;
import '../../features/auth/otp/domain/repo/driver_verify_otp_repository.dart'
    as _i338;
import '../../features/auth/otp/domain/usecase/resend_driver_otp_usecase.dart'
    as _i324;
import '../../features/auth/otp/domain/usecase/verify_driver_otp_usecase.dart'
    as _i371;
import '../../features/auth/otp/presentation/manager/driver_verify_otp_view_model.dart'
    as _i191;
import '../../features/auth/register/data/data_source/driver_zones_remote_data_source.dart'
    as _i897;
import '../../features/auth/register/data/data_source/driver_zones_remote_data_source_impl.dart'
    as _i291;
import '../../features/auth/register/data/data_source/register_remote_data_source.dart'
    as _i207;
import '../../features/auth/register/data/data_source/register_remote_data_source_impl.dart'
    as _i895;
import '../../features/auth/register/data/repo/driver_zones_repository_impl.dart'
    as _i772;
import '../../features/auth/register/data/repo/register_repository_impl.dart'
    as _i794;
import '../../features/auth/register/domain/repo/driver_zones_repository.dart'
    as _i599;
import '../../features/auth/register/domain/repo/register_repository.dart'
    as _i251;
import '../../features/auth/register/domain/usecase/get_driver_zones_usecase.dart'
    as _i985;
import '../../features/auth/register/domain/usecase/register_usecase.dart'
    as _i635;
import '../../features/auth/register/presentation/manager/register_zones_cubit.dart'
    as _i340;
import '../../features/auth/reset_password/data/data_source/reset_password_remote_data_source.dart'
    as _i454;
import '../../features/auth/reset_password/data/data_source/reset_password_remote_data_source_impl.dart'
    as _i17;
import '../../features/auth/reset_password/data/repo/reset_password_repository_impl.dart'
    as _i51;
import '../../features/auth/reset_password/domain/repo/reset_password_repository.dart'
    as _i985;
import '../../features/auth/reset_password/domain/usecase/reset_password_usecase.dart'
    as _i184;
import '../../features/auth/reset_password/presentation/manager/reset_password_view_model.dart'
    as _i641;
import '../../features/auth/session/data/data_source/auth_session_remote_data_source.dart'
    as _i430;
import '../../features/auth/session/data/data_source/auth_session_remote_data_source_impl.dart'
    as _i502;
import '../../features/auth/session/data/repo/auth_session_repository_impl.dart'
    as _i195;
import '../../features/auth/session/domain/repo/auth_session_repository.dart'
    as _i882;
import '../../features/auth/session/domain/usecase/get_current_driver_usecase.dart'
    as _i300;
import '../../features/auth/session/domain/usecase/refresh_token_usecase.dart'
    as _i771;
import '../../features/auth/session/domain/usecase/update_current_driver_usecase.dart'
    as _i949;
import '../../features/auth/session/presentation/manager/auth_gate_cubit.dart'
    as _i29;
import '../../features/completed_orders/data/data_source/completed_orders_remote_data_source.dart'
    as _i833;
import '../../features/completed_orders/data/data_source/completed_orders_remote_data_source_impl.dart'
    as _i855;
import '../../features/completed_orders/data/repo/completed_orders_repository_impl.dart'
    as _i563;
import '../../features/completed_orders/domain/repo/completed_orders_repository.dart'
    as _i929;
import '../../features/completed_orders/domain/usecase/get_completed_order_details_usecase.dart'
    as _i663;
import '../../features/completed_orders/domain/usecase/get_completed_orders_usecase.dart'
    as _i763;
import '../../features/completed_orders/presentation/manager/completed_orders_view_model.dart'
    as _i855;
import '../../features/driver_home/data/data_source/driver_home_remote_data_source.dart'
    as _i458;
import '../../features/driver_home/data/data_source/driver_home_remote_data_source_impl.dart'
    as _i682;
import '../../features/driver_home/data/repo/driver_home_repository_impl.dart'
    as _i720;
import '../../features/driver_home/domain/repo/driver_home_repository.dart'
    as _i803;
import '../../features/driver_home/domain/usecase/accept_driver_offer_usecase.dart'
    as _i725;
import '../../features/driver_home/domain/usecase/refresh_driver_home_usecase.dart'
    as _i656;
import '../../features/driver_home/domain/usecase/reject_driver_offer_usecase.dart'
    as _i618;
import '../../features/driver_home/domain/usecase/update_driver_availability_usecase.dart'
    as _i191;
import '../../features/driver_home/domain/usecase/watch_driver_home_usecase.dart'
    as _i802;
import '../../features/driver_home/presentation/manager/driver_home_cubit.dart'
    as _i569;
import '../../features/driver_support/data/data_source/driver_support_remote_data_source.dart'
    as _i889;
import '../../features/driver_support/data/data_source/driver_support_remote_data_source_impl.dart'
    as _i933;
import '../../features/driver_support/data/repo/driver_support_repository_impl.dart'
    as _i369;
import '../../features/driver_support/domain/repo/driver_support_repository.dart'
    as _i755;
import '../../features/driver_tracking/data/data_source/driver_tracking_remote_data_source.dart'
    as _i498;
import '../../features/driver_tracking/data/data_source/driver_tracking_remote_data_source_impl.dart'
    as _i402;
import '../../features/driver_tracking/data/repo/driver_tracking_repository_impl.dart'
    as _i228;
import '../../features/driver_tracking/domain/repo/driver_tracking_repository.dart'
    as _i649;
import '../../features/notifications/data/data_source/notifications_remote_data_source.dart'
    as _i173;
import '../../features/notifications/data/data_source/notifications_remote_data_source_impl.dart'
    as _i2;
import '../../features/notifications/data/repo/notifications_repository_impl.dart'
    as _i166;
import '../../features/notifications/domain/repo/notifications_repository.dart'
    as _i341;
import '../../features/notifications/domain/usecase/get_driver_notifications_unread_count_usecase.dart'
    as _i261;
import '../../features/notifications/domain/usecase/get_driver_notifications_usecase.dart'
    as _i127;
import '../../features/notifications/domain/usecase/mark_all_driver_notifications_read_usecase.dart'
    as _i1063;
import '../../features/notifications/domain/usecase/mark_driver_notification_read_usecase.dart'
    as _i430;
import '../../features/notifications/presentation/manager/notifications_view_model.dart'
    as _i422;
import '../../features/order_details/data/data_source/order_details_remote_data_source.dart'
    as _i437;
import '../../features/order_details/data/data_source/order_details_remote_data_source_impl.dart'
    as _i104;
import '../../features/order_details/data/repo/order_details_repository_impl.dart'
    as _i565;
import '../../features/order_details/domain/repo/order_details_repository.dart'
    as _i656;
import '../../features/order_details/domain/usecase/get_order_assignment_details_usecase.dart'
    as _i696;
import '../../features/order_details/presentation/manager/order_details_cubit.dart'
    as _i992;
import '../../features/profile/data/data_source/driver_profile_remote_data_source.dart'
    as _i566;
import '../../features/profile/data/data_source/driver_profile_remote_data_source_impl.dart'
    as _i546;
import '../../features/profile/data/repo/driver_profile_repository_impl.dart'
    as _i852;
import '../../features/profile/domain/repo/driver_profile_repository.dart'
    as _i540;
import '../../features/profile/domain/usecase/get_driver_unified_profile_usecase.dart'
    as _i339;
import '../../features/profile/domain/usecase/update_driver_documents_usecase.dart'
    as _i373;
import '../../features/profile/domain/usecase/update_driver_personal_usecase.dart'
    as _i1047;
import '../../features/profile/domain/usecase/update_driver_vehicle_usecase.dart'
    as _i458;
import '../../features/profile/presentation/manager/profile_cubit.dart'
    as _i735;
import '../helpers/permision_service.dart' as _i367;
import '../helpers/shared_pref.dart' as _i42;
import '../network/api_services.dart' as _i804;
import '../network/external_modules.dart' as _i576;
import '../services/app_navigator_service.dart' as _i179;
import '../services/auth_refresh_service.dart' as _i820;
import '../services/driver_local_notification_service.dart' as _i430;
import '../services/driver_notification_bootstrap_service.dart' as _i223;
import '../services/driver_notification_dedup_service.dart' as _i889;
import '../services/driver_notification_device_service.dart' as _i1059;
import '../services/driver_notification_launch_payload_service.dart' as _i368;
import '../services/driver_notification_overlay_service.dart' as _i1015;
import '../services/driver_notification_router_service.dart' as _i585;
import '../services/driver_notification_session_service.dart' as _i30;
import '../services/driver_realtime_service.dart' as _i794;
import '../services/driver_runtime_services_controller.dart' as _i88;
import '../services/file_upload_service.dart' as _i102;
import '../services/language_interceptor.dart' as _i32;
import '../services/language_service.dart' as _i819;
import '../services/token_interceptor.dart' as _i1056;
import '../services/token_service.dart' as _i227;
import '../services/trip_request_global_alert_service.dart' as _i497;
import '../services/trip_request_overlay_service.dart' as _i952;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final externalModules = _$ExternalModules();
    gh.factory<_i367.LocationPermissionService>(
      () => _i367.LocationPermissionService(),
    );
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => externalModules.provideSharedPreferences,
      preResolve: true,
    );
    gh.lazySingleton<_i528.PrettyDioLogger>(
      () => externalModules.providePrettyDioLogger(),
    );
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => externalModules.flutterSecureStorage(),
    );
    gh.lazySingleton<_i550.DriverIdentityService>(
      () => externalModules.provideDriverIdentityService(),
    );
    gh.lazySingleton<_i550.DriverProfileDraftService>(
      () => externalModules.provideDriverProfileDraftService(),
    );
    gh.lazySingleton<_i183.ImagePicker>(
      () => externalModules.provideImagePicker(),
    );
    gh.lazySingleton<_i179.AppNavigatorService>(
      () => _i179.AppNavigatorService(),
    );
    gh.lazySingleton<_i889.DriverNotificationDedupService>(
      () => _i889.DriverNotificationDedupService(),
    );
    gh.lazySingleton<_i368.DriverNotificationLaunchPayloadService>(
      () => _i368.DriverNotificationLaunchPayloadService(),
    );
    gh.lazySingleton<_i361.Dio>(
      () => externalModules.provideRefreshDio(),
      instanceName: 'refreshDio',
    );
    gh.factory<_i42.SharedPrefHelper>(
      () => _i42.SharedPrefHelper(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i361.Dio>(
      () => externalModules.provideOsmDio(gh<_i528.PrettyDioLogger>()),
      instanceName: 'osmDio',
    );
    gh.lazySingleton<_i498.DriverTrackingRemoteDataSource>(
      () => _i402.DriverTrackingRemoteDataSourceImpl(
        gh<_i367.LocationPermissionService>(),
      ),
    );
    gh.lazySingleton<_i585.DriverNotificationRouterService>(
      () => _i585.DriverNotificationRouterService(
        gh<_i179.AppNavigatorService>(),
        gh<_i889.DriverNotificationDedupService>(),
      ),
    );
    gh.lazySingleton<_i649.DriverTrackingRepository>(
      () => _i228.DriverTrackingRepositoryImpl(
        gh<_i498.DriverTrackingRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i952.TripRequestOverlayService>(
      () => _i952.TripRequestOverlayService(gh<_i460.SharedPreferences>()),
    );
    gh.factory<_i227.TokenService>(
      () => _i227.TokenService(
        prefs: gh<_i558.FlutterSecureStorage>(),
        sharedPreferences: gh<_i460.SharedPreferences>(),
      ),
    );
    gh.factory<_i819.LanguageService>(
      () => _i819.LanguageService(gh<_i460.SharedPreferences>()),
    );
    gh.factory<_i820.AuthRefreshService>(
      () => _i820.AuthRefreshService(
        gh<_i361.Dio>(instanceName: 'refreshDio'),
        gh<_i227.TokenService>(),
      ),
    );
    gh.lazySingleton<_i794.DriverRealtimeService>(
      () => _i794.DriverRealtimeService(gh<_i227.TokenService>()),
    );
    gh.lazySingleton<_i430.DriverLocalNotificationService>(
      () => _i430.DriverLocalNotificationService(
        gh<_i585.DriverNotificationRouterService>(),
      ),
    );
    gh.factory<_i1056.TokenInterceptor>(
      () => _i1056.TokenInterceptor(
        gh<_i227.TokenService>(),
        gh<_i820.AuthRefreshService>(),
      ),
    );
    gh.lazySingleton<_i88.DriverRuntimeServicesController>(
      () => _i88.DriverRuntimeServicesController(
        gh<_i649.DriverTrackingRepository>(),
        gh<_i794.DriverRealtimeService>(),
      ),
    );
    gh.factory<_i32.LanguageInterceptor>(
      () => _i32.LanguageInterceptor(gh<_i819.LanguageService>()),
    );
    gh.lazySingleton<_i361.Dio>(
      () => externalModules.provideDio(
        gh<_i528.PrettyDioLogger>(),
        gh<_i1056.TokenInterceptor>(),
        gh<_i32.LanguageInterceptor>(),
      ),
    );
    gh.lazySingleton<_i1059.DriverNotificationDeviceService>(
      () => _i1059.DriverNotificationDeviceService(
        gh<_i361.Dio>(),
        gh<_i460.SharedPreferences>(),
        gh<_i227.TokenService>(),
        gh<_i819.LanguageService>(),
      ),
    );
    gh.lazySingleton<_i1015.DriverNotificationOverlayService>(
      () => _i1015.DriverNotificationOverlayService(
        gh<_i179.AppNavigatorService>(),
        gh<_i585.DriverNotificationRouterService>(),
        gh<_i889.DriverNotificationDedupService>(),
        gh<_i794.DriverRealtimeService>(),
      ),
    );
    gh.factory<_i804.ApiServices>(() => _i804.ApiServices(gh<_i361.Dio>()));
    gh.factory<_i247.ForgotPasswordRemoteDataSource>(
      () => _i925.ForgotPasswordRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i437.OrderDetailsRemoteDataSource>(
      () => _i104.OrderDetailsRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i833.CompletedOrdersRemoteDataSource>(
      () => _i855.CompletedOrdersRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i520.LoginRemoteDataSource>(
      () => _i1060.LoginRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i454.ResetPasswordRemoteDataSource>(
      () => _i17.ResetPasswordRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.lazySingleton<_i223.DriverNotificationBootstrapService>(
      () => _i223.DriverNotificationBootstrapService(
        gh<_i179.AppNavigatorService>(),
        gh<_i430.DriverLocalNotificationService>(),
        gh<_i1059.DriverNotificationDeviceService>(),
        gh<_i368.DriverNotificationLaunchPayloadService>(),
        gh<_i1015.DriverNotificationOverlayService>(),
        gh<_i585.DriverNotificationRouterService>(),
        gh<_i227.TokenService>(),
      ),
    );
    gh.factory<_i173.NotificationsRemoteDataSource>(
      () => _i2.NotificationsRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i656.OrderDetailsRepository>(
      () => _i565.OrderDetailsRepositoryImpl(
        gh<_i437.OrderDetailsRemoteDataSource>(),
      ),
    );
    gh.factory<_i893.DriverAccountStatusRemoteDataSource>(
      () => _i913.DriverAccountStatusRemoteDataSourceImpl(
        gh<_i804.ApiServices>(),
      ),
    );
    gh.factory<_i513.LogoutRemoteDataSource>(
      () => _i19.LogoutRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i889.DriverSupportRemoteDataSource>(
      () => _i933.DriverSupportRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i755.DriverSupportRepository>(
      () => _i369.DriverSupportRepositoryImpl(
        gh<_i889.DriverSupportRemoteDataSource>(),
      ),
    );
    gh.factory<_i566.DriverProfileRemoteDataSource>(
      () => _i546.DriverProfileRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.lazySingleton<_i458.DriverHomeRemoteDataSource>(
      () => _i682.DriverHomeRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i430.AuthSessionRemoteDataSource>(
      () => _i502.AuthSessionRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.lazySingleton<_i102.FileUploadService>(
      () => externalModules.provideFileUploadService(gh<_i804.ApiServices>()),
    );
    gh.factory<_i548.DriverVerifyOtpRemoteDataSource>(
      () => _i798.DriverVerifyOtpRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i899.ForgotPasswordRepository>(
      () => _i573.ForgotPasswordRepositoryImpl(
        gh<_i247.ForgotPasswordRemoteDataSource>(),
      ),
    );
    gh.factory<_i207.RegisterRemoteDataSource>(
      () => _i895.RegisterRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i661.DriverAccountStatusRepository>(
      () => _i1023.DriverAccountStatusRepositoryImpl(
        gh<_i893.DriverAccountStatusRemoteDataSource>(),
      ),
    );
    gh.factory<_i570.GetDriverAccountStatusUseCase>(
      () => _i570.GetDriverAccountStatusUseCase(
        gh<_i661.DriverAccountStatusRepository>(),
      ),
    );
    gh.factory<_i540.DriverProfileRepository>(
      () => _i852.DriverProfileRepositoryImpl(
        gh<_i566.DriverProfileRemoteDataSource>(),
        gh<_i102.FileUploadService>(),
        gh<_i550.DriverIdentityService>(),
        gh<_i550.DriverProfileDraftService>(),
      ),
    );
    gh.factory<_i731.ForgotPasswordUseCase>(
      () => _i731.ForgotPasswordUseCase(gh<_i899.ForgotPasswordRepository>()),
    );
    gh.factory<_i751.LogoutRepository>(
      () => _i767.LogoutRepositoryImpl(
        gh<_i513.LogoutRemoteDataSource>(),
        gh<_i227.TokenService>(),
        gh<_i550.DriverIdentityService>(),
        gh<_i550.DriverProfileDraftService>(),
      ),
    );
    gh.factory<_i897.DriverRegionsRemoteDataSource>(
      () => _i291.DriverRegionsRemoteDataSourceImpl(
        gh<_i804.ApiServices>(),
        gh<_i819.LanguageService>(),
      ),
    );
    gh.lazySingleton<_i30.DriverNotificationSessionService>(
      () => _i30.DriverNotificationSessionService(
        gh<_i227.TokenService>(),
        gh<_i223.DriverNotificationBootstrapService>(),
        gh<_i1059.DriverNotificationDeviceService>(),
        gh<_i88.DriverRuntimeServicesController>(),
        gh<_i794.DriverRealtimeService>(),
        gh<_i458.DriverHomeRemoteDataSource>(),
        gh<_i585.DriverNotificationRouterService>(),
        gh<_i889.DriverNotificationDedupService>(),
      ),
    );
    gh.factory<_i341.NotificationsRepository>(
      () => _i166.NotificationsRepositoryImpl(
        gh<_i173.NotificationsRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i497.TripRequestGlobalAlertService>(
      () => _i497.TripRequestGlobalAlertService(
        gh<_i952.TripRequestOverlayService>(),
        gh<_i794.DriverRealtimeService>(),
        gh<_i458.DriverHomeRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i803.DriverHomeRepository>(
      () => _i720.DriverHomeRepositoryImpl(
        gh<_i458.DriverHomeRemoteDataSource>(),
      ),
    );
    gh.factory<_i985.ResetPasswordRepository>(
      () => _i51.ResetPasswordRepositoryImpl(
        gh<_i454.ResetPasswordRemoteDataSource>(),
      ),
    );
    gh.factory<_i137.LoginRepository>(
      () => _i17.LoginRepositoryImpl(
        gh<_i520.LoginRemoteDataSource>(),
        gh<_i227.TokenService>(),
        gh<_i550.DriverIdentityService>(),
      ),
    );
    gh.factory<_i78.LogoutUseCase>(
      () => _i78.LogoutUseCase(gh<_i751.LogoutRepository>()),
    );
    gh.factory<_i261.GetDriverNotificationsUnreadCountUseCase>(
      () => _i261.GetDriverNotificationsUnreadCountUseCase(
        gh<_i341.NotificationsRepository>(),
      ),
    );
    gh.factory<_i127.GetDriverNotificationsUseCase>(
      () => _i127.GetDriverNotificationsUseCase(
        gh<_i341.NotificationsRepository>(),
      ),
    );
    gh.factory<_i1063.MarkAllDriverNotificationsReadUseCase>(
      () => _i1063.MarkAllDriverNotificationsReadUseCase(
        gh<_i341.NotificationsRepository>(),
      ),
    );
    gh.factory<_i430.MarkDriverNotificationReadUseCase>(
      () => _i430.MarkDriverNotificationReadUseCase(
        gh<_i341.NotificationsRepository>(),
      ),
    );
    gh.factory<_i422.NotificationsViewModel>(
      () => _i422.NotificationsViewModel(
        gh<_i127.GetDriverNotificationsUseCase>(),
        gh<_i430.MarkDriverNotificationReadUseCase>(),
        gh<_i1063.MarkAllDriverNotificationsReadUseCase>(),
        gh<_i261.GetDriverNotificationsUnreadCountUseCase>(),
      ),
    );
    gh.factory<_i251.RegisterRepository>(
      () => _i794.RegisterRepositoryImpl(
        gh<_i207.RegisterRemoteDataSource>(),
        gh<_i227.TokenService>(),
        gh<_i102.FileUploadService>(),
        gh<_i550.DriverIdentityService>(),
        gh<_i550.DriverProfileDraftService>(),
      ),
    );
    gh.factory<_i882.AuthSessionRepository>(
      () => _i195.AuthSessionRepositoryImpl(
        gh<_i430.AuthSessionRemoteDataSource>(),
        gh<_i227.TokenService>(),
        gh<_i550.DriverIdentityService>(),
      ),
    );
    gh.factory<_i599.DriverRegionsRepository>(
      () => _i772.DriverRegionsRepositoryImpl(
        gh<_i897.DriverRegionsRemoteDataSource>(),
      ),
    );
    gh.factory<_i929.CompletedOrdersRepository>(
      () => _i563.CompletedOrdersRepositoryImpl(
        gh<_i833.CompletedOrdersRemoteDataSource>(),
      ),
    );
    gh.factory<_i635.RegisterUseCase>(
      () => _i635.RegisterUseCase(gh<_i251.RegisterRepository>()),
    );
    gh.factory<_i696.GetOrderAssignmentDetailsUseCase>(
      () => _i696.GetOrderAssignmentDetailsUseCase(
        gh<_i656.OrderDetailsRepository>(),
      ),
    );
    gh.factory<_i338.DriverVerifyOtpRepository>(
      () => _i801.DriverVerifyOtpRepositoryImpl(
        gh<_i548.DriverVerifyOtpRemoteDataSource>(),
        gh<_i227.TokenService>(),
        gh<_i550.DriverIdentityService>(),
      ),
    );
    gh.factory<_i725.AcceptDriverOfferUseCase>(
      () => _i725.AcceptDriverOfferUseCase(gh<_i803.DriverHomeRepository>()),
    );
    gh.factory<_i656.RefreshDriverHomeUseCase>(
      () => _i656.RefreshDriverHomeUseCase(gh<_i803.DriverHomeRepository>()),
    );
    gh.factory<_i618.RejectDriverOfferUseCase>(
      () => _i618.RejectDriverOfferUseCase(gh<_i803.DriverHomeRepository>()),
    );
    gh.factory<_i191.UpdateDriverAvailabilityUseCase>(
      () => _i191.UpdateDriverAvailabilityUseCase(
        gh<_i803.DriverHomeRepository>(),
      ),
    );
    gh.factory<_i802.WatchDriverHomeUseCase>(
      () => _i802.WatchDriverHomeUseCase(gh<_i803.DriverHomeRepository>()),
    );
    gh.factory<_i339.GetDriverUnifiedProfileUseCase>(
      () => _i339.GetDriverUnifiedProfileUseCase(
        gh<_i540.DriverProfileRepository>(),
      ),
    );
    gh.factory<_i373.UpdateDriverDocumentsUseCase>(
      () => _i373.UpdateDriverDocumentsUseCase(
        gh<_i540.DriverProfileRepository>(),
      ),
    );
    gh.factory<_i1047.UpdateDriverPersonalUseCase>(
      () => _i1047.UpdateDriverPersonalUseCase(
        gh<_i540.DriverProfileRepository>(),
      ),
    );
    gh.factory<_i1047.UpdateDriverProfilePhotoUseCase>(
      () => _i1047.UpdateDriverProfilePhotoUseCase(
        gh<_i540.DriverProfileRepository>(),
      ),
    );
    gh.factory<_i1047.DeleteDriverProfilePhotoUseCase>(
      () => _i1047.DeleteDriverProfilePhotoUseCase(
        gh<_i540.DriverProfileRepository>(),
      ),
    );
    gh.factory<_i458.UpdateDriverVehicleUseCase>(
      () =>
          _i458.UpdateDriverVehicleUseCase(gh<_i540.DriverProfileRepository>()),
    );
    gh.factory<_i65.ForgotPasswordViewModel>(
      () => _i65.ForgotPasswordViewModel(gh<_i731.ForgotPasswordUseCase>()),
    );
    gh.factory<_i29.AuthGateCubit>(
      () => _i29.AuthGateCubit(
        gh<_i227.TokenService>(),
        gh<_i570.GetDriverAccountStatusUseCase>(),
        gh<_i78.LogoutUseCase>(),
      ),
    );
    gh.factory<_i992.OrderDetailsCubit>(
      () =>
          _i992.OrderDetailsCubit(gh<_i696.GetOrderAssignmentDetailsUseCase>()),
    );
    gh.factory<_i985.GetDriverRegionsUseCase>(
      () => _i985.GetDriverRegionsUseCase(gh<_i599.DriverRegionsRepository>()),
    );
    gh.factory<_i184.ResetPasswordUseCase>(
      () => _i184.ResetPasswordUseCase(gh<_i985.ResetPasswordRepository>()),
    );
    gh.factory<_i663.GetCompletedOrderDetailsUseCase>(
      () => _i663.GetCompletedOrderDetailsUseCase(
        gh<_i929.CompletedOrdersRepository>(),
      ),
    );
    gh.factory<_i763.GetCompletedOrdersUseCase>(
      () => _i763.GetCompletedOrdersUseCase(
        gh<_i929.CompletedOrdersRepository>(),
      ),
    );
    gh.factory<_i300.GetCurrentDriverUseCase>(
      () => _i300.GetCurrentDriverUseCase(gh<_i882.AuthSessionRepository>()),
    );
    gh.factory<_i771.RefreshTokenUseCase>(
      () => _i771.RefreshTokenUseCase(gh<_i882.AuthSessionRepository>()),
    );
    gh.factory<_i949.UpdateCurrentDriverUseCase>(
      () => _i949.UpdateCurrentDriverUseCase(gh<_i882.AuthSessionRepository>()),
    );
    gh.factory<_i817.LoginUseCase>(
      () => _i817.LoginUseCase(gh<_i137.LoginRepository>()),
    );
    gh.factory<_i324.ResendDriverOtpUseCase>(
      () => _i324.ResendDriverOtpUseCase(gh<_i338.DriverVerifyOtpRepository>()),
    );
    gh.factory<_i371.VerifyDriverOtpUseCase>(
      () => _i371.VerifyDriverOtpUseCase(gh<_i338.DriverVerifyOtpRepository>()),
    );
    gh.factory<_i569.DriverHomeCubit>(
      () => _i569.DriverHomeCubit(
        gh<_i802.WatchDriverHomeUseCase>(),
        gh<_i656.RefreshDriverHomeUseCase>(),
        gh<_i191.UpdateDriverAvailabilityUseCase>(),
        gh<_i725.AcceptDriverOfferUseCase>(),
        gh<_i618.RejectDriverOfferUseCase>(),
      ),
    );
    gh.factory<_i641.ResetPasswordViewModel>(
      () => _i641.ResetPasswordViewModel(gh<_i184.ResetPasswordUseCase>()),
    );
    gh.factory<_i855.CompletedOrdersViewModel>(
      () => _i855.CompletedOrdersViewModel(
        gh<_i763.GetCompletedOrdersUseCase>(),
        gh<_i663.GetCompletedOrderDetailsUseCase>(),
      ),
    );
    gh.factory<_i340.RegisterRegionsCubit>(
      () => _i340.RegisterRegionsCubit(gh<_i985.GetDriverRegionsUseCase>()),
    );
    gh.factory<_i191.DriverVerifyOtpViewModel>(
      () => _i191.DriverVerifyOtpViewModel(
        gh<_i371.VerifyDriverOtpUseCase>(),
        gh<_i324.ResendDriverOtpUseCase>(),
      ),
    );
    gh.factory<_i808.LoginViewModel>(
      () => _i808.LoginViewModel(gh<_i817.LoginUseCase>()),
    );
    gh.factory<_i735.ProfileCubit>(
      () => _i735.ProfileCubit(
        gh<_i339.GetDriverUnifiedProfileUseCase>(),
        gh<_i78.LogoutUseCase>(),
        gh<_i1047.UpdateDriverPersonalUseCase>(),
        gh<_i458.UpdateDriverVehicleUseCase>(),
        gh<_i373.UpdateDriverDocumentsUseCase>(),
        gh<_i1047.UpdateDriverProfilePhotoUseCase>(),
        gh<_i1047.DeleteDriverProfilePhotoUseCase>(),
        gh<_i985.GetDriverRegionsUseCase>(),
        gh<_i183.ImagePicker>(),
      ),
    );
    return this;
  }
}

class _$ExternalModules extends _i576.ExternalModules {}
