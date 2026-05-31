import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../services/api_service.dart';
import '../services/session.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  Map<String, dynamic>? _wallet;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (Session.driverId == null) {
      setState(() => _loading = false);
      return;
    }
    try {
      final data = await ApiService.getDriverWallet(Session.driverId!);
      setState(() => _wallet = data);
    } catch (_) {
      // فارغ عند الخطأ
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final balance = _wallet?['balance']?.toString() ?? '0';
    final delivered = _wallet?['delivered_count']?.toString() ?? '0';
    final earnings = _wallet?['total_earnings']?.toString() ?? '0';

    return _loading
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: _load,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Color(0xFFFF7A2C), Color(0xFF9B3F00)]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('الرصيد الحالي',
                          style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 8),
                      Text('$balance ل.س',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 34,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _statCard(
                          'عدد التوصيلات', delivered, Icons.local_shipping),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _statCard(
                          'إجمالي الأرباح', '$earnings ل.س', Icons.payments),
                    ),
                  ],
                ),
              ],
            ),
          );
  }

  Widget _statCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(height: 8),
          Text(value, style: AppTypography.titleMedium),
          const SizedBox(height: 4),
          Text(label, style: AppTypography.bodySmall),
        ],
      ),
    );
  }
}
