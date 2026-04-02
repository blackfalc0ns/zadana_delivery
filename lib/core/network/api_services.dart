import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:zadana_delivery/core/network/network_constants.dart';

part 'api_services.g.dart';

@RestApi()
@injectable
abstract class ApiServices {
  @factoryMethod
  factory ApiServices(Dio dio) = _ApiServices;

  @POST(EndPoints.driverRegister)
  Future<dynamic> registerDriver(@Body() Map<String, dynamic> request);

  @POST(EndPoints.driverLogin)
  Future<dynamic> loginDriver(@Body() Map<String, dynamic> request);

  @POST(EndPoints.driverForgotPassword)
  Future<dynamic> forgotDriverPassword(@Body() Map<String, dynamic> request);

  @POST(EndPoints.driverResetPassword)
  Future<dynamic> resetDriverPassword(@Body() Map<String, dynamic> request);

  @POST(EndPoints.driverLogout)
  Future<dynamic> logoutDriver(@Body() Map<String, dynamic> request);

  @GET(EndPoints.driverProfile)
  Future<dynamic> getDriverProfile();
}
