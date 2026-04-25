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
import '../../features/auth/register/presentation/manager/register_view_model.dart'
    as _i136;
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
import '../../features/auth/session/domain/usecase/logout_usecase.dart'
    as _i754;
import '../../features/auth/session/domain/usecase/refresh_token_usecase.dart'
    as _i771;
import '../../features/auth/session/domain/usecase/update_current_driver_usecase.dart'
    as _i949;
import '../../features/auth/session/presentation/manager/auth_gate_cubit.dart'
    as _i29;
import '../../features/profile/presentation/controllers/personal_info_controller.dart'
    as _i1041;
import '../../features/profile/presentation/controllers/profile_screen_controller.dart'
    as _i721;
import '../../features/profile/presentation/controllers/security_documents_controller.dart'
    as _i804;
import '../../features/profile/presentation/controllers/vehicle_info_controller.dart'
    as _i190;
import '../helpers/permision_service.dart' as _i367;
import '../helpers/shared_pref.dart' as _i42;
import '../network/api_services.dart' as _i804;
import '../network/external_modules.dart' as _i576;
import '../services/auth_refresh_service.dart' as _i820;
import '../services/file_upload_service.dart' as _i102;
import '../services/language_interceptor.dart' as _i32;
import '../services/language_service.dart' as _i819;
import '../services/token_interceptor.dart' as _i1056;
import '../services/token_service.dart' as _i227;

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
    gh.lazySingleton<_i361.Dio>(
      () => externalModules.provideRefreshDio(),
      instanceName: 'refreshDio',
    );
    gh.factory<_i804.SecurityDocumentsController>(
      () => _i804.SecurityDocumentsController(
        gh<_i550.DriverProfileDraftService>(),
        gh<_i183.ImagePicker>(),
      ),
    );
    gh.factory<_i42.SharedPrefHelper>(
      () => _i42.SharedPrefHelper(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i361.Dio>(
      () => externalModules.provideOsmDio(gh<_i528.PrettyDioLogger>()),
      instanceName: 'osmDio',
    );
    gh.factory<_i227.TokenService>(
      () => _i227.TokenService(
        prefs: gh<_i558.FlutterSecureStorage>(),
        sharedPreferences: gh<_i460.SharedPreferences>(),
      ),
    );
    gh.factory<_i1041.PersonalInfoController>(
      () => _i1041.PersonalInfoController(
        gh<_i550.DriverIdentityService>(),
        gh<_i550.DriverProfileDraftService>(),
      ),
    );
    gh.factory<_i819.LanguageService>(
      () => _i819.LanguageService(gh<_i460.SharedPreferences>()),
    );
    gh.factory<_i190.VehicleInfoController>(
      () => _i190.VehicleInfoController(gh<_i550.DriverProfileDraftService>()),
    );
    gh.factory<_i820.AuthRefreshService>(
      () => _i820.AuthRefreshService(
        gh<_i361.Dio>(instanceName: 'refreshDio'),
        gh<_i227.TokenService>(),
      ),
    );
    gh.factory<_i1056.TokenInterceptor>(
      () => _i1056.TokenInterceptor(
        gh<_i227.TokenService>(),
        gh<_i820.AuthRefreshService>(),
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
    gh.factory<_i804.ApiServices>(() => _i804.ApiServices(gh<_i361.Dio>()));
    gh.factory<_i247.ForgotPasswordRemoteDataSource>(
      () => _i925.ForgotPasswordRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i520.LoginRemoteDataSource>(
      () => _i1060.LoginRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i454.ResetPasswordRemoteDataSource>(
      () => _i17.ResetPasswordRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i897.DriverZonesRemoteDataSource>(
      () => _i291.DriverZonesRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i893.DriverAccountStatusRemoteDataSource>(
      () => _i913.DriverAccountStatusRemoteDataSourceImpl(
        gh<_i804.ApiServices>(),
      ),
    );
    gh.factory<_i430.AuthSessionRemoteDataSource>(
      () => _i502.AuthSessionRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.lazySingleton<_i102.FileUploadService>(
      () => externalModules.provideFileUploadService(gh<_i804.ApiServices>()),
    );
    gh.factory<_i899.ForgotPasswordRepository>(
      () => _i573.ForgotPasswordRepositoryImpl(
        gh<_i247.ForgotPasswordRemoteDataSource>(),
      ),
    );
    gh.factory<_i207.RegisterRemoteDataSource>(
      () => _i895.RegisterRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i599.DriverZonesRepository>(
      () => _i772.DriverZonesRepositoryImpl(
        gh<_i897.DriverZonesRemoteDataSource>(),
      ),
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
    gh.factory<_i731.ForgotPasswordUseCase>(
      () => _i731.ForgotPasswordUseCase(gh<_i899.ForgotPasswordRepository>()),
    );
    gh.factory<_i985.GetDriverZonesUseCase>(
      () => _i985.GetDriverZonesUseCase(gh<_i599.DriverZonesRepository>()),
    );
    gh.factory<_i882.AuthSessionRepository>(
      () => _i195.AuthSessionRepositoryImpl(
        gh<_i430.AuthSessionRemoteDataSource>(),
        gh<_i227.TokenService>(),
        gh<_i550.DriverIdentityService>(),
        gh<_i550.DriverProfileDraftService>(),
      ),
    );
    gh.factory<_i300.GetCurrentDriverUseCase>(
      () => _i300.GetCurrentDriverUseCase(gh<_i882.AuthSessionRepository>()),
    );
    gh.factory<_i754.LogoutUseCase>(
      () => _i754.LogoutUseCase(gh<_i882.AuthSessionRepository>()),
    );
    gh.factory<_i771.RefreshTokenUseCase>(
      () => _i771.RefreshTokenUseCase(gh<_i882.AuthSessionRepository>()),
    );
    gh.factory<_i949.UpdateCurrentDriverUseCase>(
      () => _i949.UpdateCurrentDriverUseCase(gh<_i882.AuthSessionRepository>()),
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
    gh.factory<_i251.RegisterRepository>(
      () => _i794.RegisterRepositoryImpl(
        gh<_i207.RegisterRemoteDataSource>(),
        gh<_i227.TokenService>(),
        gh<_i102.FileUploadService>(),
        gh<_i550.DriverIdentityService>(),
        gh<_i550.DriverProfileDraftService>(),
      ),
    );
    gh.factory<_i635.RegisterUseCase>(
      () => _i635.RegisterUseCase(gh<_i251.RegisterRepository>()),
    );
    gh.factory<_i65.ForgotPasswordViewModel>(
      () => _i65.ForgotPasswordViewModel(gh<_i731.ForgotPasswordUseCase>()),
    );
    gh.factory<_i721.ProfileScreenController>(
      () => _i721.ProfileScreenController(
        gh<_i550.DriverIdentityService>(),
        gh<_i754.LogoutUseCase>(),
      ),
    );
    gh.factory<_i136.RegisterViewModel>(
      () => _i136.RegisterViewModel(gh<_i635.RegisterUseCase>()),
    );
    gh.factory<_i340.RegisterZonesCubit>(
      () => _i340.RegisterZonesCubit(gh<_i985.GetDriverZonesUseCase>()),
    );
    gh.factory<_i184.ResetPasswordUseCase>(
      () => _i184.ResetPasswordUseCase(gh<_i985.ResetPasswordRepository>()),
    );
    gh.factory<_i29.AuthGateCubit>(
      () => _i29.AuthGateCubit(
        gh<_i227.TokenService>(),
        gh<_i570.GetDriverAccountStatusUseCase>(),
      ),
    );
    gh.factory<_i817.LoginUseCase>(
      () => _i817.LoginUseCase(gh<_i137.LoginRepository>()),
    );
    gh.factory<_i641.ResetPasswordViewModel>(
      () => _i641.ResetPasswordViewModel(gh<_i184.ResetPasswordUseCase>()),
    );
    gh.factory<_i808.LoginViewModel>(
      () => _i808.LoginViewModel(gh<_i817.LoginUseCase>()),
    );
    return this;
  }
}

class _$ExternalModules extends _i576.ExternalModules {}
