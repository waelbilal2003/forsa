import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'theme/app_theme.dart';
import 'services/api_service.dart';

// شاشات عامة
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';

// شاشات الزبون
import 'screens/home_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/track_order_screen.dart';
import 'screens/offer_details_screen.dart';
import 'screens/filter_screen.dart';

// شاشات التاجر
import 'screens/publish_success.dart';
import 'screens/orders_management.dart';
import 'screens/offer_stats.dart';
import 'screens/add_offer.dart';
import 'screens/offers_history_screen.dart';
import 'screens/inventory_screen.dart';
import 'screens/add_product_screen.dart';

// شاشات السائق
import 'screens/order_receipt_screen.dart';
import 'screens/order_tracking_screen.dart';
import 'screens/complete_delivery_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/driver_main_screen.dart';

// شاشات الميزات الجديدة
import 'screens/nearby_offers_screen.dart';
import 'screens/settings_screen.dart';
// import 'screens/payment_screen.dart';      // مؤقتاً – تحتاج إلى معطيات
// import 'screens/coupon_screen.dart';       // مؤقتاً – تحتاج إلى معطيات
import 'screens/merchant_track_order_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiService.loadBaseUrl();
  runApp(const ForsaApp());
}

class ForsaApp extends StatelessWidget {
  const ForsaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'فرصة',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar', 'SA'),
      theme: AppTheme.light(),
      initialRoute: '/login',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'SA'),
        Locale('en', 'US'),
      ],
      routes: {
        // عام
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),

        // الزبون
        '/': (context) => const HomeScreen(),
        '/orders': (context) => const OrdersScreen(),
        '/cart': (context) => const CartScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/track-order': (context) => const TrackOrderScreen(),
        '/offer-details': (context) => const OfferDetailsScreen(),
        '/filter': (context) => const FilterScreen(),

        // التاجر
        '/merchant-orders': (context) => const OrdersManagementScreen(),
        '/add-offer': (context) => const AddOfferScreen(),
        '/offers-history': (context) => const OffersHistoryScreen(),
        '/offer-stats': (context) => const OfferStatsScreen(),
        '/publish_success': (context) => const PublishSuccessScreen(),
        '/inventory': (context) => const InventoryScreen(),
        '/add-product': (context) => const AddProductScreen(),

        // السائق
        '/driver-home': (context) => const DriverMainScreen(),
        '/order-receipt': (context) => const OrderReceiptScreen(),
        '/order-tracking': (context) => const OrderTrackingScreen(),
        '/complete-delivery': (context) => const CompleteDeliveryScreen(),
        '/chat': (context) => const ChatScreen(),

        // ميزات جديدة (بدون Payment و Coupon مؤقتاً)
        '/nearby-offers': (context) => const NearbyOffersScreen(),
        '/settings': (context) => const SettingsScreen(),
        // '/payment': (context) => const PaymentScreen(),   // تم تعليقها مؤقتاً
        // '/coupons': (context) => const CouponScreen(),    // تم تعليقها مؤقتاً
      },
      onGenerateRoute: (RouteSettings settings) {
        // مسار تتبع التاجر يحتاج إلى معطيات
        if (settings.name == '/merchant-track-order') {
          final args = settings.arguments as int?;
          if (args != null) {
            return MaterialPageRoute(
              builder: (context) => MerchantTrackOrderScreen(orderId: args),
            );
          }
          return MaterialPageRoute(
            builder: (context) => const Scaffold(
              body: Center(child: Text('خطأ: لم يتم تحديد رقم الطلب')),
            ),
          );
        }
        return null;
      },
    );
  }
}