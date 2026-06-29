import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/api_service.dart';
import '../services/session.dart';

class DriverDeliveryScreen extends StatefulWidget {
  final int orderId;
  const DriverDeliveryScreen({super.key, required this.orderId});

  @override
  State<DriverDeliveryScreen> createState() => _DriverDeliveryScreenState();
}

class _DriverDeliveryScreenState extends State<DriverDeliveryScreen> {
  GoogleMapController? _mapController;
  LatLng? _currentPos;
  LatLng? _customerPos;
  Set<Marker> _markers = {};
  Timer? _locationTimer;
  bool _isDelivering = true;
  String? _error;
  bool _isCameraMoving = false;
  bool _isMapReady = false; // للتأكد من أن الخريطة جاهزة

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndStart();
  }

  Future<void> _checkPermissionsAndStart() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          setState(() => _error = 'يجب منح صلاحية الموقع لبدء التوصيل');
        }
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        setState(() => _error = 'صلاحية الموقع محظورة نهائياً');
      }
      return;
    }

    if (Session.driverId == null) {
      if (mounted) {
        setState(() => _error = 'خطأ في الجلسة');
      }
      return;
    }

    await _fetchCustomerLocation();
    _startLocationUpdates();
  }

  Future<void> _fetchCustomerLocation() async {
    try {
      final order = await ApiService.getOrderDetails(widget.orderId);
      final address = order['delivery_address'] as String?;
      if (address == null || address.isEmpty) {
        print('⚠️ عنوان التوصيل غير موجود');
        return;
      }

      final encodedAddress = Uri.encodeComponent(address);
      final url =
          'https://nominatim.openstreetmap.org/search?q=$encodedAddress&format=json&limit=1&addressdetails=0';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          final lat = double.tryParse(data[0]['lat']);
          final lon = double.tryParse(data[0]['lon']);
          if (lat != null && lon != null) {
            if (mounted) {
              setState(() {
                _customerPos = LatLng(lat, lon);
                _updateMarkers();
              });
            }
            print('📍 موقع الزبون: $_customerPos');
          }
        }
      }
    } catch (e) {
      print('❌ فشل في جلب إحداثيات الزبون: $e');
    }
  }

  void _startLocationUpdates() {
    _locationTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (!_isDelivering) return;
      try {
        Position pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        final newPos = LatLng(pos.latitude, pos.longitude);
        if (mounted) {
          setState(() {
            _currentPos = newPos;
            _updateMarkers();
          });
        }

        // تحريك الكاميرا إذا كانت الخريطة جاهزة والمستخدم لا يحركها
        if (_mapController != null && !_isCameraMoving && _isMapReady) {
          _mapController!.animateCamera(
            CameraUpdate.newLatLng(newPos),
          );
        }

        await ApiService.updateDriverLocation(
          orderId: widget.orderId,
          driverId: Session.driverId!,
          lat: pos.latitude,
          lng: pos.longitude,
        );
      } catch (e) {
        print("Error updating location: $e");
      }
    });
  }

  void _updateMarkers() {
    final markers = <Marker>{};

    if (_currentPos != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('driver'),
          position: _currentPos!,
          icon: BitmapDescriptor.defaultMarker, // أيقونة افتراضية (حمراء)
          infoWindow: const InfoWindow(title: '📍 موقع السائق'),
        ),
      );
    }

    if (_customerPos != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('customer'),
          position: _customerPos!,
          icon: BitmapDescriptor.defaultMarker, // يمكن تخصيص اللون لاحقاً
          infoWindow: const InfoWindow(title: '🏠 موقع الزبون'),
        ),
      );
    }

    if (mounted) {
      setState(() => _markers = markers);
    }
  }

  Future<void> _completeDelivery() async {
    if (Session.driverId == null) {
      _showSnack('خطأ في الجلسة');
      return;
    }
    try {
      final result = await ApiService.completeOrder(
          widget.orderId, Session.driverId!);
      _showSnack('✅ تم التسليم — عمولتك ${result['commission']} ل.س');
      setState(() => _isDelivering = false);
      _locationTimer?.cancel();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/driver-home', (route) => false);
      }
    } catch (e) {
      _showSnack('❌ تعذّر إتمام التوصيل: ${e.toString()}');
    }
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isDelivering) {
          _showSnack('⚠️ يرجى إنهاء التوصيل أولاً');
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('توصيل الطلب #${widget.orderId}'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              if (!_isDelivering) {
                Navigator.pop(context);
              } else {
                _showSnack('⚠️ أنت في وضع التوصيل');
              }
            },
          ),
        ),
        body: _error != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 60, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(_error!),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('العودة'),
                    ),
                  ],
                ),
              )
            : _currentPos == null
                ? const Center(child: CircularProgressIndicator())
                : GoogleMap(
                    onMapCreated: (controller) {
                      _mapController = controller;
                      // نضع علامة أن الخريطة جاهزة بعد تحميلها
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(() => _isMapReady = true);
                        }
                        // نقل الكاميرا إلى موقع السائق فوراً
                        controller.animateCamera(
                          CameraUpdate.newLatLngZoom(_currentPos!, 15),
                        );
                      });
                    },
                    initialCameraPosition: CameraPosition(
                      target: _currentPos ?? const LatLng(33.5138, 36.2765),
                      zoom: 15,
                    ),
                    markers: _markers,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    zoomControlsEnabled: true,
                    onCameraMoveStarted: () {
                      _isCameraMoving = true;
                    },
                    onCameraIdle: () {
                      _isCameraMoving = false;
                    },
                  ),
        floatingActionButton: _isDelivering
            ? FloatingActionButton.extended(
                onPressed: _completeDelivery,
                icon: const Icon(Icons.check),
                label: const Text('تم التوصيل'),
                backgroundColor: Colors.green,
              )
            : null,
      ),
    );
  }
}