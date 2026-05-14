import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/core/widgets/custom_app_bar.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_home_order_preview_mapper.dart';
import 'package:zadana_delivery/features/order_details/domain/entities/order_assignment_details_entity.dart';
import 'package:zadana_delivery/features/order_details/domain/usecase/get_order_assignment_details_usecase.dart';
import 'package:zadana_delivery/features/order_details/presentation/screens/order_details_screen.dart';

class AssignmentDetailEntryScreen extends StatefulWidget {
  const AssignmentDetailEntryScreen({super.key, required this.assignmentId});

  final String assignmentId;

  @override
  State<AssignmentDetailEntryScreen> createState() =>
      _AssignmentDetailEntryScreenState();
}

class _AssignmentDetailEntryScreenState extends State<AssignmentDetailEntryScreen> {
  late Future<OrderAssignmentDetailsEntity?> _loadFuture;

  @override
  void initState() {
    super.initState();
    _loadFuture = _loadAssignment();
  }

  Future<OrderAssignmentDetailsEntity?> _loadAssignment() async {
    final result = await getIt<GetOrderAssignmentDetailsUseCase>().call(
      widget.assignmentId,
    );
    switch (result) {
      case ApiSuccessResult<OrderAssignmentDetailsEntity>():
        return result.data;
      case ApiErrorResult<OrderAssignmentDetailsEntity>():
        return null;
    }
  }

  bool _startAcceptedFromDetails(OrderAssignmentDetailsEntity details) {
    final assignmentStatus = details.assignmentStatus.trim().toLowerCase();
    final normalizedStatus = assignmentStatus.replaceAll(
      RegExp(r'[^a-z0-9]'),
      '',
    );
    final allowedActions = details.allowedActions
        .map((action) => action.trim().toLowerCase())
        .toSet();

    final hasPendingOfferDecision =
        allowedActions.contains('accept_offer') ||
        allowedActions.contains('reject_offer') ||
        normalizedStatus == 'offersent' ||
        assignmentStatus.contains('offer_sent');
    if (hasPendingOfferDecision) {
      return false;
    }

    return allowedActions.contains('arrived_at_vendor') ||
        allowedActions.contains('mark_picked_up') ||
        allowedActions.contains('verify_pickup_otp') ||
        allowedActions.contains('mark_on_the_way') ||
        allowedActions.contains('arrived_at_customer') ||
        allowedActions.contains('verify_delivery_otp') ||
        allowedActions.contains('confirm_delivery') ||
        normalizedStatus == 'accepted' ||
        normalizedStatus == 'driverassigned' ||
        normalizedStatus == 'preparing' ||
        normalizedStatus == 'arrivedatvendor' ||
        normalizedStatus == 'pickedup' ||
        normalizedStatus == 'ontheway' ||
        normalizedStatus == 'arrivedatcustomer' ||
        details.pickupOtpRequired ||
        details.deliveryOtpRequired;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<OrderAssignmentDetailsEntity?>(
      future: _loadFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData && snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            appBar: CustomAppBar.modern(
              title: 'Assignment details',
              onBackPressed: () => Navigator.of(context).maybePop(),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final details = snapshot.data;
        if (details == null) {
          return Scaffold(
            appBar: CustomAppBar.modern(
              title: 'Assignment details',
              onBackPressed: () => Navigator.of(context).maybePop(),
            ),
            body: Center(
              child: FilledButton(
                onPressed: () {
                  setState(() {
                    _loadFuture = _loadAssignment();
                  });
                },
                child: const Text('Retry loading assignment'),
              ),
            ),
          );
        }

        final orderPreview = DriverHomeOrderPreviewMapper.fromAssignmentDetails(
          details,
        );

        return OrderDetailsScreen(
          order: orderPreview,
          driverLocation: LatLng(
            details.pickupLatitude,
            details.pickupLongitude,
          ),
          startAccepted: _startAcceptedFromDetails(details),
        );
      },
    );
  }
}
