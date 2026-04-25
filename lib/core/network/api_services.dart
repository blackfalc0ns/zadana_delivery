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

  @GET(EndPoints.driverHome)
  Future<dynamic> getDriverHome();

  @GET(EndPoints.driverCompletedOrders)
  Future<dynamic> getDriverCompletedOrders({@Query('status') String? status});

  @GET('${EndPoints.driverCompletedOrders}/{orderId}')
  Future<dynamic> getDriverCompletedOrderDetails(
    @Path('orderId') String orderId,
  );

  @GET(EndPoints.driverUnifiedProfile)
  Future<dynamic> getDriverUnifiedProfile();

  @GET(EndPoints.driverZones)
  Future<dynamic> getDriverZones();

  @PUT(EndPoints.driverProfile)
  Future<dynamic> updateDriverProfile(@Body() Map<String, dynamic> request);

  @PUT(EndPoints.driverProfilePersonal)
  Future<dynamic> updateDriverPersonalProfile(
    @Body() Map<String, dynamic> request,
  );

  @PUT(EndPoints.driverProfileVehicle)
  Future<dynamic> updateDriverVehicleProfile(
    @Body() Map<String, dynamic> request,
  );

  @PUT(EndPoints.driverProfileDocuments)
  Future<dynamic> updateDriverDocumentsProfile(
    @Body() Map<String, dynamic> request,
  );

  @PUT(EndPoints.driverAvailability)
  Future<dynamic> updateDriverAvailability(
    @Body() Map<String, dynamic> request,
  );

  @POST('/drivers/offers/{assignmentId}/accept')
  Future<dynamic> acceptDriverOffer(@Path('assignmentId') String assignmentId);

  @POST('/drivers/offers/{assignmentId}/reject')
  Future<dynamic> rejectDriverOffer(
    @Path('assignmentId') String assignmentId,
    @Body() Map<String, dynamic> request,
  );
}
