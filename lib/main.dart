import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/home_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/offer_details_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/track_order_screen.dart';
import 'screens/filter_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';

void main() {
  runApp(const EditorialPulseApp());
}

class EditorialPulseApp extends StatelessWidget {
  const EditorialPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Editorial Pulse',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar', 'SA'),
      theme: ThemeData(
        fontFamily: 'Tajawal',
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF4F6FC),
        primaryColor: const Color(0xFF9B3F00),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF9B3F00),
          secondary: Color(0xFF6D5A00),
          tertiary: Color(0xFF4953AC),
          error: Color(0xFFB02500),
          surface: Color(0xFFF4F6FC),
          onSurface: Color(0xFF2B2F33),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white.withOpacity(0.9),
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Color(0xFF9B3F00)),
          titleTextStyle: GoogleFonts.tajawal(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2B2F33),
          ),
        ),
      ),
      initialRoute: '/register',
      routes: {
        '/': (context) => const HomeScreen(),
        '/cart': (context) => const CartScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/offer-details': (context) => const OfferDetailsScreen(),
        '/orders': (context) => const OrdersScreen(),
        '/track-order': (context) => const TrackOrderScreen(),
        '/filter': (context) => const FilterScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
      },
    );
  }
}
