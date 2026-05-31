import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../services/api_service.dart';
import '../services/session.dart';

class OrderReceiptScreen extends StatefulWidget {
  const OrderReceiptScreen({super.key});

  @override
  State<OrderReceiptScreen> createState() => _OrderReceiptScreenState();
}

class _OrderReceiptScreenState extends State<OrderReceiptScreen> {
  Map<String, dynamic>? _order;
  List<dynamic> _items = [];
  bool _loading = true;
  bool _once = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_once) return;
    _once = true;
    _load(ModalRoute.of(context)?.settings.arguments);
  }

  Future<void> _load(dynamic id) async {
    final orderId = int.tryParse(id?.toString() ?? '');
    if (orderId == null) {
      setState(() => _loading = false);
      return;
    }
    try {
      final data = await ApiService.getInvoice(orderId);
      setState(() {
        _order = Map<String, dynamic>.from(data['order'] ?? {});
        _items = data['items'] ?? [];
      });
    } catch (_) {
      // فارغ عند الخطأ
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _snack(String m) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(m), behavior: SnackBarBehavior.floating));

  Future<void> _markDelivered() async {
    final orderId = int.tryParse(_order?['id'].toString() ?? '');
    if (orderId == null || Session.driverId == null) return;
    try {
      final res = await ApiService.completeOrder(orderId, Session.driverId!);
      if (!mounted) return;
      _snack('تم التسليم — عمولتك ${res['commission']} ل.س');
      Navigator.pushNamedAndRemoveUntil(context, '/driver-home', (r) => false);
    } catch (_) {
      _snack('تعذّر إتمام التوصيل');
    }
  }

  Future<void> _falseReport() async {
    final orderId = int.tryParse(_order?['id'].toString() ?? '');
    if (orderId == null || Session.driverId == null) return;

    final reasonCtrl = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('الإبلاغ عن بلاغ كاذب'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                  'سيُرسل البلاغ للإدارة لاتخاذ الإجراء المناسب ضد الزبون حفاظاً على سلامتك.'),
              const SizedBox(height: 12),
              TextField(
                controller: reasonCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'سبب البلاغ',
                  hintText: 'اشرح ما حدث...',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('إرسال البلاغ',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );

    if (confirmed != true) return;

    try {
      await ApiService.sendFalseReport(
          orderId, Session.driverId!, reasonCtrl.text.trim());
      if (!mounted) return;
      _snack('تم إرسال البلاغ للإدارة');
      Navigator.pushNamedAndRemoveUntil(context, '/driver-home', (r) => false);
    } catch (_) {
      _snack('تعذّر إرسال البلاغ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.surfaceContainer,
        appBar: AppBar(
          title: const Text('فاتورة الطلب'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : _order == null
                ? const Center(child: Text('تعذّر تحميل الفاتورة'))
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _invoiceCard(),
                      const SizedBox(height: 16),
                      _actionButtons(),
                    ],
                  ),
      ),
    );
  }

  Widget _invoiceCard() {
    final o = _order!;
    final total = o['total_price']?.toString() ?? '0';
    final discount = o['discount_percentage']?.toString() ?? '0';
    final code = o['discount_code']?.toString();
    final address = o['delivery_address']?.toString() ?? 'غير محدد';
    final phone = o['contact_phone']?.toString() ??
        o['customer_phone']?.toString() ??
        '-';
    final customer = o['customer_name']?.toString() ?? 'الزبون';
    final deliveryPrice = o['delivery_price']?.toString() ?? '0';
    final eta = o['delivery_eta']?.toString();

    return Container(
      padding: const EdgeInsets.all(20),
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
              Text('فاتورة #${o['id']}', style: AppTypography.titleLarge),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('${o['status']}',
                    style: TextStyle(color: AppColors.onPrimaryContainer)),
              ),
            ],
          ),
          const Divider(height: 28),
          _infoRow(Icons.location_on, 'عنوان التوصيل', address),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.person, color: AppColors.onSurfaceVariant, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text('$customer  •  $phone',
                    style: AppTypography.bodyMedium),
              ),
              Icon(Icons.call, color: AppColors.primary),
            ],
          ),
          const Divider(height: 28),
          Text('المنتجات', style: AppTypography.titleMedium),
          const SizedBox(height: 8),
          ..._items.map((it) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text('${it['product_name']} ×${it['quantity']}',
                          style: AppTypography.bodyMedium),
                    ),
                    Text('${it['unit_price']} ل.س',
                        style: AppTypography.bodyMedium),
                  ],
                ),
              )),
          const Divider(height: 28),
          _infoRow(
            Icons.local_offer,
            'كود الحسم',
            (code != null && code.isNotEmpty)
                ? '$code (خصم $discount%)'
                : 'لا يوجد كود حسم',
          ),
          const SizedBox(height: 12),
          _infoRow(Icons.delivery_dining, 'سعر التوصيل', '$deliveryPrice ل.س'),
          if (eta != null) ...[
            const SizedBox(height: 12),
            _infoRow(Icons.schedule, 'مدة الوصول المتوقعة', '$eta دقيقة'),
          ],
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('الإجمالي', style: AppTypography.titleMedium),
                Text('$total ل.س',
                    style: AppTypography.titleLarge
                        .copyWith(color: AppColors.onPrimaryContainer)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.onSurfaceVariant, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTypography.bodySmall),
              const SizedBox(height: 2),
              Text(value, style: AppTypography.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }

  Widget _actionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _markDelivered,
            icon: const Icon(Icons.check_circle),
            label: const Text('تم توصيل الطلب'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _falseReport,
            icon: Icon(Icons.report_problem, color: AppColors.error),
            label: Text('بلاغ كاذب', style: TextStyle(color: AppColors.error)),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.error),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ),
      ],
    );
  }
}
