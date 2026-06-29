import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _loading = false;

  // حقول الزبون فقط
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _city = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    _confirm.dispose();
    _city.dispose();
    super.dispose();
  }

  void _snack(String m) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(m), behavior: SnackBarBehavior.floating));

  Future<void> _submit() async {
    if (_name.text.trim().isEmpty) {
      _snack('الرجاء إدخال الاسم');
      return;
    }
    if (!_email.text.contains('@')) {
      _snack('بريد إلكتروني غير صحيح');
      return;
    }
    if (_phone.text.trim().length < 6) {
      _snack('رقم هاتف غير صحيح');
      return;
    }
    if (_password.text.length < 6) {
      _snack('كلمة المرور 6 أحرف على الأقل');
      return;
    }
    if (_password.text != _confirm.text) {
      _snack('كلمتا المرور غير متطابقتين');
      return;
    }

    setState(() => _loading = true);
    try {
      await ApiService.registerCustomer({
        'name': _name.text.trim(),
        'email': _email.text.trim(),
        'phone': _phone.text.trim(),
        'city': _city.text.trim(),
        'password': _password.text,
      });
      if (!mounted) return;
      _snack('تم إنشاء الحساب بنجاح، سجّل دخولك الآن');
      Navigator.pop(context); // العودة لشاشة الدخول
    } on ApiException catch (e) {
      _snack(e.message);
    } catch (_) {
      _snack('تعذّر الاتصال بالخادم');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FC),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('إنشاء حساب جديد - زبون'),
        backgroundColor: Colors.white.withOpacity(0.8),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'مرحباً بك في فرصة',
                  style: GoogleFonts.tajawal(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2B2F33),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'أنشئ حساب زبون للاستفادة من العروض',
                  style: const TextStyle(color: Color(0xFF585C61)),
                ),
              ),
              const SizedBox(height: 32),
              _commonField('الاسم الكامل', _name, Icons.person_outline,
                  hint: 'أدخل اسمك الثلاثي'),
              _commonField('البريد الإلكتروني', _email, Icons.email_outlined,
                  hint: 'example@mail.com', keyboard: TextInputType.emailAddress),
              _commonField('رقم الهاتف', _phone, Icons.phone_outlined,
                  hint: '09xxxxxxxx', keyboard: TextInputType.phone),
              _commonField('المدينة / المنطقة', _city, Icons.location_on_outlined,
                  hint: 'اكتب عنوانك أو منطقتك'),
              _commonField('كلمة المرور', _password, Icons.lock_outline,
                  obscure: true),
              _commonField('تأكيد كلمة المرور', _confirm, Icons.lock_outline,
                  obscure: true),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF7A2C),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  child: _loading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                              strokeWidth: 2.5, color: Colors.black))
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('إنشاء الحساب الآن',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            SizedBox(width: 8),
                            Icon(Icons.person_add),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('لديك حساب بالفعل؟'),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('تسجيل الدخول',
                          style: TextStyle(
                              color: Color(0xFFFF7A2C),
                              fontWeight: FontWeight.bold)),
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

  Widget _commonField(String label, TextEditingController c, IconData icon,
      {String? hint, bool obscure = false, TextInputType? keyboard}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: c,
            obscureText: obscure,
            keyboardType: keyboard,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(icon),
              filled: true,
              fillColor: const Color(0xFFEDF1F7),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}