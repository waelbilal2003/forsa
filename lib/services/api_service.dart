import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String _defaultBaseUrl = 'http://192.168.10.234:8000/api';
  static const String _prefsKey = 'api_base_url';
  static const String _tokenKey = 'api_token';

  static String baseUrl = _defaultBaseUrl;
  static String? _token;

  static Future<void> loadBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefsKey);
    if (saved != null && saved.trim().isNotEmpty) {
      baseUrl = saved.trim();
    }
    _token = prefs.getString(_tokenKey);
  }

  static Future<void> setBaseUrl(String url) async {
    final clean = url.trim();
    baseUrl = clean.isEmpty ? _defaultBaseUrl : clean;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, baseUrl);
  }

  static Future<void> setToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  static Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_token != null && _token!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  static dynamic _decode(http.Response res) {
    final body = res.body.isNotEmpty ? jsonDecode(res.body) : {};
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return body;
    }
    final msg = (body is Map && body['message'] != null)
        ? body['message']
        : 'حدث خطأ (${res.statusCode})';
    throw ApiException(msg.toString(), res.statusCode);
  }

  // ============ المصادقة ============
  static Future<Map<String, dynamic>> login({
    required String role,
    required String email,
    required String password,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: _headers,
      body: jsonEncode({'role': role, 'email': email, 'password': password}),
    );
    final data = _decode(res);
    if (data is Map && data['token'] != null) {
      await setToken(data['token'].toString());
    }
    return Map<String, dynamic>.from(data);
  }

  static Future<Map<String, dynamic>> registerCustomer(
      Map<String, dynamic> data) async {
    final res = await http.post(Uri.parse('$baseUrl/register/customer'),
        headers: _headers, body: jsonEncode(data));
    return Map<String, dynamic>.from(_decode(res));
  }

  static Future<Map<String, dynamic>> registerMerchant(
      Map<String, dynamic> data) async {
    final res = await http.post(Uri.parse('$baseUrl/register/merchant'),
        headers: _headers, body: jsonEncode(data));
    return Map<String, dynamic>.from(_decode(res));
  }

  static Future<Map<String, dynamic>> registerDriver(
      Map<String, dynamic> data) async {
    final res = await http.post(Uri.parse('$baseUrl/register/driver'),
        headers: _headers, body: jsonEncode(data));
    return Map<String, dynamic>.from(_decode(res));
  }

  // ============ العروض ============
  static Future<List<dynamic>> getOffers({String? query}) async {
    final uri = Uri.parse('$baseUrl/offers')
        .replace(queryParameters: query != null ? {'q': query} : null);
    final res = await http.get(uri, headers: _headers);
    return List<dynamic>.from(_decode(res));
  }

  static Future<Map<String, dynamic>> getOffer(int id) async {
    final res =
        await http.get(Uri.parse('$baseUrl/offers/$id'), headers: _headers);
    return Map<String, dynamic>.from(_decode(res));
  }

  static Future<List<dynamic>> getMerchantOffers(int storeId) async {
    final res = await http.get(Uri.parse('$baseUrl/merchant/$storeId/offers'),
        headers: _headers);
    return List<dynamic>.from(_decode(res));
  }

  static Future<Map<String, dynamic>> addOffer(
      Map<String, dynamic> data) async {
    final res = await http.post(Uri.parse('$baseUrl/offers'),
        headers: _headers, body: jsonEncode(data));
    return Map<String, dynamic>.from(_decode(res));
  }

  static Future<void> toggleOffer(int id) async {
    final res = await http.put(Uri.parse('$baseUrl/offers/$id/toggle'),
        headers: _headers);
    _decode(res);
  }

  static Future<Map<String, dynamic>> addOfferStock(int id, int amount) async {
    final res = await http.put(Uri.parse('$baseUrl/offers/$id/add-stock'),
        headers: _headers, body: jsonEncode({'amount': amount}));
    return Map<String, dynamic>.from(_decode(res));
  }

  static Future<Map<String, dynamic>> reactivateOffer(int id,
      {int? stock}) async {
    final res = await http.put(Uri.parse('$baseUrl/offers/$id/reactivate'),
        headers: _headers,
        body: jsonEncode({if (stock != null) 'stock': stock}));
    return Map<String, dynamic>.from(_decode(res));
  }

  static Future<void> deleteOffer(int id) async {
    final res =
        await http.delete(Uri.parse('$baseUrl/offers/$id'), headers: _headers);
    _decode(res);
  }

  // ============ السلة ============
  static Future<Map<String, dynamic>> getCart(int userId) async {
    final res =
        await http.get(Uri.parse('$baseUrl/cart/$userId'), headers: _headers);
    return Map<String, dynamic>.from(_decode(res));
  }

  static Future<void> addToCart(int userId, int productId,
      {int quantity = 1}) async {
    final res = await http.post(Uri.parse('$baseUrl/cart'),
        headers: _headers,
        body: jsonEncode({
          'user_id': userId,
          'product_id': productId,
          'quantity': quantity
        }));
    _decode(res);
  }

  static Future<void> updateCartItem(int itemId, int quantity) async {
    final res = await http.put(Uri.parse('$baseUrl/cart/item/$itemId'),
        headers: _headers, body: jsonEncode({'quantity': quantity}));
    _decode(res);
  }

  static Future<void> removeCartItem(int itemId) async {
    final res = await http.delete(Uri.parse('$baseUrl/cart/item/$itemId'),
        headers: _headers);
    _decode(res);
  }

  // ============ الطلبات ============
  static Future<Map<String, dynamic>> checkout(int userId,
      {required String deliveryAddress,
      required String contactPhone,
      double distanceKm = 0}) async {
    final res = await http.post(Uri.parse('$baseUrl/orders'),
        headers: _headers,
        body: jsonEncode({
          'user_id': userId,
          'delivery_address': deliveryAddress,
          'contact_phone': contactPhone,
          'distance_km': distanceKm,
        }));
    return Map<String, dynamic>.from(_decode(res));
  }

  static Future<Map<String, dynamic>> getInvoice(int orderId) async {
    final res = await http.get(Uri.parse('$baseUrl/orders/$orderId/invoice'),
        headers: _headers);
    return Map<String, dynamic>.from(_decode(res));
  }

  static Future<Map<String, dynamic>> sendFalseReport(
      int orderId, int driverId, String reason) async {
    final res = await http.put(
        Uri.parse('$baseUrl/orders/$orderId/false-report'),
        headers: _headers,
        body: jsonEncode({'driver_id': driverId, 'reason': reason}));
    return Map<String, dynamic>.from(_decode(res));
  }

  static Future<void> rateDriver(
      {required int userId,
      required int driverId,
      int? orderId,
      required int rating,
      String? comment}) async {
    final res = await http.post(Uri.parse('$baseUrl/reviews/driver'),
        headers: _headers,
        body: jsonEncode({
          'user_id': userId,
          'driver_id': driverId,
          'order_id': orderId,
          'rating': rating,
          'comment': comment,
        }));
    _decode(res);
  }

  static Future<void> rateOrder(
      {required int userId,
      required int orderId,
      required int rating,
      String? comment}) async {
    final res = await http.post(Uri.parse('$baseUrl/reviews/order'),
        headers: _headers,
        body: jsonEncode({
          'user_id': userId,
          'order_id': orderId,
          'rating': rating,
          'comment': comment,
        }));
    _decode(res);
  }

  static Future<List<dynamic>> getCustomerOrders(int userId) async {
    final res = await http.get(Uri.parse('$baseUrl/customer/$userId/orders'),
        headers: _headers);
    return List<dynamic>.from(_decode(res));
  }

  static Future<Map<String, dynamic>> getCustomerOrderTracking(
      int orderId) async {
    final res = await http.get(Uri.parse('$baseUrl/orders/$orderId'),
        headers: _headers);
    return Map<String, dynamic>.from(_decode(res));
  }

  static Future<List<dynamic>> getMerchantOrders(int storeId) async {
    final res = await http.get(Uri.parse('$baseUrl/merchant/$storeId/orders'),
        headers: _headers);
    return List<dynamic>.from(_decode(res));
  }

  static Future<Map<String, dynamic>> getDriverOrders(int driverId) async {
    final res = await http.get(Uri.parse('$baseUrl/driver/$driverId/orders'),
        headers: _headers);
    return Map<String, dynamic>.from(_decode(res));
  }

  static Future<Map<String, dynamic>> getOrderDetails(int orderId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/orders/$orderId'),
      headers: _headers,
    );
    return Map<String, dynamic>.from(_decode(res));
  }

  static Future<void> updateOrderStatus(int orderId, String status) async {
    final res = await http.put(Uri.parse('$baseUrl/orders/$orderId/status'),
        headers: _headers, body: jsonEncode({'status': status}));
    _decode(res);
  }

  static Future<void> acceptOrder(int orderId, int driverId) async {
    final res = await http.put(Uri.parse('$baseUrl/orders/$orderId/accept'),
        headers: _headers, body: jsonEncode({'driver_id': driverId}));
    _decode(res);
  }

  static Future<Map<String, dynamic>> completeOrder(
      int orderId, int driverId) async {
    final res = await http.put(Uri.parse('$baseUrl/orders/$orderId/complete'),
        headers: _headers, body: jsonEncode({'driver_id': driverId}));
    return Map<String, dynamic>.from(_decode(res));
  }

  // ============ المحفظة والإحصائيات ============
  static Future<Map<String, dynamic>> getDriverWallet(int driverId) async {
    final res = await http.get(Uri.parse('$baseUrl/driver/$driverId/wallet'),
        headers: _headers);
    return Map<String, dynamic>.from(_decode(res));
  }

  static Future<Map<String, dynamic>> getMerchantStats(int storeId) async {
    final res = await http.get(Uri.parse('$baseUrl/merchant/$storeId/stats'),
        headers: _headers);
    return Map<String, dynamic>.from(_decode(res));
  }

  // ============ المتاجر القريبة ============
  static Future<List<Map<String, dynamic>>> getNearbyStores({
    required double lat,
    required double lng,
    double radius = 5.0,
  }) async {
    final uri = Uri.parse('$baseUrl/stores/nearby').replace(queryParameters: {
      'lat': lat.toString(),
      'lng': lng.toString(),
      'radius': radius.toString(),
    });
    final res = await http.get(uri, headers: _headers);
    final decoded = _decode(res);
    return List<Map<String, dynamic>>.from(decoded);
  }

  // ============ العروض القريبة ============
  static Future<List<dynamic>> getNearbyOffers({
    required double lat,
    required double lng,
    double radiusKm = 10,
  }) async {
    final uri = Uri.parse('$baseUrl/offers/nearby').replace(queryParameters: {
      'lat': lat.toString(),
      'lng': lng.toString(),
      'radius': radiusKm.toString(),
    });
    final res = await http.get(uri, headers: _headers);
    final decoded = _decode(res);
    return List<dynamic>.from(decoded);
  }

  // ============ تحديث موقع السائق ============
  static Future<void> updateDriverLocation({
    required int orderId,
    required int driverId,
    required double lat,
    required double lng,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/driver/location'),
      headers: _headers,
      body: jsonEncode({
        'order_id': orderId,
        'driver_id': driverId,
        'lat': lat,
        'lng': lng,
      }),
    );
    _decode(res);
  }

  static Future<Map<String, dynamic>> getDriverLocation(int orderId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/driver/location/$orderId'),
      headers: _headers,
    );
    return Map<String, dynamic>.from(_decode(res));
  }

  // ============ دوال رفع الصور والكوبونات والإعدادات ============
  static Future<Map<String, dynamic>> uploadImage(File image) async {
    final uri = Uri.parse('$baseUrl/upload');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Accept'] = 'application/json'
      ..headers['Authorization'] = _token != null ? 'Bearer $_token' : ''
      ..files.add(await http.MultipartFile.fromPath('image', image.path));
    final response = await request.send();
    final res = await http.Response.fromStream(response);
    return Map<String, dynamic>.from(_decode(res));
  }

  static Future<Map<String, dynamic>> applyCoupon(String code, double total) async {
    final res = await http.post(
      Uri.parse('$baseUrl/coupons/apply'),
      headers: _headers,
      body: jsonEncode({'code': code, 'total': total}),
    );
    return Map<String, dynamic>.from(_decode(res));
  }

  static Future<Map<String, dynamic>> getSettings() async {
    final res = await http.get(
      Uri.parse('$baseUrl/settings'),
      headers: _headers,
    );
    return Map<String, dynamic>.from(_decode(res));
  }

  static Future<Map<String, dynamic>> updateSettings(Map<String, dynamic> data) async {
    final res = await http.put(
      Uri.parse('$baseUrl/settings'),
      headers: _headers,
      body: jsonEncode(data),
    );
    return Map<String, dynamic>.from(_decode(res));
  }

  // ============ إدارة المخزون (جديد) ============
  static Future<List<dynamic>> getInventory(int storeId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/merchant/$storeId/inventory'),
      headers: _headers,
    );
    return List<dynamic>.from(_decode(res));
  }

  static Future<Map<String, dynamic>> addProductToInventory({
    required int storeId,
    required String name,
    required int quantity,
    required String unit,
    required double price,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/merchant/inventory'),
      headers: _headers,
      body: jsonEncode({
        'store_id': storeId,
        'name': name,
        'quantity': quantity,
        'unit': unit,
        'price': price,
      }),
    );
    return Map<String, dynamic>.from(_decode(res));
  }

  static Future<void> toggleProductActivation(int productId, bool isActive) async {
    final res = await http.put(
      Uri.parse('$baseUrl/merchant/inventory/$productId/toggle'),
      headers: _headers,
      body: jsonEncode({'is_active': isActive}),
    );
    _decode(res);
  }

  static Future<Map<String, dynamic>> checkProductAvailability(int productId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/merchant/inventory/$productId/availability'),
      headers: _headers,
    );
    return Map<String, dynamic>.from(_decode(res));
  }

  // دالة updateInventoryQuantity مع storeId اختياري
  static Future<Map<String, dynamic>> updateInventoryQuantity({
    required int productId,
    required int quantity,
    required String action,
    int? storeId,
  }) async {
    final body = {
      'quantity': quantity,
      'action': action,
    };
    if (storeId != null) body['store_id'] = storeId;

    final res = await http.put(
      Uri.parse('$baseUrl/merchant/inventory/$productId/quantity'),
      headers: _headers,
      body: jsonEncode(body),
    );
    return Map<String, dynamic>.from(_decode(res));
  }

  // دالة updateInventory (تستدعي updateInventoryQuantity مع action='add')
  static Future<Map<String, dynamic>> updateInventory({
    required int productId,
    required int quantityAdded,
    int? storeId,
  }) async {
    return await updateInventoryQuantity(
      productId: productId,
      quantity: quantityAdded,
      action: 'add',
      storeId: storeId,
    );
  }

  // دالة لخصم الكمية (تستدعي updateInventoryQuantity مع action='subtract')
  static Future<Map<String, dynamic>> subtractInventory({
    required int productId,
    required int quantity,
    int? storeId,
  }) async {
    return await updateInventoryQuantity(
      productId: productId,
      quantity: quantity,
      action: 'subtract',
      storeId: storeId,
    );
  }

  // ============ إدارة الطلبات للتاجر ============
  static Future<void> acceptOrderByMerchant(int orderId, int storeId) async {
    final res = await http.put(
      Uri.parse('$baseUrl/merchant/orders/$orderId/accept'),
      headers: _headers,
      body: jsonEncode({'store_id': storeId}),
    );
    _decode(res);
  }

  static Future<void> cancelOrder(int orderId, int storeId) async {
    final res = await http.put(
      Uri.parse('$baseUrl/merchant/orders/$orderId/cancel'),
      headers: _headers,
      body: jsonEncode({'store_id': storeId}),
    );
    _decode(res);
  }

  static Future<void> rejectOrder(int orderId, int storeId) async {
    final res = await http.put(
      Uri.parse('$baseUrl/merchant/orders/$orderId/reject'),
      headers: _headers,
      body: jsonEncode({'store_id': storeId}),
    );
    _decode(res);
  }

  // ============ دوال إضافية ============
  static Future<Map<String, dynamic>> getUserProfile(int userId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/users/$userId'),
      headers: _headers,
    );
    return Map<String, dynamic>.from(_decode(res));
  }

  static Future<Map<String, dynamic>> getDriverInfo(int driverId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/drivers/$driverId'),
      headers: _headers,
    );
    return Map<String, dynamic>.from(_decode(res));
  }

  static Future<void> updateDriverLocationWithSpeed({
    required int orderId,
    required int driverId,
    required double lat,
    required double lng,
    required double speed,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/driver/location'),
      headers: _headers,
      body: jsonEncode({
        'order_id': orderId,
        'driver_id': driverId,
        'lat': lat,
        'lng': lng,
        'speed': speed,
      }),
    );
    _decode(res);
  }

  static Future<Map<String, dynamic>> getOrderDetailsWithDriver(int orderId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/orders/$orderId/details'),
      headers: _headers,
    );
    return Map<String, dynamic>.from(_decode(res));
  }

  static Future<List<dynamic>> getInventoryHistory(int productId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/merchant/inventory/$productId/history'),
      headers: _headers,
    );
    return List<dynamic>.from(_decode(res));
  }

  static Future<Map<String, dynamic>> getInventoryStats(int storeId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/merchant/$storeId/inventory/stats'),
      headers: _headers,
    );
    return Map<String, dynamic>.from(_decode(res));
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;
  ApiException(this.message, this.statusCode);
  @override
  String toString() => message;
}