import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../services/api_service.dart';
import '../services/session.dart';

class OrdersManagementScreen extends StatefulWidget {
  const OrdersManagementScreen({super.key});

  @override
  State<OrdersManagementScreen> createState() => _OrdersManagementScreenState();
}

class _OrdersManagementScreenState extends State<OrdersManagementScreen> {
  List<dynamic> _orders = [];
  bool _loading = true;

  static const _statusAr = {
    'pending': 'جديد',
    'confirmed': 'مؤكّد',
    'shipped': 'تم الشحن',
    'delivered': 'تم التسليم',
  };

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
    setState(() => _loading = true);
    try {
      final data = await ApiService.getMerchantOrders(Session.storeId!);
      setState(() => _orders = data);
    } catch (_) {
      // قائمة فارغة عند الخطأ
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _setStatus(int orderId, String status) async {
    try {
      await ApiService.updateOrderStatus(orderId, status);
      _snack('تم تحديث حالة الطلب');
      _load();
    } catch (_) {
      _snack('تعذّر التحديث');
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
          title: const Text('إدارة الطلبات'),
          centerTitle: false,
          actions: [
            IconButton(
              tooltip: 'سجل العروض',
              icon: const Icon(Icons.history),
              onPressed: () => Navigator.pushNamed(context, '/offers-history'),
            ),
            IconButton(
              tooltip: 'الإحصائيات',
              icon: const Icon(Icons.bar_chart),
              onPressed: () => Navigator.pushNamed(context, '/offer-stats'),
            ),
            IconButton(
              tooltip: 'تسجيل الخروج',
              icon: const Icon(Icons.logout),
              onPressed: _logout,
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: AppColors.primaryFixed,
          foregroundColor: AppColors.onPrimaryFixed,
          onPressed: () => Navigator.pushNamed(context, '/add-offer'),
          icon: const Icon(Icons.add),
          label: const Text('عرض جديد'),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : _orders.isEmpty
                ? const Center(child: Text('لا توجد طلبات على متجرك بعد'))
                : RefreshIndicator(
                    onRefresh: _load,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _orders.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) => _orderCard(_orders[i]),
                    ),
                  ),
      ),
    );
  }

  Widget _orderCard(dynamic order) {
    final id = int.tryParse(order['id'].toString()) ?? 0;
    final status = order['status']?.toString() ?? 'pending';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('طلب #$id', style: AppTypography.titleMedium),
              Chip(
                label: Text(_statusAr[status] ?? status),
                backgroundColor: AppColors.primaryContainer,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text('الزبون: ${order['customer_name'] ?? 'غير معروف'}',
              style: AppTypography.bodySmall),
          Text('الإجمالي: ${order['total_price'] ?? 0} ل.س',
              style: AppTypography.bodyMedium),
          const SizedBox(height: 12),
          Row(
            children: [
              if (status == 'pending')
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _setStatus(id, 'confirmed'),
                    child: const Text('تأكيد الطلب'),
                  ),
                ),
              if (status == 'confirmed') ...[
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryFixed,
                        foregroundColor: AppColors.onPrimaryFixed),
                    onPressed: () => _setStatus(id, 'shipped'),
                    child: const Text('جاهز للشحن'),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
