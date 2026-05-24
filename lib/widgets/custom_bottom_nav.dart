import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  const CustomBottomNav({super.key, required this.currentIndex});

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex)
      return; // لا تفعل شيء إذا كان المستخدم في نفس الصفحة

    // العودة أولاً للشاشة الرئيسية لتصفية المكدس وضمان ظهور زر الرجوع تلقائياً بداخل الشاشات الأخرى
    Navigator.of(context).popUntil((route) => route.isFirst);

    switch (index) {
      case 0:
        // زر الرئيسية: يعود للشاشة الرئيسية بنجاح كوننا قمنا بـ popUntil للشاشة الأولى
        break;
      case 1:
        Navigator.pushNamed(context, '/orders');
        break;
      case 2:
        Navigator.pushNamed(context, '/cart');
        break;
      case 3:
        // العروض: يمكنك إضافة مسارها هنا عند إنشائها في الـ main.dart
        break;
      case 4:
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -8))
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
                Icons.home_outlined, Icons.home, 'الرئيسية', 0, context),
            _buildNavItem(Icons.receipt_long_outlined, Icons.receipt_long,
                'طلباتي', 1, context),
            _buildNavItem(Icons.shopping_cart_outlined, Icons.shopping_cart,
                'السلة', 2, context),
            _buildNavItem(Icons.local_offer_outlined, Icons.local_offer,
                'العروض', 3, context),
            _buildNavItem(
                Icons.person_outline, Icons.person, 'الحساب', 4, context),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData iconOutlined, IconData iconFilled, String label,
      int index, BuildContext context) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(context, index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isSelected ? iconFilled : iconOutlined,
              color: isSelected ? const Color(0xFF9B3F00) : Colors.grey),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 10,
                  color: isSelected ? const Color(0xFF9B3F00) : Colors.grey)),
        ],
      ),
    );
  }
}
