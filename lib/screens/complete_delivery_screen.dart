// lib/screens/complete_delivery_screen.dart
// إتمام التوصيل — يؤكّد السائق تسليم الطلب فيُحدّث في الـ API وتُضاف عمولته.
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../services/api_service.dart';
import '../services/session.dart';

class CompleteDeliveryScreen extends StatefulWidget {
  const CompleteDeliveryScreen({super.key});
  @override
  State<CompleteDeliveryScreen> createState() => _CompleteDeliveryScreenState();
}

class _CompleteDeliveryScreenState extends State<CompleteDeliveryScreen> {
  bool _done = false;
  String _msg = '';

  Future<void> _complete() async {
    final id = ModalRoute.of(context)?.settings.arguments;
    final orderId = int.tryParse(id?.toString() ?? '');
    if (orderId == null || Session.driverId == null) return;
    try {
      final res = await ApiService.completeOrder(orderId, Session.driverId!);
      setState(() {
        _done = true;
        _msg = 'تم التسليم — عمولتك ${res['commission']} ل.س';
      });
    } catch (_) {
      setState(() => _msg = 'تعذّر إتمام التوصيل');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.surfaceContainer,
        appBar: AppBar(
          title: const Text('إتمام التوصيل'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(_done ? Icons.check_circle : Icons.delivery_dining,
                    size: 80,
                    color: _done ? const Color(0xFF10B981) : AppColors.primary),
                const SizedBox(height: 16),
                Text(_msg.isEmpty ? 'هل سلّمت الطلب للزبون؟' : _msg,
                    style: AppTypography.titleMedium, textAlign: TextAlign.center),
                const SizedBox(height: 24),
                if (!_done)
                  ElevatedButton(
                    onPressed: _complete,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 56),
                    ),
                    child: const Text('تأكيد التسليم'),
                  )
                else
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                        context, '/driver-home', (r) => false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryFixed,
                      foregroundColor: AppColors.onPrimaryFixed,
                      minimumSize: const Size(double.infinity, 56),
                    ),
                    child: const Text('العودة للطلبات'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
