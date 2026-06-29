import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import '../services/api_service.dart';

class NearbyStoresMapScreen extends StatefulWidget {
  const NearbyStoresMapScreen({super.key});

  @override
  State<NearbyStoresMapScreen> createState() => _NearbyStoresMapScreenState();
}

class _NearbyStoresMapScreenState extends State<NearbyStoresMapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng? _currentPosition;
  Set<Marker> _markers = {};
  List<Map<String, dynamic>> _stores = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _getCurrentLocationAndLoadStores();
  }

  Future<void> _getCurrentLocationAndLoadStores() async {
    try {
      // صلاحية الموقع
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _isLoading = false;
            _error = 'يرجى منح صلاحية الموقع';
          });
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _isLoading = false;
          _error = 'صلاحية الموقع محظورة نهائياً';
        });
        return;
      }

      // الحصول على الموقع
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _currentPosition = LatLng(position.latitude, position.longitude);

      // جلب المتاجر القريبة
      final stores = await ApiService.getNearbyStores(
        lat: position.latitude,
        lng: position.longitude,
        radius: 10.0,
      );
      _stores = stores;

      // إنشاء العلامات
      _createMarkers();

      // تحريك الكاميرا
      if (_controller.isCompleted) {
        final GoogleMapController controller = await _controller.future;
        await controller.animateCamera(
          CameraUpdate.newLatLngZoom(_currentPosition!, 13.0),
        );
      }

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  void _createMarkers() {
    final markers = <Marker>{};

    for (var store in _stores) {
      final id = store['id'].toString();
      final lat = double.tryParse(store['latitude']?.toString() ?? '') ?? 0.0;
      final lng = double.tryParse(store['longitude']?.toString() ?? '') ?? 0.0;
      if (lat == 0.0 && lng == 0.0) continue; // تجاهل الإحداثيات الصفرية

      final name = store['store_name']?.toString() ?? 'متجر';
      final address = store['address']?.toString() ?? '';
      double distance = 0.0;
      final distValue = store['distance_km'];
      if (distValue != null) {
        if (distValue is num) {
          distance = distValue.toDouble();
        } else {
          distance = double.tryParse(distValue.toString()) ?? 0.0;
        }
      }

      markers.add(
        Marker(
          markerId: MarkerId(id),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
            title: name,
            snippet: '$address - ${distance.toStringAsFixed(1)} كم',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueOrange,
          ),
        ),
      );
    }

    // علامة موقع المستخدم
    if (_currentPosition != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('user_location'),
          position: _currentPosition!,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueBlue,
          ),
          infoWindow: const InfoWindow(title: 'موقعك الحالي'),
        ),
      );
    }

    setState(() => _markers = markers);
  }

  Future<void> _goToCurrentLocation() async {
    if (_currentPosition == null) return;
    if (!_controller.isCompleted) return;
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newLatLngZoom(_currentPosition!, 15.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: [
            if (_currentPosition != null)
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _currentPosition!,
                  zoom: 13.0,
                ),
                markers: _markers,
                onMapCreated: (controller) {
                  if (!_controller.isCompleted) {
                    _controller.complete(controller);
                  }
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
              )
            else if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Center(child: Text(_error ?? 'تعذر تحميل الخريطة')),

            // زر العودة
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              left: 16,
              child: FloatingActionButton.small(
                heroTag: 'back',
                backgroundColor: Colors.white,
                onPressed: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),

            // زر إعادة التمركز
            Positioned(
              bottom: 150,
              left: 16,
              child: FloatingActionButton(
                heroTag: 'my_location',
                backgroundColor: Colors.white,
                onPressed: _goToCurrentLocation,
                child: const Icon(
                  Icons.my_location,
                  color: Color(0xFFFF7A2C),
                ),
              ),
            ),

            // بطاقة المتاجر القريبة
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 120,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 10),
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _error != null
                        ? Center(child: Text('خطأ: $_error'))
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'المتاجر القريبة (${_stores.length})',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _stores.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(width: 12),
                                  itemBuilder: (context, index) {
                                    final store = _stores[index];
                                    final name =
                                        store['store_name']?.toString() ??
                                            'متجر';
                                    final address =
                                        store['address']?.toString() ?? '';
                                    final distance = double.tryParse(
                                            store['distance_km']?.toString() ??
                                                '') ??
                                        0;
                                    return GestureDetector(
                                      onTap: () {
                                        final lat = double.tryParse(
                                            store['latitude'].toString());
                                        final lng = double.tryParse(
                                            store['longitude'].toString());
                                        if (lat != null && lng != null) {
                                          if (_controller.isCompleted) {
                                            _controller.future.then((controller) {
                                              controller.animateCamera(
                                                CameraUpdate.newLatLngZoom(
                                                  LatLng(lat, lng),
                                                  16.0,
                                                ),
                                              );
                                            });
                                          }
                                        }
                                      },
                                      child: Container(
                                        width: 140,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF4F6FC),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              address,
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const Spacer(),
                                            Text(
                                              '${distance.toStringAsFixed(1)} كم',
                                              style: const TextStyle(
                                                color: Color(0xFFFF7A2C),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
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