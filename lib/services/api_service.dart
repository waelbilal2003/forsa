import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // ▸▸ العنوان الافتراضي — يمكن تغييره من شاشة الإعدادات وحفظه:
  static const String _defaultBaseUrl = 'http://192.168.43.98:8000/api';
  static const String _prefsKey = 'api_base_url';

  // العنوان الحالي (متغيّر يُحمَّل من التخزين عند الإقلاع).
  static String baseUrl = _defaultBaseUrl;

  /// يُستدعى مرة واحدة عند بدء التطبيق لتحميل العنوان المحفوظ.
  static Future<void> loadBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefsKey);
    if (saved != null && saved.trim().isNotEmpty) {
      baseUrl = saved.trim();
    }
  }

  /// حفظ عنوان API جديد وتطبيقه فوراً.
  static Future<void> setBaseUrl(String url) async {
    final clean = url.trim();
    baseUrl = clean.isEmpty ? _defaultBaseUrl : clean;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, baseUrl);
  }

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // أداة داخلية لمعالجة الاستجابة وتحويلها إلى Map/List
  static dynamic _decode(http.Response res) {
    final body = res.body.isNotEmpty ? jsonDecode(res.body) : {};
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return body;
    }
    // نُعيد رسالة الخطأ القادمة من Laravel إن وُجدت
    final msg = (body is Map && body['message'] != null)
        ? body['message']
        : 'حدث خطأ (${res.statusCode})';
    throw ApiException(msg.toString(), res.statusCode);
  }

  // ============ المصادقة ============

  /// تسجيل الدخول لأي دور. يُرجع Map فيه: success, role, user
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
    return Map<String, dynamic>.from(_decode(res));
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

  /// زيادة كمية منتج العرض.  PUT /offers/{id}/add-stock
  static Future<Map<String, dynamic>> addOfferStock(int id, int amount) async {
    final res = await http.put(Uri.parse('$baseUrl/offers/$id/add-stock'),
        headers: _headers, body: jsonEncode({'amount': amount}));
    return Map<String, dynamic>.from(_decode(res));
  }

  /// إعادة تفعيل عرض منتهٍ.  PUT /offers/{id}/reactivate
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

  /// الفاتورة التفصيلية.  GET /orders/{id}/invoice
  static Future<Map<String, dynamic>> getInvoice(int orderId) async {
    final res = await http.get(Uri.parse('$baseUrl/orders/$orderId/invoice'),
        headers: _headers);
    return Map<String, dynamic>.from(_decode(res));
  }

  /// السائق يرسل بلاغاً كاذباً.  PUT /orders/{id}/false-report
  static Future<Map<String, dynamic>> sendFalseReport(
      int orderId, int driverId, String reason) async {
    final res = await http.put(
        Uri.parse('$baseUrl/orders/$orderId/false-report'),
        headers: _headers,
        body: jsonEncode({'driver_id': driverId, 'reason': reason}));
    return Map<String, dynamic>.from(_decode(res));
  }

  /// تقييم السائق.  POST /reviews/driver
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

  /// تقييم الطلب.  POST /reviews/order
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

  /// تفاصيل طلب واحد (للتتبّع).  GET /orders/{id}
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
}

/// استثناء بسيط يحمل رسالة الخطأ ليُعرض للمستخدم.
class ApiException implements Exception {
  final String message;
  final int statusCode;
  ApiException(this.message, this.statusCode);
  @override
  String toString() => message;
}
