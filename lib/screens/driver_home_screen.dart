import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../services/api_service.dart';
import '../services/session.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  List<dynamic> _available = [];
  List<dynamic> _mine = [];
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
    setState(() => _loading = true);
    try {
      final data = await ApiService.getDriverOrders(Session.driverId!);
      setState(() {
        _available = data['available'] ?? [];
        _mine = data['mine'] ?? [];
      });
    } catch (_) {
      // فارغ عند الخطأ
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _accept(int orderId) async {
    try {
      await ApiService.acceptOrder(orderId, Session.driverId!);
      _snack('تم قبول الطلب');
      _load();
    } catch (e) {
      _snack(e is ApiException ? e.message : 'تعذّر قبول الطلب');
    }
  }

  Future<void> _complete(int orderId) async {
    try {
      final res = await ApiService.completeOrder(orderId, Session.driverId!);
      _snack('تم التسليم — عمولتك ${res['commission']} ل.س');
      _load();
    } catch (_) {
      _snack('تعذّر إتمام التوصيل');
    }
  }

  void _snack(String m) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(m), behavior: SnackBarBehavior.floating));

  void _logout() {
    Session.clear();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.surfaceContainer,
        appBar: AppBar(
          title: Text('مرحباً ${Session.name ?? 'سائق'}'),
          centerTitle: false,
          actions: [
            IconButton(
              tooltip: 'تسجيل الخروج',
              icon: const Icon(Icons.logout),
              onPressed: _logout,
            ),
          ],
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _load,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text('طلبات متاحة', style: AppTypography.titleLarge),
                    const SizedBox(height: 8),
                    if (_available.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text('لا توجد طلبات متاحة حالياً'),
                      )
                    else
                      ..._available.map((o) => _orderCard(o, isMine: false)),
                    const SizedBox(height: 24),
                    Text('طلباتي الحالية', style: AppTypography.titleLarge),
                    const SizedBox(height: 8),
                    if (_mine.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text('لم تقبل أي طلب بعد'),
                      )
                    else
                      ..._mine.map((o) => _orderCard(o, isMine: true)),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _orderCard(dynamic order, {required bool isMine}) {
    final id = int.tryParse(order['id'].toString()) ?? 0;
    final status = order['status']?.toString() ?? '';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('طلب #$id', style: AppTypography.titleMedium),
          const SizedBox(height: 4),
          Text('الإجمالي: ${order['total_price'] ?? 0} ل.س',
              style: AppTypography.bodyMedium),
          const SizedBox(height: 12),
          if (!isMine)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryFixed,
                    foregroundColor: AppColors.onPrimaryFixed),
                onPressed: () => _accept(id),
                child: const Text('قبول الطلب'),
              ),
            )
          else if (status != 'delivered')
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryFixed,
                    foregroundColor: AppColors.onPrimaryFixed),
                onPressed: () => Navigator.pushNamed(context, '/order-receipt',
                    arguments: id),
                icon: const Icon(Icons.receipt_long),
                label: const Text('عرض الفاتورة والتوصيل'),
              ),
            )
          else
            const Text('✓ تم التسليم',
                style: TextStyle(
                    color: Color(0xFF10B981), fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
