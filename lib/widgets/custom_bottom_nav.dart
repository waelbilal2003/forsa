// lib/widgets/custom_bottom_nav.dart
//
// شريط التنقل السفلي الخاص بواجهة الزبون فقط (الرئيسية/الطلبات/السلة/حسابي).
// يستخدم pushReplacementNamed للتنقل بين التبويبات حتى لا تتراكم الشاشات
// ولا يختلط مع واجهات التاجر أو السائق.

import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  const CustomBottomNav({super.key, required this.currentIndex});

  static const _routes = ['/', '/orders', '/cart', '/profile'];

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;
    // تبويبات شقيقة: نستبدل الشاشة الحالية بدل تكديسها.
    Navigator.pushReplacementNamed(context, _routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex.clamp(0, 3),
      onTap: (i) => _onTap(context, i),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFFFF7A2C),
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
        BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long), label: 'طلباتي'),
        BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart), label: 'السلة'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'حسابي'),
      ],
    );
  }
}
