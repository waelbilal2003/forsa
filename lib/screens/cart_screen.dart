import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav.dart';
import '../services/api_service.dart';
import '../services/session.dart';
import 'payment_screen.dart';
import 'order_summary_screen.dart'; // ✅ شاشة ملخص الطلب الجديدة

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<dynamic> _items = [];
  double _total = 0;
  bool _loading = true;

  // متغيرات كود الخصم
  final TextEditingController _couponController = TextEditingController();
  double _couponDiscount = 0;
  String _appliedCouponCode = '';

  // تخزين الكميات المتاحة في المخزون
  Map<int, int> _stockAvailability = {};

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  Future<void> _loadCart() async {
    if (Session.userId == null) {
      setState(() => _loading = false);
      return;
    }
    setState(() => _loading = true);
    try {
      final data = await ApiService.getCart(Session.userId!);
      setState(() {
        _items = data['items'] ?? [];
        _total = double.tryParse(data['total'].toString()) ?? 0;
        _couponDiscount = 0;
        _appliedCouponCode = '';
        _couponController.clear();
      });
      await _loadStockAvailability();
    } catch (_) {
      _snack('تعذّر تحميل السلة');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadStockAvailability() async {
    _stockAvailability.clear();
    for (var item in _items) {
      final productId = int.tryParse(item['product_id'].toString()) ?? 0;
      if (productId > 0) {
        try {
          final availability = await ApiService.checkProductAvailability(productId);
          final available = int.tryParse(availability['available_quantity'].toString()) ?? 0;
          _stockAvailability[productId] = available;
        } catch (_) {}
      }
    }
  }

  Future<bool> _checkAvailability(int productId, int requestedQty) async {
    try {
      final availability = await ApiService.checkProductAvailability(productId);
      final available = int.tryParse(availability['available_quantity'].toString()) ?? 0;
      if (requestedQty > available) {
        _snack('الكمية المطلوبة ($requestedQty) غير متوفرة، المتاح: $available');
        return false;
      }
      return true;
    } catch (_) {
      _snack('تعذّر التحقق من توفر المنتج');
      return false;
    }
  }

  Future<void> _changeQty(int itemId, int newQty) async {
    if (newQty < 1) {
      _snack('الكمية يجب أن تكون 1 على الأقل');
      return;
    }

    final item = _items.firstWhere(
      (i) => int.tryParse(i['id'].toString()) == itemId,
      orElse: () => {},
    );
    if (item.isEmpty) return;

    final productId = int.tryParse(item['product_id'].toString()) ?? 0;
    if (productId == 0) {
      _snack('خطأ في بيانات المنتج');
      return;
    }

    final isAvailable = await _checkAvailability(productId, newQty);
    if (!isAvailable) return;

    try {
      await ApiService.updateCartItem(itemId, newQty);
      _loadCart();
    } catch (_) {
      _snack('تعذّر تعديل الكمية');
    }
  }

  Future<void> _remove(int itemId) async {
    try {
      await ApiService.removeCartItem(itemId);
      _loadCart();
    } catch (_) {
      _snack('تعذّر الحذف');
    }
  }

  Future<void> _applyCoupon() async {
    final code = _couponController.text.trim();
    if (code.isEmpty) {
      _snack('الرجاء إدخال كود الخصم');
      return;
    }

    if (_appliedCouponCode == code) {
      _snack('هذا الكود مطبق بالفعل');
      return;
    }

    setState(() => _loading = true);
    try {
      final result = await ApiService.applyCoupon(code, _total);
      final newTotal = double.tryParse(result['new_total']?.toString() ?? '') ?? _total;
      final discount = double.tryParse(result['discount']?.toString() ?? '') ?? 0;

      setState(() {
        _total = newTotal;
        _couponDiscount = discount;
        _appliedCouponCode = code;
      });
      _snack('تم تطبيق الخصم بنجاح (${discount.toStringAsFixed(0)} ل.س)');
    } catch (e) {
      _snack(e is ApiException ? e.message : 'كود الخصم غير صالح');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _removeCoupon() {
    setState(() {
      _couponDiscount = 0;
      _appliedCouponCode = '';
      _couponController.clear();
    });
    _loadCart();
    _snack('تم إلغاء كود الخصم');
  }

  Future<bool> _validateAllItemsAvailability() async {
    for (var item in _items) {
      final productId = int.tryParse(item['product_id'].toString()) ?? 0;
      final qty = int.tryParse(item['quantity'].toString()) ?? 0;
      if (productId > 0 && qty > 0) {
        final isAvailable = await _checkAvailability(productId, qty);
        if (!isAvailable) return false;
      }
    }
    return true;
  }

  // ✅ دالة إتمام الطلب (بدون نافذة بيانات التوصيل)
  Future<void> _checkout() async {
    if (Session.userId == null) return;
    if (_items.isEmpty) {
      _snack('السلة فارغة');
      return;
    }

    setState(() => _loading = true);
    final allAvailable = await _validateAllItemsAvailability();
    setState(() => _loading = false);
    if (!allAvailable) {
      _snack('بعض المنتجات غير متوفرة بالكمية المطلوبة، يرجى تحديث السلة');
      return;
    }

    // ✅ جلب بيانات الزبون من الجلسة
    final customerName = Session.name ?? 'زبون';
    final customerEmail = Session.email ?? '';
    final customerPhone = Session.phone ?? '';

    // ✅ عرض ملخص الطلب
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => OrderSummaryScreen(
        items: _items,
        total: _total,
        couponDiscount: _couponDiscount,
        customerName: customerName,
        customerEmail: customerEmail,
        customerPhone: customerPhone,
        onConfirm: () => Navigator.pop(ctx, true),
        onCancel: () => Navigator.pop(ctx, false),
      ),
    );

    if (confirmed != true) return;

    setState(() => _loading = true);
    try {
      final result = await ApiService.checkout(
        Session.userId!,
        deliveryAddress: Session.address ?? '',
        contactPhone: Session.phone ?? '',
        distanceKm: 5.0, // ✅ يمكن حسابها من الموقع الحقيقي
      );
      if (!mounted) return;
      final orderId = result['order_id'] ?? 0;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentScreen(
            total: _total,
            orderId: orderId is int ? orderId : 0,
          ),
        ),
      ).then((_) => _loadCart());

      _snack('تم إنشاء طلبك بنجاح');
    } catch (e) {
      _snack(e is ApiException ? e.message : 'تعذّر إتمام الطلب');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _snack(String m) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(m), behavior: SnackBarBehavior.floating));

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6FC),
        appBar: AppBar(
          title: const Text('سلة المشتريات'),
          centerTitle: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Color(0xFFFF6D00)),
              onPressed: () {},
            ),
          ],
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: _items.isEmpty
                        ? const Center(child: Text('سلتك فارغة'))
                        : ListView.separated(
                            padding: const EdgeInsets.all(16),
                            itemCount: _items.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, i) => _buildCartItem(_items[i]),
                          ),
                  ),
                  if (_items.isNotEmpty) _buildSummaryBar(),
                ],
              ),
        bottomNavigationBar: const CustomBottomNav(currentIndex: 2),
      ),
    );
  }

  Widget _buildCartItem(dynamic item) {
    final id = int.tryParse(item['id'].toString()) ?? 0;
    final qty = int.tryParse(item['quantity'].toString()) ?? 1;
    final price = double.tryParse(item['price'].toString()) ?? 0;
    final image = item['image_url']?.toString();
    final productId = int.tryParse(item['product_id'].toString()) ?? 0;
    final availableStock = _stockAvailability[productId] ?? -1;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: (image != null && image.startsWith('http'))
                ? Image.network(image,
                    width: 70, height: 70, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _imgPlaceholder())
                : _imgPlaceholder(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['name']?.toString() ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text('${price.toStringAsFixed(0)} ل.س',
                    style: const TextStyle(
                        color: Color(0xFF9B3F00), fontWeight: FontWeight.bold)),
                if (availableStock >= 0)
                  Text('متاح: $availableStock',
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => _changeQty(id, qty - 1),
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text('$qty', style: const TextStyle(fontWeight: FontWeight.bold)),
              IconButton(
                onPressed: () => _changeQty(id, qty + 1),
                icon: const Icon(Icons.add_circle_outline),
              ),
              IconButton(
                onPressed: () => _remove(id),
                icon: const Icon(Icons.delete_outline, color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryBar() {
    final displayTotal = _total - _couponDiscount;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _couponController,
                  enabled: _appliedCouponCode.isEmpty,
                  decoration: InputDecoration(
                    hintText: _appliedCouponCode.isNotEmpty
                        ? 'مطبّق: $_appliedCouponCode'
                        : 'كود الخصم',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (_appliedCouponCode.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: _removeCoupon,
                  tooltip: 'إلغاء الكود',
                ),
              if (_appliedCouponCode.isEmpty)
                ElevatedButton(
                  onPressed: _applyCoupon,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF7A2C),
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('تطبيق'),
                ),
            ],
          ),
          if (_couponDiscount > 0) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('الخصم', style: TextStyle(color: Colors.green)),
                Text('-${_couponDiscount.toStringAsFixed(0)} ل.س',
                    style: const TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('الإجمالي',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text('${displayTotal.toStringAsFixed(0)} ل.س',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF9B3F00))),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _checkout,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF7A2C),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('إتمام الطلب',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imgPlaceholder() => Container(
        width: 70,
        height: 70,
        color: const Color(0xFFEDF1F7),
        child: const Icon(Icons.shopping_bag, color: Color(0xFF9B3F00)),
      );
}