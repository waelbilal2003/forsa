import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../services/api_service.dart';
import '../services/session.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _apiUrlController = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _apiUrlController.text = ApiService.baseUrl;
  }

  @override
  void dispose() {
    _apiUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveApiUrl() async {
    final url = _apiUrlController.text.trim();
    if (url.isEmpty) return;
    setState(() => _loading = true);
    await ApiService.setBaseUrl(url);
    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حفظ عنوان السيرفر')),
    );
  }

  void _logout() {
    Session.clear();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('الإعدادات')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _apiUrlController,
                decoration: const InputDecoration(
                  labelText: 'عنوان السيرفر (API)',
                  hintText: 'http://192.168.10.234:8000/api',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loading ? null : _saveApiUrl,
                child: _loading
                    ? const CircularProgressIndicator()
                    : const Text('حفظ'),
              ),
              const Divider(height: 32),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('اللغة'),
                trailing: DropdownButton<String>(
                  value: 'ar',
                  items: const [
                    DropdownMenuItem(value: 'ar', child: Text('العربية')),
                    DropdownMenuItem(value: 'en', child: Text('English')),
                  ],
                  onChanged: (value) {
                    // TODO: تغيير اللغة
                  },
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('الإشعارات'),
                trailing: Switch(
                  value: true,
                  onChanged: (v) {
                    // TODO: تفعيل/تعطيل الإشعارات
                  },
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('تسجيل الخروج', style: TextStyle(color: Colors.red)),
                onTap: _logout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}