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
    @Part(name: 'directory') String directory,
    @Part(name: 'file') MultipartFile file,
  );

  @POST(EndPoints.driverRegister)
  Future<dynamic> registerDriver(@Body() Map<String, dynamic> request);

  @POST(EndPoints.driverLogin)
  Future<dynamic> loginDriver(@Body() Map<String, dynamic> request);

  @POST(EndPoints.driverVerifyOtp)
  Future<dynamic> verifyDriverOtp(@Body() Map<String, dynamic> request);

  @POST(EndPoints.driverResendOtp)
  Future<dynamic> resendDriverOtp(@Body() Map<String, dynamic> request);

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

  @PUT(EndPoints.driverProfilePhoto)
  Future<dynamic> updateDriverProfilePhoto(@Body() Map<String, dynamic> request);

  @DELETE(EndPoints.driverProfilePhoto)
  Future<dynamic> deleteDriverProfilePhoto();

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

  @GET(EndPoints.driverAssignmentDetails)
  Future<dynamic> getDriverAssignmentDetails(
    @Path('assignmentId') String assignmentId,
  );

  @GET(EndPoints.driverCurrentAssignment)
  Future<dynamic> getCurrentDriverAssignment();

  @GET(EndPoints.driverNotifications)
  Future<dynamic> getDriverNotifications({
    @Query('page') int page = 1,
    @Query('per_page') int perPage = 20,
  });

  @POST(EndPoints.driverNotificationRead)
  Future<dynamic> markDriverNotificationAsRead(
    @Path('notificationId') String notificationId,
  );

  @POST(EndPoints.driverNotificationsReadAll)
  Future<dynamic> markAllDriverNotificationsAsRead();

  @GET(EndPoints.driverNotificationsUnreadCount)
  Future<dynamic> getDriverNotificationsUnreadCount();

  @GET(EndPoints.driverWallet)
  Future<dynamic> getDriverWalletSummary();

  @GET(EndPoints.driverWalletTransactions)
  Future<dynamic> getDriverWalletTransactions({
    @Query('page') int page = 1,
    @Query('pageSize') int pageSize = 20,
  });

  @GET(EndPoints.driverWalletPaymentMethods)
  Future<dynamic> getDriverWalletPaymentMethods();

  @POST(EndPoints.driverWalletPaymentMethods)
  Future<dynamic> createDriverWalletPaymentMethod(
    @Body() Map<String, dynamic> request,
  );

  @PUT('${EndPoints.driverWalletPaymentMethods}/{id}')
  Future<dynamic> updateDriverWalletPaymentMethod(
    @Path('id') String id,
    @Body() Map<String, dynamic> request,
  );

  @DELETE('${EndPoints.driverWalletPaymentMethods}/{id}')
  Future<dynamic> deleteDriverWalletPaymentMethod(@Path('id') String id);

  @POST(EndPoints.driverWalletPaymentMethodPrimary)
  Future<dynamic> makeDriverWalletPaymentMethodPrimary(@Path('id') String id);

  @POST(EndPoints.driverWalletWithdrawals)
  Future<dynamic> createDriverWalletWithdrawal(
    @Body() Map<String, dynamic> request,
  );

  @GET(EndPoints.driverWalletWithdrawals)
  Future<dynamic> getDriverWalletWithdrawals({
    @Query('page') int page = 1,
    @Query('pageSize') int pageSize = 20,
  });

  @GET(EndPoints.driverSupportCases)
  Future<dynamic> getDriverSupportCases({
    @Query('page') int page = 1,
    @Query('pageSize') int pageSize = 20,
  });

  @GET(EndPoints.driverSupportCaseDetails)
  Future<dynamic> getDriverSupportCaseDetails(@Path('caseId') String caseId);

  @GET(EndPoints.driverSupportReasons)
  Future<dynamic> getDriverSupportReasons(@Path('type') String type);

  @POST(EndPoints.driverOrderReportIssue)
  Future<dynamic> reportDriverOrderIssue(
    @Path('orderId') String orderId,
    @Body() Map<String, dynamic> request,
  );

  @POST(EndPoints.driverOrderDispute)
  Future<dynamic> createDriverOrderDispute(
    @Path('orderId') String orderId,
    @Body() Map<String, dynamic> request,
  );

  @POST(EndPoints.driverSupportCaseMessages)
  Future<dynamic> sendDriverSupportCaseMessage(
    @Path('orderId') String orderId,
    @Path('caseId') String caseId,
    @Body() Map<String, dynamic> request,
  );

  @GET(EndPoints.driverUnifiedProfile)
  Future<dynamic> getDriverUnifiedProfile();

  @GET(EndPoints.driverZones)
  Future<dynamic> getDriverZones();

  @GET(EndPoints.driverZoneCities)
  Future<dynamic> getDriverZoneCities(@Path('regionCode') String regionCode);

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

  @POST(EndPoints.driverLocation)
  Future<dynamic> updateDriverLocation(@Body() Map<String, dynamic> request);

  @POST(EndPoints.driverAssignmentStatus)
  Future<dynamic> updateDriverAssignmentStatus(
    @Path('assignmentId') String assignmentId,
    @Body() Map<String, dynamic> request,
  );

  @POST(EndPoints.driverAssignmentVerifyOtp)
  Future<dynamic> verifyDriverAssignmentOtp(
    @Path('assignmentId') String assignmentId,
    @Body() Map<String, dynamic> request,
  );

  @POST(EndPoints.driverAssignmentResendOtp)
  Future<dynamic> resendDriverAssignmentOtp(
    @Path('assignmentId') String assignmentId,
    @Body() Map<String, dynamic> request,
  );

  @POST(EndPoints.driverOrderArrivedAtVendor)
  Future<dynamic> markOrderArrivedAtVendor(@Path('orderId') String orderId);

  @POST(EndPoints.driverOrderArrivedAtCustomer)
  Future<dynamic> markOrderArrivedAtCustomer(@Path('orderId') String orderId);

  @POST('/drivers/offers/{assignmentId}/accept')
  Future<dynamic> acceptDriverOffer(@Path('assignmentId') String assignmentId);

  @POST('/drivers/offers/{assignmentId}/reject')
  Future<dynamic> rejectDriverOffer(
    @Path('assignmentId') String assignmentId,
    @Body() Map<String, dynamic> request,
  );

  @POST(EndPoints.driverOrderPickedUp)
  Future<dynamic> markOrderPickedUp(@Path('orderId') String orderId);

  @POST(EndPoints.driverOrderOnTheWay)
  Future<dynamic> markOrderOnTheWay(@Path('orderId') String orderId);

  @POST(EndPoints.driverOrderDelivered)
  Future<dynamic> markOrderDelivered(
    @Path('orderId') String orderId,
    @Body() Map<String, dynamic> request,
  );

  @POST(EndPoints.driverOrderDeliveryFailed)
  Future<dynamic> markOrderDeliveryFailed(
    @Path('orderId') String orderId,
    @Body() Map<String, dynamic> request,
  );
}
