// lib/screens/orders_screen.dart
//
// طلبات الزبون — تُحمّل طلباته الفعلية من الـ API مع حالاتها.
// الضغط على طلب يفتح شاشة تتبّعه.

import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav.dart';
import '../services/api_service.dart';
import '../services/session.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<dynamic> _orders = [];
  bool _loading = true;

  static const _statusAr = {
    'pending': 'قيد الانتظار',
    'confirmed': 'مؤكّد',
    'shipped': 'في الطريق',
    'delivered': 'تم التسليم',
  };
  static const _statusColor = {
    'pending': Color(0xFFF59E0B),
    'confirmed': Color(0xFF3B82F6),
    'shipped': Color(0xFF8B5CF6),
    'delivered': Color(0xFF10B981),
  };

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (Session.userId == null) {
      setState(() => _loading = false);
      return;
    }
    setState(() => _loading = true);
    try {
      final data = await ApiService.getCustomerOrders(Session.userId!);
      setState(() => _orders = data);
    } catch (_) {
      // تجاهل بصمت مع إظهار قائمة فارغة
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6FC),
        appBar: AppBar(
          title: const Text('طلباتي'),
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
          ),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : _orders.isEmpty
                ? const Center(child: Text('لا توجد طلبات بعد'))
                : RefreshIndicator(
                    onRefresh: _load,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _orders.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) => _buildOrderCard(_orders[i]),
                    ),
                  ),
        bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
      ),
    );
  }

  Widget _buildOrderCard(dynamic order) {
    final status = order['status']?.toString() ?? 'pending';
    final total = order['total_price']?.toString() ?? '0';
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/track-order',
          arguments: order['id']),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Color(0xFFEDF1F7),
              child: Icon(Icons.receipt_long, color: Color(0xFF9B3F00)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('طلب رقم #${order['id']}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('$total ل.س',
                      style: const TextStyle(color: Color(0xFF585C61))),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: (_statusColor[status] ?? Colors.grey).withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(_statusAr[status] ?? status,
                  style: TextStyle(
                      color: _statusColor[status] ?? Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}
