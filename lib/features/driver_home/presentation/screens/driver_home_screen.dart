import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/config/routing/routing_extensions.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/helpers/permision_service.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/incoming_order_card.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(30.0444, 31.2357),
    zoom: 11.8,
  );

  static const LatLng _mockDriverLocation = LatLng(30.0742, 31.2920);

  bool _isOnline = true;
  bool _isMyLocationEnabled = false;
  final Map<String, BitmapDescriptor> _pickupMarkerIcons = {};
  BitmapDescriptor? _driverMarkerIcon;
  final _locationPermissionService = LocationPermissionService();

  late List<DriverOrderPreview> _orders;

  @override
  void initState() {
    super.initState();
    _orders = const [
      DriverOrderPreview(
        id: '1234',
        title: 'طلب #1234',
        vendorName:
            'سلة جرين ماركت',
        pickupAddress:
            '12 طريق الملك فيصل، مدينة نصر',
        pickupLatitude: 30.0724,
        pickupLongitude: 31.2872,
        customerName: 'منى عادل',
        deliveryAddress:
            '32 شارع عباس العقاد، مدينة نصر',
        deliveryLatitude: 30.0609,
        deliveryLongitude: 31.3124,
        distance: '3.2 كم',
        eta: '15 دقيقة',
        payout: '85 ريال',
        vendorInitials: 'جس',
        customerInitials: 'مع',
        packageNote: 'خضار طازة، خليك حريص في النقل وما تحطش الطلب تحت أي وزن.',
        orderItems: [
          DriverOrderItemPreview(name: 'طماطم', quantity: 3),
          DriverOrderItemPreview(name: 'خيار', quantity: 2),
          DriverOrderItemPreview(name: 'بطاطس', quantity: 2),
          DriverOrderItemPreview(name: 'فلفل ألوان', quantity: 1),
        ],
        countdownSeconds: 60,
      ),
      DriverOrderPreview(
        id: '1235',
        title: 'طلب #1235',
        vendorName:
            'أسواق الدانة',
        pickupAddress:
            'شارع التخصصي، الرياض',
        pickupLatitude: 30.0219,
        pickupLongitude: 31.2105,
        customerName: 'ناصر',
        deliveryAddress:
            'حي الياسمين، الرياض',
        deliveryLatitude: 30.0398,
        deliveryLongitude: 31.2336,
        distance: '4.1 كم',
        eta: '18 دقيقة',
        payout: '92 ريال',
        vendorInitials: 'أد',
        customerInitials: 'ن',
        packageNote: 'خضروات يومية، تأكد من عدد الأكياس قبل الخروج.',
        orderItems: [
          DriverOrderItemPreview(name: 'خيار', quantity: 4),
          DriverOrderItemPreview(name: 'طماطم', quantity: 5),
          DriverOrderItemPreview(name: 'جزر', quantity: 2),
          DriverOrderItemPreview(name: 'كوسة', quantity: 3),
        ],
        countdownSeconds: 75,
      ),
      DriverOrderPreview(
        id: '1236',
        title: 'طلب #1236',
        vendorName:
            'مخبز السراة',
        pickupAddress:
            'حي الندى، الرياض',
        pickupLatitude: 30.1236,
        pickupLongitude: 31.3314,
        customerName: 'سعد',
        deliveryAddress:
            'حي النرجس، الرياض',
        deliveryLatitude: 30.1094,
        deliveryLongitude: 31.3482,
        distance: '2.8 كم',
        eta: '12 دقيقة',
        payout: '64 ريال',
        vendorInitials: 'مس',
        customerInitials: 'س',
        packageNote: 'خضار للطبخ، حافظ على الأكياس مرتبة.',
        orderItems: [
          DriverOrderItemPreview(name: 'بطاطس', quantity: 4),
          DriverOrderItemPreview(name: 'بصل', quantity: 3),
          DriverOrderItemPreview(name: 'ثوم', quantity: 2),
        ],
        countdownSeconds: 90,
      ),
      DriverOrderPreview(
        id: '1237',
        title: 'طلب #1237',
        vendorName: 'كافيه بين',
        pickupAddress:
            'شارع الطيران، مصر الجديدة',
        pickupLatitude: 30.0912,
        pickupLongitude: 31.3174,
        customerName: 'أحمد',
        deliveryAddress:
            'شارع النزهة، مصر الجديدة',
        deliveryLatitude: 30.0986,
        deliveryLongitude: 31.3328,
        distance: '3.6 كم',
        eta: '14 دقيقة',
        payout: '78 ريال',
        vendorInitials: 'كب',
        customerInitials: 'أ',
        packageNote: 'خضروات مختارة، حافظ على الطلب ثابت أثناء التوصيل.',
        orderItems: [
          DriverOrderItemPreview(name: 'فلفل أخضر', quantity: 3),
          DriverOrderItemPreview(name: 'باذنجان', quantity: 2),
          DriverOrderItemPreview(name: 'كوسة', quantity: 2),
        ],
        countdownSeconds: 80,
      ),
      DriverOrderPreview(
        id: '1238',
        title: 'طلب #1238',
        vendorName:
            'صيدلية الشفاء',
        pickupAddress:
            'شارع جابر بن حيان، الدقي',
        pickupLatitude: 30.0508,
        pickupLongitude: 31.2001,
        customerName: 'ليلى',
        deliveryAddress:
            'شارع البطاويني، الدقي',
        deliveryLatitude: 30.0427,
        deliveryLongitude: 31.2096,
        distance: '2.1 كم',
        eta: '10 دقيقة',
        payout: '56 ريال',
        vendorInitials: 'صش',
        customerInitials: 'ل',
        packageNote: 'طلب خضار خفيف، راجع الأصناف بعناية قبل الاستلام.',
        orderItems: [
          DriverOrderItemPreview(name: 'ليمون', quantity: 2),
          DriverOrderItemPreview(name: 'نعناع', quantity: 3),
          DriverOrderItemPreview(name: 'خيار', quantity: 2),
        ],
        countdownSeconds: 70,
      ),
      DriverOrderPreview(
        id: '1239',
        title: 'طلب #1239',
        vendorName:
            'سوبر ماركت الخير',
        pickupAddress:
            'شارع الجيش، شبرا',
        pickupLatitude: 30.0874,
        pickupLongitude: 31.2468,
        customerName: 'خالد',
        deliveryAddress:
            'شارع روض الفرج، شبرا',
        deliveryLatitude: 30.1018,
        deliveryLongitude: 31.2511,
        distance: '5.4 كم',
        eta: '21 دقيقة',
        payout: '108 ريال',
        vendorInitials: 'سخ',
        customerInitials: 'خ',
        packageNote: 'طلب خضار عائلي كبير، تأكد من كل الأكياس والفاتورة.',
        orderItems: [
          DriverOrderItemPreview(name: 'طماطم', quantity: 4),
          DriverOrderItemPreview(name: 'خيار', quantity: 3),
          DriverOrderItemPreview(name: 'بطاطس', quantity: 5),
          DriverOrderItemPreview(name: 'بصل', quantity: 3),
          DriverOrderItemPreview(name: 'جزر', quantity: 2),
        ],
        countdownSeconds: 95,
      ),
      DriverOrderPreview(
        id: '1240',
        title: 'طلب #1240',
        vendorName: 'مطعم زعتر',
        pickupAddress:
            'شارع المكرم عبيد، مدينة نصر',
        pickupLatitude: 30.0615,
        pickupLongitude: 31.3365,
        customerName: 'رانيا',
        deliveryAddress:
            'حي السابع، مدينة نصر',
        deliveryLatitude: 30.0568,
        deliveryLongitude: 31.3492,
        distance: '3.9 كم',
        eta: '16 دقيقة',
        payout: '88 ريال',
        vendorInitials: 'مز',
        customerInitials: 'ر',
        packageNote: 'خضروات طازة، حاول توصل بسرعة للحفاظ على الجودة.',
        orderItems: [
          DriverOrderItemPreview(name: 'خس', quantity: 1),
          DriverOrderItemPreview(name: 'جرجير', quantity: 2),
          DriverOrderItemPreview(name: 'طماطم شيري', quantity: 2),
        ],
        countdownSeconds: 85,
      ),
      DriverOrderPreview(
        id: '1241',
        title: 'طلب #1241',
        vendorName:
            'ملحمة المها',
        pickupAddress:
            'شارع تسعين، التجمع',
        pickupLatitude: 30.0087,
        pickupLongitude: 31.4321,
        customerName: 'عمر',
        deliveryAddress:
            'اللوتس الجنوبي، التجمع',
        deliveryLatitude: 30.0162,
        deliveryLongitude: 31.4465,
        distance: '6.2 كم',
        eta: '24 دقيقة',
        payout: '124 ريال',
        vendorInitials: 'مه',
        customerInitials: 'ع',
        packageNote: 'خضار مطبخ، يفضل تسليمها مباشرة بدون تأخير.',
        orderItems: [
          DriverOrderItemPreview(name: 'ملوخية', quantity: 2),
          DriverOrderItemPreview(name: 'سبانخ', quantity: 2),
          DriverOrderItemPreview(name: 'كزبرة', quantity: 3),
        ],
        countdownSeconds: 100,
      ),
      DriverOrderPreview(
        id: '1242',
        title: 'طلب #1242',
        vendorName:
            'مخبوزات الدار',
        pickupAddress:
            'شارع 9، المعادي',
        pickupLatitude: 29.9618,
        pickupLongitude: 31.2575,
        customerName: 'نور',
        deliveryAddress:
            'زهراء المعادي',
        deliveryLatitude: 29.9736,
        deliveryLongitude: 31.2749,
        distance: '4.7 كم',
        eta: '19 دقيقة',
        payout: '90 ريال',
        vendorInitials: 'مد',
        customerInitials: 'ن',
        packageNote: 'خضروات وفاكهة خفيفة، خليك حريص على شكل الأكياس.',
        orderItems: [
          DriverOrderItemPreview(name: 'تفاح', quantity: 4),
          DriverOrderItemPreview(name: 'موز', quantity: 3),
          DriverOrderItemPreview(name: 'خيار', quantity: 2),
        ],
        countdownSeconds: 88,
      ),
    ];
    _loadMarkers();
    _loadDriverMarker();
    _enableMyLocation();
  }

  Future<void> _loadDriverMarker() async {
    final icon = await _buildDriverMarker();
    if (!mounted) return;
    setState(() => _driverMarkerIcon = icon);
  }

  Future<void> _enableMyLocation() async {
    try {
      await _locationPermissionService.checkAndRequestPermission();
      if (!mounted) return;
      setState(() => _isMyLocationEnabled = true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isMyLocationEnabled = false);
    }
  }

  Future<void> _loadMarkers() async {
    if (_orders.isEmpty) {
      if (!mounted) return;
      setState(_pickupMarkerIcons.clear);
      return;
    }

    final icons = <String, BitmapDescriptor>{};
    for (final order in _orders) {
      icons[order.id] = await _buildPickupMarker(marketName: order.vendorName);
    }

    if (!mounted) return;
    setState(() {
      _pickupMarkerIcons
        ..clear()
        ..addAll(icons);
    });
  }

  void _removeOrder(String id) {
    setState(() {
      _orders = _orders.where((order) => order.id != id).toList();
      _pickupMarkerIcons.remove(id);
    });
  }

  Future<void> _openOrderDetails(DriverOrderPreview order) async {
    final result = await context.pushNamed(
      AppRoutes.orderDetails,
      arguments: {'order': order, 'driverLocation': _mockDriverLocation},
    );

    if (!mounted || result is! String) return;

    if (result == 'accept' || result == 'reject') {
      _removeOrder(order.id);
    }
  }

  Set<Marker> get _markers => {
    Marker(
      markerId: const MarkerId('driver_location'),
      position: _mockDriverLocation,
      icon:
          _driverMarkerIcon ??
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      infoWindow: const InfoWindow(
        title:
            'موقعي الحالي',
      ),
    ),
    ..._orders.map(
      (order) => Marker(
        markerId: MarkerId('pickup_${order.id}'),
        position: LatLng(order.pickupLatitude, order.pickupLongitude),
        icon:
            _pickupMarkerIcons[order.id] ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: InfoWindow(title: order.vendorName),
      ),
    ),
  };

  Set<Circle> get _circles => {
    Circle(
      circleId: const CircleId('driver_area'),
      center: _mockDriverLocation,
      radius: 120,
      fillColor: context.colorScheme.primary.withValues(alpha: 0.16),
      strokeColor: context.colorScheme.primary.withValues(alpha: 0.34),
      strokeWidth: 2,
    ),
  };

  @override
  Widget build(BuildContext context) {
    final mediaPadding = MediaQuery.paddingOf(context);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: GoogleMap(
              initialCameraPosition: _initialCameraPosition,
              markers: _markers,
              circles: _circles,
              myLocationEnabled: _isMyLocationEnabled,
              gestureRecognizers: {
                Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer(),
                ),
              },
              myLocationButtonEnabled: _isMyLocationEnabled,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: Stack(
                children: [
                  Positioned(
                    top: -80,
                    left: -50,
                    child: Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0x3328B7C8),
                            const Color(0x0028B7C8),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -120,
                    right: -40,
                    child: Container(
                      width: 260,
                      height: 260,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0x33F29D38),
                            const Color(0x00F29D38),
                          ],
                        ),
                      ),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0x14161F29),
                          Colors.transparent,
                          const Color(0x1E102A43),
                          const Color(0x66202D3A),
                        ],
                        stops: const [0.0, 0.32, 0.62, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              Spacing.base,
              mediaPadding.top + Spacing.sm,
              Spacing.base,
              mediaPadding.bottom + 10,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final ordersHeight = (constraints.maxHeight * 0.8).clamp(
                  420.0,
                  820.0,
                );

                return Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        height: ordersHeight,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: _orders.length,
                          itemBuilder: (context, index) {
                            final order = _orders[index];
                            return Padding(
                              padding: const EdgeInsets.only(
                                bottom: Spacing.sm,
                              ),
                              child: Dismissible(
                                key: ValueKey(order.id),
                                direction: DismissDirection.horizontal,
                                onDismissed: (_) => _removeOrder(order.id),
                                background: _DismissBackground(
                                  alignment: Alignment.centerLeft,
                                  icon: Icons.close_rounded,
                                  color: context.colorScheme.error,
                                ),
                                secondaryBackground: _DismissBackground(
                                  alignment: Alignment.centerRight,
                                  icon: Icons.close_rounded,
                                  color: context.colorScheme.error,
                                ),
                                child: IncomingOrderCard(
                                  order: order,
                                  onTap: () => _openOrderDetails(order),
                                  onAccept: () => _removeOrder(order.id),
                                  onReject: () => _removeOrder(order.id),
                                  onExpired: () => _removeOrder(order.id),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: _ConnectionSwitch(
                          isOnline: _isOnline,
                          onChanged: (value) {
                            setState(() => _isOnline = value);
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<BitmapDescriptor> _buildPickupMarker({
    required String marketName,
  }) async {
    const double width = 154;
    const double height = 94;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final bubbleRect = Rect.fromLTWH(11, 0, width - 22, 42);
    const markerAccent = Color(0xFFE48215);

    final shadowPaint = Paint()..color = Colors.black.withValues(alpha: 0.12);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        bubbleRect.shift(const Offset(0, 3)),
        const Radius.circular(16),
      ),
      shadowPaint,
    );

    final cardPaint = Paint()..color = Colors.white;
    canvas.drawRRect(
      RRect.fromRectAndRadius(bubbleRect, const Radius.circular(16)),
      cardPaint,
    );

    final borderPaint = Paint()
      ..color = markerAccent.withValues(alpha: 0.30)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawRRect(
      RRect.fromRectAndRadius(bubbleRect, const Radius.circular(16)),
      borderPaint,
    );

    final iconBgPaint = Paint()..color = markerAccent.withValues(alpha: 0.14);
    canvas.drawCircle(const Offset(29, 21), 11, iconBgPaint);

    final iconPaint = Paint()..color = markerAccent;
    canvas.drawCircle(const Offset(29, 21), 4.5, iconPaint);

    final titlePainter = TextPainter(
      text: TextSpan(
        text: marketName,
        style: const TextStyle(
          fontFamily: FontConstant.cairo,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF212121),
        ),
      ),
      textDirection: TextDirection.rtl,
      maxLines: 1,
      ellipsis: '...',
    )..layout(maxWidth: 86);
    titlePainter.paint(canvas, const Offset(48, 12));

    final stemPaint = Paint()
      ..color = markerAccent.withValues(alpha: 0.78)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      const Offset(width / 2, 42),
      const Offset(width / 2, 66),
      stemPaint,
    );

    final dotGlowPaint = Paint()..color = markerAccent.withValues(alpha: 0.18);
    canvas.drawCircle(const Offset(width / 2, 74), 13, dotGlowPaint);

    final dotPaint = Paint()..color = markerAccent;
    canvas.drawCircle(const Offset(width / 2, 74), 7.5, dotPaint);

    final dotCorePaint = Paint()..color = Colors.white;
    canvas.drawCircle(const Offset(width / 2, 74), 3.2, dotCorePaint);

    final image = await recorder.endRecording().toImage(
      width.toInt(),
      height.toInt(),
    );
    final data = await image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.bytes(data!.buffer.asUint8List());
  }

  Future<BitmapDescriptor> _buildDriverMarker() async {
    const double width = 96.0;
    const double height = 118.0;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const center = Offset(width / 2, 46);

    final glowPaint = Paint()..color = const Color(0x26007A92);
    canvas.drawCircle(center, 34, glowPaint);

    final pinPaint = Paint()..color = const Color(0xFF007A92);
    canvas.drawCircle(center, 24, pinPaint);

    final innerPaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, 18, innerPaint);

    final iconPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(Icons.person_rounded.codePoint),
        style: const TextStyle(
          fontFamily: 'MaterialIcons',
          fontSize: 22,
          color: Color(0xFF007A92),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    iconPainter.paint(
      canvas,
      Offset(
        center.dx - iconPainter.width / 2,
        center.dy - iconPainter.height / 2,
      ),
    );

    final stemPaint = Paint()
      ..color = const Color(0xFF007A92)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      const Offset(width / 2, 68),
      const Offset(width / 2, 94),
      stemPaint,
    );

    final pointPaint = Paint()..color = const Color(0xFF007A92);
    canvas.drawCircle(const Offset(width / 2, 101), 7, pointPaint);

    final pointCore = Paint()..color = Colors.white;
    canvas.drawCircle(const Offset(width / 2, 101), 3, pointCore);

    final image = await recorder.endRecording().toImage(
      width.toInt(),
      height.toInt(),
    );
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.bytes(data!.buffer.asUint8List());
  }
}

class _DismissBackground extends StatelessWidget {
  const _DismissBackground({
    required this.alignment,
    required this.icon,
    required this.color,
  });

  final Alignment alignment;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(24),
      ),
      alignment: alignment,
      child: Icon(icon, color: Colors.white),
    );
  }
}

class _ConnectionSwitch extends StatelessWidget {
  const _ConnectionSwitch({required this.isOnline, required this.onChanged});

  final bool isOnline;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final accent = isOnline ? color.primary : color.onSurface;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.98),
            Colors.white.withValues(alpha: 0.93),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.72)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.only(
          start: 16,
          end: 8,
          top: 7,
          bottom: 7,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: isOnline
                    ? const Color(0xFF20B45B)
                    : Colors.grey.shade500,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (isOnline ? const Color(0xFF20B45B) : Colors.grey)
                        .withValues(alpha: 0.35),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isOnline
                      ? 'متصل الحين'
                      : 'غير متصل',
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size12,
                    color: accent,
                  ),
                ),
                Text(
                  isOnline
                      ? 'جاهز للطلبات'
                      : 'موقفه مؤقتاً',
                  style: getRegularStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size10,
                    color: color.onSurface.withValues(alpha: 0.58),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
            Transform.scale(
              scale: 0.78,
              child: Switch(
                value: isOnline,
                onChanged: onChanged,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                activeThumbColor: color.primary,
                activeTrackColor: color.primary.withValues(alpha: 0.32),
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey.withValues(alpha: 0.28),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

