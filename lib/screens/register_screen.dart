import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FC),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('أهلاً بك في فرصة'),
        backgroundColor: Colors.white.withOpacity(0.8),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Editorial Intro
              Stack(
                children: [
                  Positioned(
                    top: -30,
                    left: -20,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFDD400),
                        shape: BoxShape.circle,
                      ),
                      child: const Opacity(opacity: 0.2, child: SizedBox()),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        'فرصة',
                        style: GoogleFonts.tajawal(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2B2F33),
                        ),
                      ),
                      Text(
                        'خيارك الأفضل',
                        style: GoogleFonts.tajawal(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFF7A2C),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF7A2C).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(Icons.shopping_bag,
                              size: 80, color: Color(0xFFFF7A2C)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Registration Form Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFDD400),
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          // Full Name
                          const Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'الاسم الكامل',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF585C61)),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'أدخل اسمك الثلاثي',
                              filled: true,
                              fillColor:
                                  const Color(0xFFEDF1F7).withOpacity(0.6),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Email
                          const Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'البريد الإلكتروني',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF585C61)),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            textDirection: TextDirection.ltr,
                            decoration: InputDecoration(
                              hintText: 'example@mail.com',
                              filled: true,
                              fillColor:
                                  const Color(0xFFEDF1F7).withOpacity(0.6),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Phone
                          const Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'رقم الهاتف',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF585C61)),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                width: 80,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFFEDF1F7).withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Center(
                                  child: Text('+966',
                                      textDirection: TextDirection.ltr),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  textDirection: TextDirection.ltr,
                                  decoration: InputDecoration(
                                    hintText: '5XXXXXXXX',
                                    filled: true,
                                    fillColor: const Color(0xFFEDF1F7)
                                        .withOpacity(0.6),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Password
                          const Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'كلمة المرور',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF585C61)),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: '••••••••',
                              suffixIcon: const Icon(Icons.visibility_off),
                              filled: true,
                              fillColor:
                                  const Color(0xFFEDF1F7).withOpacity(0.6),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Location
                          const Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'تحديد الموقع',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF585C61)),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEDF1F7).withOpacity(0.6),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                hint: const Text('اختر المدينة'),
                                icon: const Icon(Icons.expand_more),
                                items: [
                                  'الرياض',
                                  'جدة',
                                  'الدمام',
                                  'مكة المكرمة'
                                ]
                                    .map((city) => DropdownMenuItem(
                                        value: city, child: Text(city)))
                                    .toList(),
                                onChanged: (value) {},
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Register Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(context, '/');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF7A2C),
                                foregroundColor: Colors.black,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('إنشاء الحساب الآن',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(width: 8),
                                  Icon(Icons.person_add),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Divider
                          Row(
                            children: [
                              const Expanded(
                                  child: Divider(color: Color(0xFFD8DDE5))),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text('أو التسجيل بواسطة'),
                              ),
                              const Expanded(
                                  child: Divider(color: Color(0xFFD8DDE5))),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Social Buttons
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.g_mobiledata,
                                      color: Color(0xFFDB4437)),
                                  label: const Text('جوجل'),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.facebook,
                                      color: Color(0xFF1877F2)),
                                  label: const Text('فيسبوك'),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Login Link
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('لديك حساب بالفعل؟'),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'تسجيل الدخول',
                        style: TextStyle(
                            color: Color(0xFFFF7A2C),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
