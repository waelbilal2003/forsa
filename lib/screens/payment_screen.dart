import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

class PaymentScreen extends StatefulWidget {
  final double total;
  final int orderId;
  const PaymentScreen({super.key, required this.total, required this.orderId});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedMethod = 'cash';

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('الدفع')),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('الطلب #${widget.orderId}', style: AppTypography.titleLarge),
              const SizedBox(height: 12),
              Text('المبلغ الكلي: ${widget.total.toStringAsFixed(0)} ل.س',
                  style: AppTypography.headlineMedium),
              const SizedBox(height: 32),
              const Text('اختر طريقة الدفع:', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              Card(
                child: RadioListTile<String>(
                  value: 'cash',
                  groupValue: _selectedMethod,
                  title: const Text('دفع نقدي عند التوصيل'),
                  onChanged: (v) => setState(() => _selectedMethod = v!),
                ),
              ),
              Card(
                child: RadioListTile<String>(
                  value: 'card',
                  groupValue: _selectedMethod,
                  title: const Text('بطاقة ائتمان'),
                  onChanged: (v) => setState(() => _selectedMethod = v!),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('تم تأكيد الدفع (طريقة: $_selectedMethod)')),
                    );
                    Navigator.pop(context, true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('تأكيد الدفع',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}