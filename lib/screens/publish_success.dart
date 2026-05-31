// lib/screens/publish_success.dart
// شاشة تأكيد نشر العرض — تعود للتاجر بعد إضافة عرض جديد.
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

class PublishSuccessScreen extends StatelessWidget {
  const PublishSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.surfaceContainer,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 56,
                  backgroundColor: const Color(0xFF10B981).withOpacity(0.15),
                  child: const Icon(Icons.check_circle,
                      size: 72, color: Color(0xFF10B981)),
                ),
                const SizedBox(height: 24),
                Text('تم نشر عرضك بنجاح!', style: AppTypography.headlineMedium),
                const SizedBox(height: 8),
                Text('أصبح عرضك ظاهراً الآن لكل الزبائن',
                    style: AppTypography.bodyMedium, textAlign: TextAlign.center),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context, '/merchant-orders', (r) => false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryFixed,
                    foregroundColor: AppColors.onPrimaryFixed,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text('العودة للوحة التحكم'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
