import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_bottom_nav.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FC),
      appBar: AppBar(
        title: const Text('الملف الشخصي'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Hero Profile Section
              Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 12),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuDm4cD7YFI_sm1oS3xNmlVNxX9iE3yVgG__Ax9Im5dEFFN7gFZDx9BSp40E6PHARvqc-tq45sSpvjQGi7SKjo_Hx_hlBCAanX8dvxogUDTMvJoF_oyGXTeLKO9P7LZDy1jWVugfVfdIj0bqagWA_pDXGPg87iXzU1Jnko51iV_XtV4a4eozPpucmRUY5usHhdsHVAvzLMhT_jr4K-tVq7Z1O0D2-edOTLL8kk-I6SYvBemmE2f_GC_XJUMqzNXKFGah0NG1h9A9gKaE',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -8,
                        right: -8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDD400),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4),
                            ],
                          ),
                          child: const Text(
                            'عضو بلاتيني',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF433700)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'أحمد محمد',
                          style: GoogleFonts.tajawal(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const Text('ahmed.m@email.com',
                            style: TextStyle(color: Color(0xFF585C61))),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Stats Bento Grid
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF7A2C),
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 12),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.stars,
                              size: 32, color: Colors.white),
                          const SizedBox(height: 40),
                          const Text('2,450',
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF401600))),
                          const Text('نقاط المكافأة',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF401600))),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDD400),
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 12),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.savings,
                              size: 32, color: Color(0xFF594A00)),
                          const SizedBox(height: 40),
                          const Text('SAR 120',
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF594A00))),
                          const Text('إجمالي التوفير',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF594A00))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Profile Menu
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'إعدادات الحساب',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: const Color(0xFF4953AC)),
                ),
              ),
              const SizedBox(height: 12),
              _buildMenuItem(
                context: context,
                icon: Icons.receipt_long,
                iconColor: const Color(0xFF9B3F00),
                iconBgColor: const Color(0xFFFFE4D6),
                title: 'طلباتي السابقة',
                onTap: () => Navigator.pushNamed(context, '/orders'),
              ),
              const SizedBox(height: 8),
              _buildMenuItem(
                context: context,
                icon: Icons.manage_accounts,
                iconColor: const Color(0xFF4953AC),
                iconBgColor: const Color(0xFFE8EAF5),
                title: 'إعدادات الحساب',
                onTap: () {},
              ),
              const SizedBox(height: 8),
              _buildMenuItem(
                context: context,
                icon: Icons.language,
                iconColor: const Color(0xFF6D5A00),
                iconBgColor: const Color(0xFFFEF3C7),
                title: 'اللغة',
                subtitle: 'العربية (تغيير)',
                onTap: () {},
              ),
              const SizedBox(height: 8),
              _buildMenuItem(
                context: context,
                icon: Icons.help_center,
                iconColor: const Color(0xFF4953AC),
                iconBgColor: const Color(0xFFE8EAF5),
                title: 'مركز المساعدة',
                onTap: () {},
              ),
              const SizedBox(height: 24),
              _buildMenuItem(
                context: context,
                icon: Icons.logout,
                iconColor: const Color(0xFFB02500),
                iconBgColor: const Color(0xFFFFE4DE),
                title: 'تسجيل الخروج',
                isLogout: true,
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
              const SizedBox(height: 32),
              // Promo Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4953AC), Color(0xFF3D469F)],
                  ),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'اكسب المزيد من النقاط!',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'شارك التطبيق مع أصدقائك واحصل على 500 نقطة إضافية لكل عملية شراء.',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFDD400),
                        foregroundColor: const Color(0xFF433700),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text('دعوة الأصدقاء'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 4),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    String? subtitle,
    bool isLogout = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isLogout ? const Color(0xFFB02500) : null)),
                  if (subtitle != null)
                    Text(subtitle,
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF585C61))),
                ],
              ),
            ),
            Icon(Icons.chevron_left,
                color: isLogout ? Colors.transparent : const Color(0xFFAAADB3)),
          ],
        ),
      ),
    );
  }
}
