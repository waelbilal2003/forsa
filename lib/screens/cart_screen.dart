import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav.dart';
import '../services/api_service.dart';
import '../services/session.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<dynamic> _items = [];
  double _total = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCart();
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
      });
    } catch (_) {
      _snack('تعذّر تحميل السلة');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _changeQty(int itemId, int newQty) async {
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

  Future<void> _checkout() async {
    if (Session.userId == null) return;
    if (_items.isEmpty) {
      _snack('السلة فارغة');
      return;
    }

    // اطلب عنوان التوصيل ورقم التواصل والمسافة قبل تأكيد الطلب
    final addressCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final distanceCtrl = TextEditingController();
    const double pricePerKm = 10000; // كل 1 كم = 10000 ل.س
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: StatefulBuilder(
          builder: (ctx, setLocal) {
            final dist = double.tryParse(distanceCtrl.text.trim()) ?? 0;
            final deliveryPrice = dist * pricePerKm;
            final eta = dist > 0 ? (dist * 3).ceil() + 5 : 0;
            final productsTotal = _total;
            return AlertDialog(
              title: const Text('بيانات التوصيل'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: addressCtrl,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'عنوان التوصيل',
                        hintText: 'الحي، الشارع، رقم المبنى...',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: phoneCtrl,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'رقم التواصل',
                        hintText: '05xxxxxxxx',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: distanceCtrl,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (_) => setLocal(() {}),
                      decoration: const InputDecoration(
                        labelText: 'المسافة (كم)',
                        hintText: 'مثال: 4.5',
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    _summaryRow('سعر المنتجات',
                        '${productsTotal.toStringAsFixed(0)} ل.س'),
                    _summaryRow('سعر التوصيل',
                        '${deliveryPrice.toStringAsFixed(0)} ل.س'),
                    _summaryRow('الإجمالي النهائي',
                        '${(productsTotal + deliveryPrice).toStringAsFixed(0)} ل.س',
                        bold: true),
                    if (eta > 0)
                      _summaryRow('مدة الوصول المتوقعة', '$eta دقيقة'),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('إلغاء'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (addressCtrl.text.trim().isEmpty ||
                        phoneCtrl.text.trim().isEmpty) {
                      return;
                    }
                    Navigator.pop(ctx, true);
                  },
                  child: const Text('تأكيد الطلب'),
                ),
              ],
            );
          },
        ),
      ),
    );

    if (confirmed != true) return;

    final distanceKm = double.tryParse(distanceCtrl.text.trim()) ?? 0;
    try {
      await ApiService.checkout(
        Session.userId!,
        deliveryAddress: addressCtrl.text.trim(),
        contactPhone: phoneCtrl.text.trim(),
        distanceKm: distanceKm,
      );
      if (!mounted) return;
      _snack('تم تأكيد طلبك بنجاح');
      _loadCart();
      Navigator.pushNamed(context, '/orders');
    } catch (e) {
      _snack(e is ApiException ? e.message : 'تعذّر إتمام الطلب');
    }
  }

  Widget _summaryRow(String label, String value, {bool bold = false}) {
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
                  color: bold ? const Color(0xFF9B3F00) : null)),
        ],
      ),
    );
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
              icon: const Icon(Icons.notifications_none,
                  color: Color(0xFFFF6D00)),
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
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, i) =>
                                _buildCartItem(_items[i]),
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
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('الإجمالي',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text('${_total.toStringAsFixed(0)} ل.س',
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
