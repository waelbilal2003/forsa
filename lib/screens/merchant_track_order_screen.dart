import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import '../services/api_service.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

class MerchantTrackOrderScreen extends StatefulWidget {
  final int orderId;
  const MerchantTrackOrderScreen({super.key, required this.orderId});

  @override
  State<MerchantTrackOrderScreen> createState() => _MerchantTrackOrderScreenState();
}

class _MerchantTrackOrderScreenState extends State<MerchantTrackOrderScreen> {
  GoogleMapController? _mapController;
  LatLng? _driverPosition;
  Set<Marker> _markers = {};
  Timer? _pollTimer;
  Map<String, dynamic>? _orderDetails;
  bool _isMapReady = false;
  bool _isLoading = true;

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
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
          // تحريك الكاميرا إلى موقع السائق إذا كانت الخريطة جاهزة
          if (_mapController != null && _isMapReady) {
            _mapController!.animateCamera(
              CameraUpdate.newLatLng(newPos),
            );
          }
        }
      } catch (e) {
        // السائق لم يبدأ التحديث بعد
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

    // يمكن إضافة علامة موقع الزبون إذا كان لديك إحداثياته
    // if (_customerPosition != null) { ... }

    if (mounted) {
      setState(() => _markers = markers);
    }
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
            // معلومات الطلب
            if (_orderDetails != null)
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الزبون: ${_orderDetails!['customer_name'] ?? 'غير معروف'}',
                      style: AppTypography.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'السائق: ${_orderDetails!['driver_name'] ?? 'لم يتم تعيين'}',
                      style: AppTypography.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'الحالة: ${_orderDetails!['status'] ?? ''}',
                      style: AppTypography.bodyMedium,
                    ),
                  ],
                ),
              ),
            // الخريطة
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _driverPosition == null
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
                              // تحريك الكاميرا إلى موقع السائق عند إنشاء الخريطة
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