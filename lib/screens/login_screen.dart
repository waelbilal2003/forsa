import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import '../services/session.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _selectedRole = 'customer';

  bool _customerObscure = true;
  bool _merchantObscure = true;
  bool _driverObscure = true;
  bool _rememberMe = false;
  bool _loading = false;

  final _customerEmail = TextEditingController();
  final _customerPass = TextEditingController();
  final _merchantEmail = TextEditingController();
  final _merchantPass = TextEditingController();
  final _driverEmail = TextEditingController();
  final _driverPass = TextEditingController();

  // متغير لعرض عنوان API الحالي (للتصحيح)
  String _currentBaseUrl = '';

  @override
  void initState() {
    super.initState();
    // قراءة عنوان API الحالي من ApiService
    _currentBaseUrl = ApiService.baseUrl;
    // طباعة العنوان في وحدة التحكم لمساعدتك في التصحيح
    print('🌐 Current API Base URL: $_currentBaseUrl');
  }

  @override
  void dispose() {
    _customerEmail.dispose();
    _customerPass.dispose();
    _merchantEmail.dispose();
    _merchantPass.dispose();
    _driverEmail.dispose();
    _driverPass.dispose();
    super.dispose();
  }

  Future<void> _doLogin({
    required String role,
    required String email,
    required String password,
    required String targetRoute,
  }) async {
    if (email.trim().isEmpty || password.isEmpty) {
      _showMessage('يرجى إدخال البريد وكلمة المرور');
      return;
    }
    setState(() => _loading = true);
    try {
      final data = await ApiService.login(
          role: role, email: email.trim(), password: password);
      Session.setFromLogin(data);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, targetRoute);
    } on ApiException catch (e) {
      _showMessage(e.message);
    } catch (e) {
      // طباعة تفاصيل الخطأ الحقيقي (مثل SocketException أو Timeout)
      print('❌ Login error details: $e');
      _showMessage('تعذّر الاتصال بالخادم. تحقق من عنوان الـ API: $_currentBaseUrl\nالخطأ: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  // نافذة لتغيير عنوان الـ API (للتصحيح فقط)
  void _showChangeBaseUrlDialog() {
    final controller = TextEditingController(text: ApiService.baseUrl);
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('تغيير عنوان السيرفر'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('أدخل عنوان API الجديد (مثل http://192.168.10.234:8000/api)'),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'http://192.168.10.234:8000/api',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () async {
                final newUrl = controller.text.trim();
                if (newUrl.isNotEmpty) {
                  await ApiService.setBaseUrl(newUrl);
                  setState(() {
                    _currentBaseUrl = ApiService.baseUrl;
                  });
                  _showMessage('تم تغيير عنوان السيرفر إلى:\n$_currentBaseUrl');
                }
                Navigator.pop(ctx);
              },
              child: const Text('حفظ'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
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
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Icon(Icons.shopping_bag,
                            size: 32, color: Color(0xFFFDD400)),
                        const SizedBox(width: 8),
                        Text(
                          'فرصة خيارك الافضل',
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
                      'مرحباً بك',
                      style: GoogleFonts.tajawal(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2B2F33),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'اختر نوع حسابك للمتابعة',
                      style: TextStyle(fontSize: 16, color: Color(0xFF585C61)),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: _buildRoleButton(
                              label: 'زبون',
                              icon: Icons.person,
                              role: 'customer'),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildRoleButton(
                              label: 'تاجر',
                              icon: Icons.storefront,
                              role: 'merchant'),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildRoleButton(
                              label: 'سائق',
                              icon: Icons.local_shipping,
                              role: 'driver'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    if (_selectedRole == 'customer') _buildCustomerLoginForm(),
                    if (_selectedRole == 'merchant') _buildMerchantLoginForm(),
                    if (_selectedRole == 'driver') _buildDriverLoginForm(),
                    const SizedBox(height: 24),
                    Center(
                      child: Column(
                        children: [
                          const Text('ليس لديك حساب؟'),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/register'),
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
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton.small(
          onPressed: _showChangeBaseUrlDialog,
          backgroundColor: Colors.white,
          child: const Icon(Icons.settings, color: Colors.black87),
        ),
      ),
    );
  }

  Widget _buildRoleButton({
    required String label,
    required IconData icon,
    required String role,
  }) {
    final isSelected = _selectedRole == role;
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = role),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF7A2C) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 20,
                color: isSelected ? Colors.white : const Color(0xFF9B3F00)),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : const Color(0xFF9B3F00),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerLoginForm() {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerRight,
          child: Text('البريد الإلكتروني أو رقم الجوال',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFF4953AC))),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _customerEmail,
          decoration: _inputDecoration(
              hint: 'example@mail.com', icon: Icons.alternate_email),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('كلمة المرور',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xFF4953AC))),
            TextButton(
              onPressed: () {},
              child: const Text('نسيت كلمة المرور؟',
                  style: TextStyle(
                      color: Color(0xFFF46800), fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _customerPass,
          obscureText: _customerObscure,
          decoration: _passDecoration(
            obscure: _customerObscure,
            onToggle: () =>
                setState(() => _customerObscure = !_customerObscure),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Checkbox(
              value: _rememberMe,
              onChanged: (v) => setState(() => _rememberMe = v ?? false),
              activeColor: const Color(0xFF9B3F00),
            ),
            const Text('تذكرني على هذا الجهاز'),
          ],
        ),
        const SizedBox(height: 32),
        _loginButton(() => _doLogin(
              role: 'customer',
              email: _customerEmail.text,
              password: _customerPass.text,
              targetRoute: '/',
            )),
      ],
    );
  }

  Widget _buildMerchantLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('البريد الإلكتروني',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: _merchantEmail,
          keyboardType: TextInputType.emailAddress,
          decoration: _inputDecoration(
              hint: 'merchant@example.com', icon: Icons.email_outlined),
        ),
        const SizedBox(height: 20),
        const Text('كلمة المرور',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: _merchantPass,
          obscureText: _merchantObscure,
          decoration: _passDecoration(
            obscure: _merchantObscure,
            onToggle: () =>
                setState(() => _merchantObscure = !_merchantObscure),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: TextButton(
            onPressed: () {},
            child: const Text('نسيت كلمة المرور؟',
                style: TextStyle(color: Color(0xFF585C61), fontSize: 12)),
          ),
        ),
        const SizedBox(height: 32),
        _loginButton(() => _doLogin(
              role: 'merchant',
              email: _merchantEmail.text,
              password: _merchantPass.text,
              targetRoute: '/merchant-orders',
            )),
      ],
    );
  }

  Widget _buildDriverLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('البريد الإلكتروني أو رقم الجوال',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: _driverEmail,
          keyboardType: TextInputType.emailAddress,
          decoration: _inputDecoration(
              hint: 'driver@example.com', icon: Icons.email_outlined),
        ),
        const SizedBox(height: 20),
        const Text('كلمة المرور',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: _driverPass,
          obscureText: _driverObscure,
          decoration: _passDecoration(
            obscure: _driverObscure,
            onToggle: () => setState(() => _driverObscure = !_driverObscure),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: TextButton(
            onPressed: () {},
            child: const Text('نسيت كلمة المرور؟',
                style: TextStyle(color: Color(0xFF585C61), fontSize: 12)),
          ),
        ),
        const SizedBox(height: 32),
        _loginButton(() => _doLogin(
              role: 'driver',
              email: _driverEmail.text,
              password: _driverPass.text,
              targetRoute: '/driver-home',
            )),
      ],
    );
  }

  Widget _loginButton(VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF7A2C),
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: _loading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                    strokeWidth: 2.5, color: Colors.black),
              )
            : const Text('تسجيل الدخول',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }

  InputDecoration _inputDecoration(
      {required String hint, required IconData icon}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: const Color(0xFFEDF1F7),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }

  InputDecoration _passDecoration(
      {required bool obscure, required VoidCallback onToggle}) {
    return InputDecoration(
      hintText: '••••••••',
      prefixIcon: const Icon(Icons.lock),
      suffixIcon: IconButton(
        icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
        onPressed: onToggle,
      ),
      filled: true,
      fillColor: const Color(0xFFEDF1F7),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
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