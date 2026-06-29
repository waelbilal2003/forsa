import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import '../services/api_service.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

class LiveOrderTrackingScreen extends StatefulWidget {
  final int orderId;
  const LiveOrderTrackingScreen({super.key, required this.orderId});

  @override
  State<LiveOrderTrackingScreen> createState() => _LiveOrderTrackingScreenState();
}

class _LiveOrderTrackingScreenState extends State<LiveOrderTrackingScreen> {
  GoogleMapController? _mapController;
  LatLng? _driverPosition;
  Set<Marker> _markers = {};
  Timer? _pollTimer;
  Map<String, dynamic>? _orderDetails;
  bool _isMapReady = false;

  // ✅ معلومات السائق
  String _driverName = 'لم يتم تعيين';
  String _driverPhone = '';
  int? _etaMinutes;
  double? _driverSpeed; // سرعة السائق بالكم/ساعة

  @override
  void initState() {
    super.initState();
    _loadOrderDetails();
    _startPolling();
  }

  Future<void> _loadOrderDetails() async {
    try {
      final data = await ApiService.getOrderDetails(widget.orderId);
      if (mounted) {
        setState(() {
          _orderDetails = data;
          _driverName = data['driver_name'] ?? 'لم يتم تعيين';
          _driverPhone = data['driver_phone'] ?? '';
          _driverSpeed = double.tryParse(data['driver_speed']?.toString() ?? '') ?? 25.0;

          // حساب الوقت المتوقع إذا كانت المسافة موجودة
          if (data['distance'] != null) {
            final distance = double.tryParse(data['distance'].toString()) ?? 0;
            final speed = _driverSpeed ?? 25.0;
            _etaMinutes = ((distance / speed) * 60).ceil();
          }
        });
      }
    } catch (e) {
      print('❌ فشل تحميل تفاصيل الطلب: $e');
    }
  }

  void _startPolling() {
    _pollTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      try {
        final data = await ApiService.getDriverLocation(widget.orderId);
        final lat = double.tryParse(data['lat']?.toString() ?? '');
        final lng = double.tryParse(data['lng']?.toString() ?? '');
        if (lat != null && lng != null && lat != 0 && lng != 0) {
          final newPos = LatLng(lat, lng);
          if (mounted) {
            setState(() {
              _driverPosition = newPos;
              _updateMarkers();
            });
          }
          if (_mapController != null && _isMapReady) {
            _mapController!.animateCamera(
              CameraUpdate.newLatLng(newPos),
            );
          }
        }
      } catch (e) {
        print('⏳ انتظار تحديث موقع السائق...');
      }
    });
  }

  void _updateMarkers() {
    final markers = <Marker>{};

    if (_driverPosition != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('driver'),
          position: _driverPosition!,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueOrange,
          ),
          infoWindow: const InfoWindow(title: '🚚 موقع السائق'),
        ),
      );
    }

    if (mounted) {
      setState(() => _markers = markers);
    }
  }

  Future<void> _callDriver() async {
    if (_driverPhone.isEmpty) {
      _showSnack('رقم السائق غير متوفر');
      return;
    }
    final url = Uri.parse('tel:$_driverPhone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      _showSnack('تعذّر الاتصال بالسائق');
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.surfaceContainer,
        appBar: AppBar(
          title: Text('تتبع الطلب #${widget.orderId}'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Column(
          children: [
            // ✅ بطاقة معلومات السائق
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: AppColors.primary,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('السائق: $_driverName',
                                style: AppTypography.titleMedium),
                            if (_driverPhone.isNotEmpty)
                              Text('رقم السائق: $_driverPhone',
                                  style: AppTypography.bodySmall),
                          ],
                        ),
                      ),
                      if (_driverPhone.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.phone, color: Colors.green),
                          onPressed: _callDriver,
                          tooltip: 'اتصال بالسائق',
                        ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Icons.schedule,
                                size: 20, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Text(
                              'الوصول المتوقع: ${_etaMinutes ?? 'جاري الحساب'} دقيقة',
                              style: AppTypography.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Icons.speed,
                                size: 20, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Text(
                              'السرعة: ${_driverSpeed ?? '--'} كم/س',
                              style: AppTypography.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'الحالة: ${_orderDetails?['status'] ?? ''}',
                    style: AppTypography.bodyMedium,
                  ),
                ],
              ),
            ),
            // الخريطة
            Expanded(
              child: _driverPosition == null
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('في انتظار تحديث موقع السائق...'),
                        ],
                      ),
                    )
                  : GoogleMap(
                      onMapCreated: (controller) {
                        _mapController = controller;
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) {
                            setState(() => _isMapReady = true);
                          }
                          controller.animateCamera(
                            CameraUpdate.newLatLngZoom(_driverPosition!, 14),
                          );
                        });
                      },
                      initialCameraPosition: CameraPosition(
                        target: _driverPosition!,
                        zoom: 14,
                      ),
                      markers: _markers,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      zoomControlsEnabled: true,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}