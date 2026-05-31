// lib/services/session.dart
//
// تخزين بسيط لحالة المستخدم الحالي بعد تسجيل الدخول.
// يميّز بين الأدوار الثلاثة (customer / merchant / driver) ويحفظ المعرّفات
// التي تحتاجها الشاشات (userId, storeId, driverId).

class Session {
  static String? role;        // 'customer' | 'merchant' | 'driver'
  static int? userId;         // معرّف المستخدم (زبون/تاجر) من جدول users
  static int? storeId;        // معرّف المتجر (للتاجر فقط)
  static int? driverId;       // معرّف السائق (للسائق فقط)
  static String? name;
  static String? email;

  static bool get isCustomer => role == 'customer';
  static bool get isMerchant => role == 'merchant';
  static bool get isDriver => role == 'driver';

  /// تُملأ بعد نجاح تسجيل الدخول من استجابة الـ API.
  static void setFromLogin(Map<String, dynamic> data) {
    role = data['role'] as String?;
    final user = Map<String, dynamic>.from(data['user'] ?? {});
    name = user['name']?.toString();
    email = user['email']?.toString();

    if (role == 'driver') {
      driverId = _toInt(user['id']);
    } else {
      userId = _toInt(user['id']);
      if (role == 'merchant') {
        storeId = _toInt(user['store_id']);
      }
    }
  }

  /// مسح الجلسة عند تسجيل الخروج.
  static void clear() {
    role = null;
    userId = null;
    storeId = null;
    driverId = null;
    name = null;
    email = null;
  }

  static int? _toInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    return int.tryParse(v.toString());
  }
}
