import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

class OrderSummaryScreen extends StatelessWidget {
  final List<dynamic> items;
  final double total;
  final double couponDiscount;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const OrderSummaryScreen({
    super.key,
    required this.items,
    required this.total,
    required this.couponDiscount,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.onConfirm,
    required this.onCancel,
  });

  double get finalTotal => total - couponDiscount;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: const Text(
          'ملخص الطلب',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // معلومات الزبون
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('بيانات التوصيل', style: AppTypography.titleMedium),
                      const SizedBox(height: 8),
                      _infoRow(Icons.person, 'الاسم', customerName),
                      _infoRow(Icons.email, 'البريد', customerEmail),
                      _infoRow(Icons.phone, 'رقم الهاتف', customerPhone),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // قائمة المنتجات
                Text('المنتجات', style: AppTypography.titleMedium),
                const SizedBox(height: 8),
                ...items.map((item) => _buildProductItem(item)),
                const Divider(),
                // الإجماليات
                _summaryRow('سعر المنتجات', '${total.toStringAsFixed(0)} ل.س'),
                if (couponDiscount > 0)
                  _summaryRow('الخصم', '-${couponDiscount.toStringAsFixed(0)} ل.س',
                      color: Colors.green),
                _summaryRow('سعر التوصيل', '5,000 ل.س'),
                const Divider(),
                _summaryRow('الإجمالي النهائي', '${finalTotal.toStringAsFixed(0)} ل.س',
                    bold: true, color: const Color(0xFF9B3F00)),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: onCancel,
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: onConfirm,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF7A2C),
              foregroundColor: Colors.black,
            ),
            child: const Text('تأكيد الطلب'),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.onSurfaceVariant),
          const SizedBox(width: 8),
          Text('$label: ', style: AppTypography.bodySmall),
          Expanded(
            child: Text(value.isEmpty ? 'غير محدد' : value,
                style: AppTypography.bodySmall,
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(dynamic item) {
    final name = item['name']?.toString() ?? 'منتج';
    final qty = item['quantity']?.toString() ?? '1';
    final price = double.tryParse(item['price']?.toString() ?? '0') ?? 0;
    final storeName = item['store_name']?.toString() ?? 'متجر';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTypography.bodyMedium),
                Text(storeName, style: AppTypography.bodySmall.copyWith(
                  color: Colors.grey,
                )),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text('×$qty', textAlign: TextAlign.center),
          ),
          Expanded(
            flex: 1,
            child: Text('${(price * double.parse(qty)).toStringAsFixed(0)} ل.س',
                textAlign: TextAlign.end,
                style: AppTypography.bodyMedium),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool bold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
          Text(value,
              style: TextStyle(
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                  color: color)),
        ],
      ),
    );
  }
}