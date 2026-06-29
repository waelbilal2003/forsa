
import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav.dart';
import '../services/session.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _logout(BuildContext context) {
    Session.clear();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6FC),
        appBar: AppBar(title: const Text('حسابي'), centerTitle: false),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 12),
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 44,
                    backgroundColor: Color(0xFFFFE2D1),
                    child: Icon(Icons.person,
                        size: 48, color: Color(0xFF9B3F00)),
                  ),
                  const SizedBox(height: 12),
                  Text(Session.name ?? 'زبون',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(Session.email ?? '',
                      style: const TextStyle(color: Color(0xFF585C61))),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _menuItem(Icons.receipt_long, 'طلباتي',
                      onTap: () =>
                          Navigator.pushReplacementNamed(context, '/orders')),
                  const Divider(height: 1),
                  _menuItem(Icons.shopping_cart, 'سلتي',
                      onTap: () =>
                          Navigator.pushReplacementNamed(context, '/cart')),
                  const Divider(height: 1),
                  _menuItem(Icons.location_on_outlined, 'عناويني'),
                  const Divider(height: 1),
                  _menuItem(Icons.support_agent, 'المساعدة والدعم'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () => _logout(context),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFD32F2F)),
                foregroundColor: const Color(0xFFD32F2F),
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout),
                  SizedBox(width: 8),
                  Text('تسجيل الخروج',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: const CustomBottomNav(currentIndex: 3),
      ),
    );
  }

  Widget _menuItem(IconData icon, String label, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF585C61)),
      title: Text(label),
      trailing: const Icon(Icons.chevron_left, size: 20),
      onTap: onTap ?? () {},
    );
  }
}
