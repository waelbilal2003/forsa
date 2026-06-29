// lib/services/session.dart
//
// تخزين بسيط لحالة المستخدم الحالي بعد تسجيل الدخول.
// يميّز بين الأدوار الثلاثة (customer / merchant / driver) ويحفظ المعرّفات
// والبيانات الأساسية التي تحتاجها الشاشات.

class Session {
  // ===== الأدوار والمعرفات =====
  static String? role;        // 'customer' | 'merchant' | 'driver'
  static int? userId;         // معرّف المستخدم (زبون/تاجر) من جدول users
  static int? storeId;        // معرّف المتجر (للتاجر فقط)
  static int? driverId;       // معرّف السائق (للسائق فقط)

  // ===== البيانات الأساسية للمستخدم =====
  static String? name;
  static String? email;
  static String? phone;       // رقم الهاتف
  static String? address;     // عنوان التوصيل (للزبون)
  static String? city;        // المدينة / المنطقة

  // ===== بيانات إضافية للتاجر =====
  static String? storeName;   // اسم المتجر
  static String? storeDescription; // وصف المتجر

  // ===== بيانات إضافية للسائق =====
  static String? driverPhone; // رقم هاتف السائق (قد يكون مختلفاً عن رقم المستخدم)
  static String? vehicleType; // نوع المركبة

  // ===== خصائص مساعدة =====
  static bool get isCustomer => role == 'customer';
  static bool get isMerchant => role == 'merchant';
  static bool get isDriver => role == 'driver';

  /// تُملأ بعد نجاح تسجيل الدخول من استجابة الـ API.
  static void setFromLogin(Map<String, dynamic> data) {
    role = data['role'] as String?;
    final user = Map<String, dynamic>.from(data['user'] ?? {});

    // البيانات الأساسية
    name = user['name']?.toString();
    email = user['email']?.toString();
    phone = user['phone']?.toString();
    address = user['address']?.toString();
    city = user['city']?.toString();

    // تعيين المعرفات حسب الدور
    if (role == 'driver') {
      driverId = _toInt(user['id']);
      driverPhone = user['phone']?.toString();
      vehicleType = user['vehicle_type']?.toString();
    } else {
      userId = _toInt(user['id']);
      if (role == 'merchant') {
        storeId = _toInt(user['store_id']);
        storeName = user['store_name']?.toString();
        storeDescription = user['store_description']?.toString();
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
    phone = null;
    address = null;
    city = null;
    storeName = null;
    storeDescription = null;
    driverPhone = null;
    vehicleType = null;
  }

  /// دالة مساعدة لتحويل القيم إلى int.
  static int? _toInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    return int.tryParse(v.toString());
  }
}