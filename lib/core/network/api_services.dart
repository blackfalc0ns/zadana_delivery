import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:zadana_delivery/core/models/file_upload_response_dto.dart';
import 'package:zadana_delivery/core/network/network_constants.dart';

part 'api_services.g.dart';

@RestApi()
@injectable
abstract class ApiServices {
  @factoryMethod
  factory ApiServices(Dio dio) = _ApiServices;

  @MultiPart()
  @POST(EndPoints.fileUpload)
  Future<FileUploadResponseDto> uploadFile(
    @Part(name: 'file') MultipartFile file,
  );

  @POST(EndPoints.driverRegister)
  Future<dynamic> registerDriver(@Body() Map<String, dynamic> request);

  @POST(EndPoints.driverLogin)
  Future<dynamic> loginDriver(@Body() Map<String, dynamic> request);

  @POST(EndPoints.driverForgotPassword)
  Future<dynamic> forgotDriverPassword(@Body() Map<String, dynamic> request);

  @POST(EndPoints.driverResetPassword)
  Future<dynamic> resetDriverPassword(@Body() Map<String, dynamic> request);

  @POST(EndPoints.driverRefreshToken)
  Future<dynamic> refreshDriverToken(@Body() Map<String, dynamic> request);

  @POST(EndPoints.driverLogout)
  Future<dynamic> logoutDriver(@Body() Map<String, dynamic> request);

  @GET(EndPoints.driverProfile)
  Future<dynamic> getDriverProfile();

  @GET(EndPoints.driverStatus)
  Future<dynamic> getDriverStatus();

  @GET(EndPoints.driverZones)
  Future<dynamic> getDriverZones();

  @PUT(EndPoints.driverProfile)
  Future<dynamic> updateDriverProfile(@Body() Map<String, dynamic> request);
}
