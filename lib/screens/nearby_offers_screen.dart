import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../services/api_service.dart';

class NearbyOffersScreen extends StatefulWidget {
  const NearbyOffersScreen({super.key});

  @override
  State<NearbyOffersScreen> createState() => _NearbyOffersScreenState();
}

class _NearbyOffersScreenState extends State<NearbyOffersScreen>
    with AutomaticKeepAliveClientMixin {
  LatLng? _currentPosition;
  List<dynamic> _offers = [];
  bool _loading = true;
  String? _error;
  bool _locationTimedOut = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadNearbyOffers();
  }

  Future<void> _loadNearbyOffers() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _error = null;
      _locationTimedOut = false;
    });

    try {
      // 1. التحقق من صلاحية الموقع
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            setState(() {
              _error = 'يجب منح صلاحية الموقع لعرض العروض القريبة';
              _loading = false;
            });
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          setState(() {
            _error = 'صلاحية الموقع محظورة نهائياً، يرجى تفعيلها من الإعدادات';
            _loading = false;
          });
        }
        return;
      }

      // 2. الحصول على الموقع الحالي مع مهلة 5 ثوانٍ (باستخدام Future.timeout)
      Position pos;
      try {
        pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation,
        ).timeout(const Duration(seconds: 5));
      } catch (e) {
        // إذا فشل الحصول على الموقع، نستخدم إحداثيات افتراضية (دمشق)
        if (mounted) {
          setState(() {
            _locationTimedOut = true;
            _currentPosition = const LatLng(33.5138, 36.2765);
          });
        }
        // جلب العروض باستخدام الموقع الافتراضي
        final offers = await ApiService.getNearbyOffers(
          lat: _currentPosition!.latitude,
          lng: _currentPosition!.longitude,
          radiusKm: 10,
        );
        if (mounted) {
          setState(() {
            _offers = offers;
            _loading = false;
          });
        }
        return;
      }

      // 3. تحديث الموقع الحالي
      _currentPosition = LatLng(pos.latitude, pos.longitude);

      // 4. جلب العروض القريبة من الخادم
      final offers = await ApiService.getNearbyOffers(
        lat: pos.latitude,
        lng: pos.longitude,
        radiusKm: 10,
      );

      if (mounted) {
        setState(() {
          _offers = offers;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'حدث خطأ: ${e.toString()}';
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // مهم لـ AutomaticKeepAliveClientMixin
    return Scaffold(
      appBar: AppBar(title: const Text('عروض قريبة منك')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 60, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(_error!, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadNearbyOffers,
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                )
              : _currentPosition == null
                  ? const Center(child: Text('لا يمكن تحديد الموقع'))
                  : _offers.isEmpty
                      ? const Center(child: Text('لا توجد عروض قريبة'))
                      : Column(
                          children: [
                            // الخريطة (نسبة 60% من الشاشة)
                            Expanded(
                              flex: 2,
                              child: FlutterMap(
                                options: MapOptions(
                                  initialCenter: _currentPosition!,
                                  initialZoom: 13,
                                  interactionOptions: const InteractionOptions(
                                    flags: InteractiveFlag.all,
                                  ),
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate:
                                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    userAgentPackageName: 'com.forsa.app',
                                  ),
                                  MarkerLayer(
                                    markers: [
                                      // موقع المستخدم
                                      Marker(
                                        point: _currentPosition!,
                                        width: 40,
                                        height: 40,
                                        child: const Icon(
                                          Icons.my_location,
                                          color: Colors.blue,
                                          size: 30,
                                        ),
                                      ),
                                      // مواقع العروض
                                      ..._offers.map((offer) {
                                        final lat = double.tryParse(
                                                offer['latitude']?.toString() ?? '0') ??
                                            0;
                                        final lng = double.tryParse(
                                                offer['longitude']?.toString() ?? '0') ??
                                            0;
                                        return Marker(
                                          point: LatLng(lat, lng),
                                          width: 60,
                                          height: 60,
                                          child: GestureDetector(
                                            onTap: () => _showOfferDetails(offer),
                                            child: const CircleAvatar(
                                              radius: 25,
                                              backgroundColor: Colors.orange,
                                              child: Icon(
                                                Icons.local_offer,
                                                color: Colors.white,
                                                size: 28,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // قائمة العروض (نسبة 40% من الشاشة)
                            Expanded(
                              flex: 1,
                              child: ListView.builder(
                                padding: const EdgeInsets.all(8),
                                itemCount: _offers.length,
                                itemBuilder: (ctx, idx) {
                                  final o = _offers[idx];
                                  final distance = (o['distance_km'] as num?)?.toDouble() ?? 0;
                                  return Card(
                                    margin: const EdgeInsets.symmetric(vertical: 4),
                                    child: ListTile(
                                      leading: const Icon(Icons.shopping_bag),
                                      title: Text(o['product_name'] ?? 'عرض'),
                                      subtitle: Text(o['store_name'] ?? 'متجر'),
                                      trailing: Text('${distance.toStringAsFixed(1)} كم'),
                                      onTap: () => _showOfferDetails(o),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
    );
  }

  void _showOfferDetails(dynamic offer) {
    Navigator.pushNamed(context, '/offer-details', arguments: offer['id']);
  }
}