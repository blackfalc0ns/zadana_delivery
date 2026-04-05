import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zadana_delivery/config/routing/routing_extensions.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/widgets/custom_app_bar.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/incoming_order_card.dart';

enum _OrderDeliveryStage { pending, accepted, pickedUp, onTheWay, delivered }

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({
    super.key,
    required this.order,
    required this.driverLocation,
  });

  final DriverOrderPreview order;
  final LatLng driverLocation;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late _OrderDeliveryStage _stage;

  @override
  void initState() {
    super.initState();
    _stage = _OrderDeliveryStage.pending;
  }

  LatLng get _storeLocation =>
      LatLng(widget.order.pickupLatitude, widget.order.pickupLongitude);

  LatLng get _customerLocation => LatLng(
    widget.order.deliveryLatitude,
    widget.order.deliveryLongitude,
  );

  String get _paymentMethod =>
      int.tryParse(widget.order.id) != null && int.parse(widget.order.id).isEven
      ? 'فيزا'
      : 'كاش';

  String get _pickupOtp {
    final orderNumber = int.tryParse(widget.order.id) ?? 1234;
    final otp = ((orderNumber * 37) % 9000) + 1000;
    return otp.toString();
  }

  List<DriverOrderItemPreview> get _orderItems {
    if (widget.order.orderItems.isNotEmpty) {
      return widget.order.orderItems;
    }

    return [
      DriverOrderItemPreview(
        name: 'طلب جاهز من ${widget.order.vendorName}',
        quantity: 1,
        note: 'التسليم حسب الفاتورة من المتجر',
      ),
      const DriverOrderItemPreview(name: 'شنطة تغليف', quantity: 1),
    ];
  }

  String get _storePhone => '01012345678';
  String get _customerPhone => '01098765432';

  bool get _showStoreRouteFirst =>
      _stage.index < _OrderDeliveryStage.onTheWay.index;

  Set<Marker> get _markers => {
    Marker(
      markerId: const MarkerId('store'),
      position: _storeLocation,
      infoWindow: InfoWindow(title: widget.order.vendorName),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    ),
    Marker(
      markerId: const MarkerId('customer'),
      position: _customerLocation,
      infoWindow: InfoWindow(title: widget.order.customerName),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    ),
  };

  Future<void> _openRoute({
    required BuildContext context,
    required LatLng destination,
    String? destinationLabel,
  }) async {
    final destinationText = '${destination.latitude},${destination.longitude}';
    final queryText =
        (destinationLabel == null || destinationLabel.trim().isEmpty)
        ? destinationText
        : destinationLabel.trim();

    final candidates = <Uri>[
      Uri.parse('https://www.google.com/maps/search/?api=1&query=$queryText'),
      Uri.parse('geo:0,0?q=$queryText'),
      Uri.parse(
        'https://www.google.com/maps/dir/?api=1'
        '&destination=$queryText'
        '&travelmode=driving',
      ),
      Uri.parse('google.navigation:q=$destinationText&mode=d'),
    ];
    

    for (final uri in candidates) {
      try {
        final launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        if (launched) return;
      } catch (_) {}
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر فتح تطبيق الخرائط على هذا الجهاز')),
      );
    }
  }

  Future<void> _callNumber(BuildContext context, String number) async {
    final uri = Uri(scheme: 'tel', path: number);
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (launched) return;
    } catch (_) {}

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر فتح تطبيق الاتصال على هذا الجهاز')),
      );
    }
  }

  void _updateStage(_OrderDeliveryStage stage) {
    setState(() => _stage = stage);
  }

  Future<void> _showOrderItemsSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return DraggableScrollableSheet(
          initialChildSize: 0.72,
          minChildSize: 0.45,
          maxChildSize: 0.92,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),
                    Center(
                      child: Container(
                        width: 46,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  ' أصناف الطلب',
                                  style: getBoldStyle(
                                    fontFamily: FontConstant.cairo,
                                    fontSize: FontSize.size18,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${_orderItems.length} صنف - ${_orderItems.fold<int>(0, (sum, item) => sum + item.quantity)} قطعة',
                                  style: getRegularStyle(
                                    fontFamily: FontConstant.cairo,
                                    fontSize: FontSize.size12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // IconButton(
                          //   onPressed: () => Navigator.of(sheetContext).pop(),
                          //   icon: const Icon(Icons.close_rounded),
                          // ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          widget.order.packageNote ??
                              'راجع عدد القطع وتأكد إن التغليف مقفول قبل التحرك.',
                          style: getRegularStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size12,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Expanded(
                      child: ListView.separated(
                        controller: scrollController,
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                        itemCount: _orderItems.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final item = _orderItems[index];
                          return _OrderItemTile(item: item);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showPickupOtpSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 46,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'كود استلام الطلب',
                  textAlign: TextAlign.center,
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size18,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'اعرض هذا الكود للمتجر حتى يتم تسليم الطلب لك',
                  textAlign: TextAlign.center,
                  style: getRegularStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Text(
                    _pickupOtp,
                    textAlign: TextAlign.center,
                    style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: 34,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(sheetContext).pop();
                      _updateStage(_OrderDeliveryStage.pickedUp);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Text(
                      'تأكيد الاستلام من المتجر',
                      style: getBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showCustomerOtpSheet(BuildContext context) async {
    var enteredOtp = '';

    final isConfirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 46,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'تأكيد تسليم الطلب',
                      textAlign: TextAlign.center,
                      style: getBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size18,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'خذ رمز التسليم من العميل واكتبه هنا عشان نكمل تسليم الطلب',
                      textAlign: TextAlign.center,
                      style: getRegularStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 4,
                      onChanged: (value) => enteredOtp = value,
                      style: getBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size20,
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: 'اكتب رمز تسليم العميل',
                        filled: true,
                        fillColor: const Color(0xFFF7FAFC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        'في النسخة التجريبية تقدر تكتب أي 4 أرقام للتأكيد',
                        textAlign: TextAlign.center,
                        style: getSemiBoldStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size12,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () {
                          if (enteredOtp.trim().isEmpty) {
                            ScaffoldMessenger.of(sheetContext).showSnackBar(
                              const SnackBar(
                                content: Text('اكتب الرمز عشان نأكد التسليم'),
                              ),
                            );
                            return;
                          }

                          Navigator.of(sheetContext).pop(true);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: Text(
                          'تأكيد التسليم',
                          style: getBoldStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    if (isConfirmed == true && context.mounted) {
      _updateStage(_OrderDeliveryStage.delivered);
      Navigator.of(context).pop('accept');
    }
  }

  Widget _buildBottomActions(BuildContext context) {
    switch (_stage) {
      case _OrderDeliveryStage.pending:
        return Row(
          children: [
            Expanded(
              child: _DecisionButton(
                label: 'قبول الطلب',
                foreground: Colors.white,
                background: AppColors.primary,
                borderColor: AppColors.primary,
                onTap: () => _updateStage(_OrderDeliveryStage.accepted),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _DecisionButton(
                label: 'رفض',
                foreground: AppColors.error,
                background: AppColors.error.withValues(alpha: 0.08),
                borderColor: AppColors.error.withValues(alpha: 0.18),
                onTap: () => Navigator.of(context).pop('reject'),
              ),
            ),
          ],
        );
      case _OrderDeliveryStage.accepted:
        return _DecisionButton(
          label: 'عرض كود الاستلام من المتجر',
          foreground: Colors.white,
          background: AppColors.secondary,
          borderColor: AppColors.secondary,
          onTap: () => _showPickupOtpSheet(context),
        );
      case _OrderDeliveryStage.pickedUp:
        return _DecisionButton(
          label: 'بدء التوصيل للعميل',
          foreground: Colors.white,
          background: AppColors.secondary,
          borderColor: AppColors.secondary,
          onTap: () => _updateStage(_OrderDeliveryStage.onTheWay),
        );
      case _OrderDeliveryStage.onTheWay:
        return _DecisionButton(
          label: 'تأكيد التسليم برمز العميل',
          foreground: Colors.white,
          background: AppColors.success,
          borderColor: AppColors.success,
          onTap: () => _showCustomerOtpSheet(context),
        );
      case _OrderDeliveryStage.delivered:
        return _DecisionButton(
          label: 'تم تسليم الطلب',
          foreground: Colors.white,
          background: AppColors.success,
          borderColor: AppColors.success,
          onTap: () => Navigator.of(context).pop('accept'),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6F9),
      appBar: CustomAppBar.modern(
        title: 'تفاصيل الطلب',
        backgroundColor: const Color(0xFFF2F6F9),
        onBackPressed: () => context.pop(),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 18,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: _buildBottomActions(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
              child: _DeliveryStatusCard(stage: _stage),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 90),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _HeroCard(
                      order: widget.order,
                      paymentMethod: _paymentMethod,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: 'المسافة',
                            value: widget.order.distance,
                            icon: Icons.route_rounded,
                            accent: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _StatCard(
                            title: 'طريقة الدفع',
                            value: _paymentMethod,
                            icon: _paymentMethod == 'كاش'
                                ? Icons.payments_rounded
                                : Icons.credit_card_rounded,
                            accent: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _DetailCard(
                      title: 'تفاصيل الطلب المستلم',
                      accent: AppColors.success,
                      child: _OrderItemsSection(
                        items: _orderItems,
                        onTap: () => _showOrderItemsSheet(context),
                        packageNote:
                            widget.order.packageNote ??
                            'راجع عدد القطع وتأكد إن التغليف مقفول قبل التحرك.',
                      ),
                    ),
                    const SizedBox(height: 10),
                    _DetailCard(
                      title: 'بيانات الاستلام',
                      accent: AppColors.primary,
                      child: Column(
                        children: [
                          _InfoTile(
                            icon: Icons.storefront_rounded,
                            label: 'المتجر',
                            value: widget.order.vendorName,
                            accent: AppColors.primary,
                            action: _CircleCallButton(
                              onTap: () => _callNumber(context, _storePhone),
                            ),
                          ),
                          const SizedBox(height: 8),
                          _InfoTile(
                            icon: Icons.pin_drop_rounded,
                            label: 'عنوان المتجر',
                            value: widget.order.pickupAddress,
                            accent: AppColors.secondary,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    _DetailCard(
                      title: 'بيانات العميل',
                      accent: AppColors.secondary,
                      child: Column(
                        children: [
                          _InfoTile(
                            icon: Icons.person_rounded,
                            label: 'اسم العميل',
                            value: widget.order.customerName,
                            accent: AppColors.primary,
                            action: _CircleCallButton(
                              onTap: () => _callNumber(context, _customerPhone),
                            ),
                          ),
                          const SizedBox(height: 8),
                          _InfoTile(
                            icon: Icons.home_rounded,
                            label: 'عنوان العميل',
                            value: widget.order.deliveryAddress,
                            accent: AppColors.secondary,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    _MapCard(
                      markers: _markers,
                      target: _showStoreRouteFirst
                          ? _storeLocation
                          : _customerLocation,
                    ),
                    const SizedBox(height: 12),
                    _RouteActionButton(
                      label: 'افتح موقع العميل',
                      hint: 'يفتح لك موقع العميل في تطبيق الخرائط',
                      icon: Icons.navigation_rounded,
                      background: _showStoreRouteFirst
                          ? Colors.white
                          : AppColors.primary,
                      foreground: _showStoreRouteFirst
                          ? AppColors.primary
                          : Colors.white,
                      borderColor: _showStoreRouteFirst
                          ? AppColors.primary.withValues(alpha: 0.18)
                          : null,
                      onTap: () => _openRoute(
                        context: context,
                        destination: _customerLocation,
                        destinationLabel: widget.order.deliveryAddress,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _RouteActionButton(
                      label: 'افتح موقع المتجر',
                      hint: 'يفتح لك موقع المتجر على الخريطة',
                      icon: Icons.store_mall_directory_rounded,
                      background: _showStoreRouteFirst
                          ? AppColors.secondary
                          : Colors.white,
                      foreground: _showStoreRouteFirst
                          ? Colors.white
                          : AppColors.secondary,
                      borderColor: _showStoreRouteFirst
                          ? null
                          : AppColors.secondary.withValues(alpha: 0.18),
                      onTap: () => _openRoute(
                        context: context,
                        destination: _storeLocation,
                        destinationLabel: widget.order.pickupAddress,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeliveryStatusCard extends StatelessWidget {
  const _DeliveryStatusCard({required this.stage});

  final _OrderDeliveryStage stage;

  @override
  Widget build(BuildContext context) {
    const steps = [
      ('تم قبول الطلب', Icons.check_circle_rounded),
      ('تم الاستلام من المتجر', Icons.storefront_rounded),
      ('في الطريق للعميل', Icons.delivery_dining_rounded),
      ('تم التسليم', Icons.home_rounded),
    ];

    final activeIndex = switch (stage) {
      _OrderDeliveryStage.pending => -1,
      _OrderDeliveryStage.accepted => 0,
      _OrderDeliveryStage.pickedUp => 1,
      _OrderDeliveryStage.onTheWay => 2,
      _OrderDeliveryStage.delivered => 3,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 78,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(steps.length * 2 - 1, (index) {
                if (index.isOdd) {
                  final connectorStep = index ~/ 2;
                  final isComplete = activeIndex > connectorStep;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 18),
                      child: Container(
                        height: 3,
                        decoration: BoxDecoration(
                          color: isComplete
                              ? AppColors.secondary
                              : AppColors.lightGrey,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  );
                }

                final stepIndex = index ~/ 2;
                final step = steps[stepIndex];
                final isDone = stepIndex <= activeIndex;
                final isCurrent = stepIndex == activeIndex;
                final stepColor = isCurrent
                    ? AppColors.secondary
                    : isDone
                    ? AppColors.secondary
                    : AppColors.lightGrey;

                return SizedBox(
                  width: 64,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isDone ? stepColor : const Color(0xFFF4F7FA),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDone
                                ? Colors.transparent
                                : AppColors.lightGrey,
                          ),
                        ),
                        child: Icon(
                          step.$2,
                          color: isDone
                              ? Colors.white
                              : AppColors.textSecondary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        step.$1,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: getSemiBoldStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size11,
                          color: isDone
                              ? AppColors.secondary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.order, required this.paymentMethod});

  final DriverOrderPreview order;
  final String paymentMethod;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0A7B8F), Color(0xFF149AB0)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.24),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.title,
                      style: getBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size18,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      order.vendorName,
                      style: getRegularStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size12,
                        color: Colors.white.withValues(alpha: 0.82),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.24),
                  ),
                ),
                child: Text(
                  order.payout,
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size13,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Icon(
                  paymentMethod == 'كاش'
                      ? Icons.payments_rounded
                      : Icons.credit_card_rounded,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Text(
                  'طريقة الدفع: ',
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size13,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.accent,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: accent),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: getRegularStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size11,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size14,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({
    required this.title,
    required this.accent,
    required this.child,
  });

  final String title;
  final Color accent;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.045),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: accent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size15,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
    this.action,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color accent;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        color: const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: accent, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: getRegularStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size11,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size13,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          if (action != null) ...[const SizedBox(width: 8), action!],
        ],
      ),
    );
  }
}

class _OrderItemsSection extends StatelessWidget {
  const _OrderItemsSection({
    required this.items,
    required this.packageNote,
    required this.onTap,
  });

  final List<DriverOrderItemPreview> items;
  final String packageNote;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final totalQuantity = items.fold<int>(
      0,
      (sum, item) => sum + item.quantity,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF7FAFC),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.inventory_2_rounded,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'عدد الأصناف: ${items.length}',
                            style: getBoldStyle(
                              fontFamily: FontConstant.cairo,
                              fontSize: FontSize.size13,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'عرض المنتجات',
                              style: getBoldStyle(
                                fontFamily: FontConstant.cairo,
                                fontSize: FontSize.size11,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 6),

                            const Icon(
                              Icons.keyboard_arrow_left_rounded,
                              color: AppColors.primary,
                              size: 16,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'إجمالي القطع: $totalQuantity',
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size11,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderItemTile extends StatelessWidget {
  const _OrderItemTile({required this.item});

  final DriverOrderItemPreview item;

  String get _emoji {
    final name = item.name;

    if (name.contains('طماطم')) return '🍅';
    if (name.contains('خيار')) return '🥒';
    if (name.contains('بطاطس')) return '🥔';
    if (name.contains('بصل')) return '🧅';
    if (name.contains('ثوم')) return '🧄';
    if (name.contains('جزر')) return '🥕';
    if (name.contains('فلفل')) return '🌶️';
    if (name.contains('باذنجان')) return '🍆';
    if (name.contains('كوسة')) return '🥬';
    if (name.contains('خس')) return '🥬';
    if (name.contains('جرجير')) return '🥗';
    if (name.contains('ملوخية')) return '🥬';
    if (name.contains('سبانخ')) return '🥬';
    if (name.contains('كزبرة')) return '🌿';
    if (name.contains('نعناع')) return '🌿';
    if (name.contains('ليمون')) return '🍋';
    if (name.contains('تفاح')) return '🍎';
    if (name.contains('موز')) return '🍌';
    return '🥦';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(_emoji, style: const TextStyle(fontSize: 21)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: getBoldStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size13,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'الكمية: ${item.quantity}',
                        style: getBoldStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size10,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                if ((item.note ?? '').trim().isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    item.note!,
                    style: getRegularStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleCallButton extends StatelessWidget {
  const _CircleCallButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary.withValues(alpha: 0.10),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: const SizedBox(
          width: 42,
          height: 42,
          child: Icon(Icons.call_rounded, color: AppColors.primary, size: 20),
        ),
      ),
    );
  }
}

class _DecisionButton extends StatelessWidget {
  const _DecisionButton({
    required this.label,
    required this.foreground,
    required this.background,
    required this.borderColor,
    required this.onTap,
  });

  final String label;
  final Color foreground;
  final Color background;
  final Color borderColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          height: 54,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor),
          ),
          child: Center(
            child: Text(
              label,
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size14,
                color: foreground,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MapCard extends StatelessWidget {
  const _MapCard({required this.markers, required this.target});

  final Set<Marker> markers;
  final LatLng target;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.map_rounded,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'خريطة المسار',
                    style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size15,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              SizedBox(
                height: 280,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: target,
                    zoom: 12.5,
                  ),
                  markers: markers,
                  gestureRecognizers: {
                    Factory<OneSequenceGestureRecognizer>(
                      () => EagerGestureRecognizer(),
                    ),
                  },
                  zoomGesturesEnabled: true,
                  scrollGesturesEnabled: true,
                  rotateGesturesEnabled: true,
                  tiltGesturesEnabled: true,
                  compassEnabled: true,
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                  mapToolbarEnabled: false,
                ),
              ),
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.94),
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    'اسحب وكبر الخريطة',
                    style: getSemiBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size10,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
class _RouteActionButton extends StatelessWidget {
  const _RouteActionButton({
    required this.label,
    required this.hint,
    required this.icon,
    required this.background,
    required this.foreground,
    required this.onTap,
    this.borderColor,
  });

  final String label;
  final String hint;
  final IconData icon;
  final Color background;
  final Color foreground;
  final Color? borderColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(22),
            border: borderColor != null
                ? Border.all(color: borderColor!)
                : null,
            boxShadow: foreground == Colors.white
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.22),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: foreground == Colors.white
                      ? Colors.white.withValues(alpha: 0.16)
                      : AppColors.secondary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: foreground),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: getBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size14,
                        color: foreground,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      hint,
                      style: getRegularStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size11,
                        color: foreground.withValues(alpha: 0.82),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_rounded, color: foreground),
            ],
          ),
        ),
      ),
    );
  }
}





