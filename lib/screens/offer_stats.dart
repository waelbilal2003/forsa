// lib/screens/offer_stats.dart
//
// إحصائيات متجر التاجر — تُحمّل من الـ API: عدد العروض، النشطة، الطلبات،
// والإيراد المحقّق.

import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../services/api_service.dart';
import '../services/session.dart';

class OfferStatsScreen extends StatefulWidget {
  const OfferStatsScreen({super.key});

  @override
  State<OfferStatsScreen> createState() => _OfferStatsScreenState();
}

class _OfferStatsScreenState extends State<OfferStatsScreen> {
  Map<String, dynamic>? _stats;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (Session.storeId == null) {
      setState(() => _loading = false);
      return;
    }
    try {
      final data = await ApiService.getMerchantStats(Session.storeId!);
      setState(() => _stats = data);
    } catch (_) {
      // فارغ
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.surfaceContainer,
        appBar: AppBar(
          title: const Text('إحصائيات المتجر'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : GridView.count(
                padding: const EdgeInsets.all(16),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
                children: [
                  _card('إجمالي العروض',
                      _stats?['offers_count']?.toString() ?? '0',
                      Icons.local_offer, AppColors.primary),
                  _card('العروض النشطة',
                      _stats?['active_offers']?.toString() ?? '0',
                      Icons.check_circle, const Color(0xFF10B981)),
                  _card('عدد الطلبات',
                      _stats?['orders_count']?.toString() ?? '0',
                      Icons.shopping_bag, AppColors.tertiary),
                  _card('الإيراد',
                      '${_stats?['revenue']?.toString() ?? '0'} ل.س',
                      Icons.payments, const Color(0xFFF59E0B)),
                ],
              ),
      ),
    );
  }

  Widget _card(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
              backgroundColor: color.withOpacity(0.12),
              child: Icon(icon, color: color)),
          const SizedBox(height: 12),
          Text(value, style: AppTypography.headlineMedium),
          const SizedBox(height: 4),
          Text(label, style: AppTypography.bodySmall),
        ],
      ),
    );
  }
}
