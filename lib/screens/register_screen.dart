import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String _selectedRole = 'customer';
  String? _selectedVehicleType = 'سيارة';
  bool _loading = false;

  // حقول مشتركة وخاصة بكل دور
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _city = TextEditingController();
  final _license = TextEditingController();
  final _storeName = TextEditingController();
  final _storeDesc = TextEditingController();

  @override
  void dispose() {
    for (final c in [
      _name,
      _email,
      _phone,
      _password,
      _confirm,
      _city,
      _license,
      _storeName,
      _storeDesc
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _snack(String m) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(m), behavior: SnackBarBehavior.floating));

  // نافذة منبثقة لإدخال عنوان API وحفظه (يُستخدم في كل النداءات بعد الحفظ).
  Future<void> _openApiSettings() async {
    final ctrl = TextEditingController(text: ApiService.baseUrl);
    final saved = await showDialog<String>(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('إعدادات الخادم (API)'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                  'أدخل عنوان الـ API الذي سيتصل به التطبيق. سيُحفظ ويُستخدم في كل العمليات.'),
              const SizedBox(height: 12),
              TextField(
                controller: ctrl,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: 'عنوان API',
                  hintText: 'http://localhost:8000/api',
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
              onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
              child: const Text('حفظ'),
            ),
          ],
        ),
      ),
    );

    if (saved == null) return;
    await ApiService.setBaseUrl(saved);
    if (!mounted) return;
    _snack('تم حفظ عنوان الخادم');
  }

  // تحقق مشترك من الحقول الأساسية
  String? _validateCommon() {
    if (_name.text.trim().isEmpty) return 'الرجاء إدخال الاسم';
    if (!_email.text.contains('@')) return 'بريد إلكتروني غير صحيح';
    if (_phone.text.trim().length < 6) return 'رقم هاتف غير صحيح';
    if (_password.text.length < 6) return 'كلمة المرور 6 أحرف على الأقل';
    if (_password.text != _confirm.text) return 'كلمتا المرور غير متطابقتين';
    return null;
  }

  Future<void> _submit() async {
    final err = _validateCommon();
    if (err != null) {
      _snack(err);
      return;
    }
    if (_selectedRole == 'merchant' && _storeName.text.trim().isEmpty) {
      _snack('الرجاء إدخال اسم المتجر');
      return;
    }

    setState(() => _loading = true);
    try {
      if (_selectedRole == 'customer') {
        await ApiService.registerCustomer({
          'name': _name.text.trim(),
          'email': _email.text.trim(),
          'phone': _phone.text.trim(),
          'city': _city.text.trim(),
          'password': _password.text,
        });
      } else if (_selectedRole == 'driver') {
        await ApiService.registerDriver({
          'name': _name.text.trim(),
          'email': _email.text.trim(),
          'phone': _phone.text.trim(),
          'vehicle_type': _selectedVehicleType,
          'license_number': _license.text.trim(),
          'password': _password.text,
        });
      } else {
        await ApiService.registerMerchant({
          'name': _name.text.trim(),
          'email': _email.text.trim(),
          'phone': _phone.text.trim(),
          'store_name': _storeName.text.trim(),
          'description': _storeDesc.text.trim(),
          'password': _password.text,
        });
      }
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
        title: const Text('أهلاً بك في فرصة'),
        backgroundColor: Colors.white.withOpacity(0.8),
        actions: [
          IconButton(
            tooltip: 'إعدادات الخادم',
            icon: const Icon(Icons.settings),
            onPressed: _openApiSettings,
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildRoleButton('زبون', Icons.person, 'customer'),
                  _buildRoleButton('سائق', Icons.local_shipping, 'driver'),
                  _buildRoleButton('تاجر', Icons.store, 'merchant'),
                ],
              ),
              const SizedBox(height: 24),
              _commonField('الاسم الكامل', _name, Icons.person_outline,
                  hint: 'أدخل اسمك الثلاثي'),
              _commonField('البريد الإلكتروني', _email, Icons.email_outlined,
                  hint: 'example@mail.com',
                  keyboard: TextInputType.emailAddress),
              _commonField('رقم الهاتف', _phone, Icons.phone_outlined,
                  hint: '09xxxxxxxx', keyboard: TextInputType.phone),
              if (_selectedRole == 'customer')
                _commonField(
                    'المدينة / المنطقة', _city, Icons.location_on_outlined,
                    hint: 'اكتب عنوانك أو منطقتك'),
              if (_selectedRole == 'driver') ...[
                _buildVehicleDropdown(),
                _commonField('رقم الرخصة', _license, Icons.badge_outlined,
                    hint: 'رقم رخصة القيادة'),
              ],
              if (_selectedRole == 'merchant') ...[
                _commonField(
                    'اسم المتجر', _storeName, Icons.storefront_outlined,
                    hint: 'مثلاً: متجر البركة للأقمشة'),
                _commonField(
                    'وصف المتجر', _storeDesc, Icons.description_outlined,
                    hint: 'أخبر عملاءك عن تميز متجرك...'),
              ],
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

  Widget _buildRoleButton(String label, IconData icon, String role) {
    final isSelected = _selectedRole == role;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedRole = role),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFF7A2C) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2)),
            ],
          ),
          child: Column(
            children: [
              Icon(icon,
                  color: isSelected ? Colors.white : const Color(0xFFFF7A2C),
                  size: 28),
              const SizedBox(height: 6),
              Text(label,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isSelected ? Colors.white : Colors.black87)),
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

  Widget _buildVehicleDropdown() {
    const types = ['سيارة', 'دراجة نارية', 'دراجة هوائية', 'شاحنة صغيرة'];
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('نوع المركبة',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedVehicleType,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.directions_car_outlined),
              filled: true,
              fillColor: const Color(0xFFEDF1F7),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
            items: types
                .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                .toList(),
            onChanged: (v) => setState(() => _selectedVehicleType = v),
          ),
        ],
      ),
    );
  }
}
