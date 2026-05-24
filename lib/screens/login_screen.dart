import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            // Background decorative elements
            Positioned(
              top: -100,
              left: -50,
              child: Container(
                width: 300,
                height: 300,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF7A2C),
                  shape: BoxShape.circle,
                ),
                child: const Opacity(opacity: 0.05, child: SizedBox()),
              ),
            ),
            Positioned(
              bottom: -100,
              right: -50,
              child: Container(
                width: 250,
                height: 250,
                decoration: const BoxDecoration(
                  color: Color(0xFFFDD400),
                  shape: BoxShape.circle,
                ),
                child: const Opacity(opacity: 0.08, child: SizedBox()),
              ),
            ),
            // Main Content
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    // Brand
                    Row(
                      children: [
                        const Icon(Icons.sick,
                            size: 32, color: Color(0xFFFDD400)),
                        const SizedBox(width: 8),
                        Text(
                          'Editorial Pulse',
                          style: GoogleFonts.tajawal(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2B2F33),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),
                    Text(
                      'مرحباً بك مجدداً',
                      style: GoogleFonts.tajawal(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2B2F33),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'اختر نوع حسابك للمتابعة',
                      style: TextStyle(
                        fontSize: 16,
                        color: const Color(0xFF585C61),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // User Type Selector
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDF1F7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          _buildUserTypeButton('زبون', Icons.person, true),
                          _buildUserTypeButton('تاجر', Icons.storefront, false),
                          _buildUserTypeButton(
                              'سائق', Icons.local_shipping, false),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Email/Phone Field
                    const Text(
                      'البريد الإلكتروني أو رقم الجوال',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4953AC)),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'example@mail.com',
                        prefixIcon: const Icon(Icons.alternate_email),
                        filled: true,
                        fillColor: const Color(0xFFEDF1F7),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Password Field
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'كلمة المرور',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4953AC)),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'نسيت كلمة المرور؟',
                            style: TextStyle(
                                color: Color(0xFFF46800),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: const Icon(Icons.visibility_off),
                        filled: true,
                        fillColor: const Color(0xFFEDF1F7),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Remember Me
                    Row(
                      children: [
                        Checkbox(
                          value: false,
                          onChanged: (value) {},
                          activeColor: const Color(0xFF9B3F00),
                        ),
                        const Text('تذكرني على هذا الجهاز'),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF7A2C),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'تسجيل الدخول',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Create Account
                    Center(
                      child: Column(
                        children: [
                          const Text('ليس لديك حساب؟'),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            child: const Text(
                              'إنشاء حساب جديد',
                              style: TextStyle(
                                  color: Color(0xFF9B3F00),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Footer Links
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 16,
                      children: [
                        _buildFooterLink('الشروط والأحكام'),
                        _buildFooterLink('سياسة الخصوصية'),
                        _buildFooterLink('اتصل بنا'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserTypeButton(String label, IconData icon, bool isSelected) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05), blurRadius: 4)
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 20,
                color: isSelected
                    ? const Color(0xFF9B3F00)
                    : const Color(0xFF585C61)),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? const Color(0xFF9B3F00)
                    : const Color(0xFF585C61),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterLink(String text) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(foregroundColor: const Color(0xFF585C61)),
      child: Text(text, style: const TextStyle(fontSize: 12)),
    );
  }
}
