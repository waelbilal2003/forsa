import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../services/api_service.dart';

class CouponScreen extends StatefulWidget {
  final double currentTotal;
  final Function(double newTotal) onApply;
  const CouponScreen({super.key, required this.currentTotal, required this.onApply});

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  final TextEditingController _codeController = TextEditingController();
  bool _loading = false;

  Future<void> _applyCoupon() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) return;
    setState(() => _loading = true);
    try {
      final result = await ApiService.applyCoupon(code, widget.currentTotal);
      final newTotal = result['new_total'] as double? ?? widget.currentTotal;
      widget.onApply(newTotal);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('إدخال كود الخصم')),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              TextField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'أدخل الكود',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _applyCoupon,
                  child: _loading
                      ? const CircularProgressIndicator()
                      : const Text('تطبيق الكود'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}