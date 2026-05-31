// lib/screens/order_tracking_screen.dart
// تتبّع التوصيل من جهة السائق — عرض حالة الطلب الحالي.
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderId = ModalRoute.of(context)?.settings.arguments;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.surfaceContainer,
        appBar: AppBar(
          title: const Text('تتبّع التوصيل'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.local_shipping, size: 80, color: AppColors.primary),
              const SizedBox(height: 16),
              Text('جارٍ توصيل الطلب${orderId != null ? ' #$orderId' : ''}',
                  style: AppTypography.titleMedium),
              const SizedBox(height: 8),
              Text('سيصل الطلب قريباً إلى الزبون',
                  style: AppTypography.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
