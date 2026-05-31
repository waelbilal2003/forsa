import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/session.dart';

class OfferDetailsScreen extends StatefulWidget {
  const OfferDetailsScreen({super.key});

  @override
  State<OfferDetailsScreen> createState() => _OfferDetailsScreenState();
}

class _OfferDetailsScreenState extends State<OfferDetailsScreen> {
  Map<String, dynamic>? _offer;
  bool _loading = true;
  bool _loadedOnce = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loadedOnce) return;
    _loadedOnce = true;
    final id = ModalRoute.of(context)?.settings.arguments;
    _load(id);
  }

  Future<void> _load(dynamic id) async {
    final offerId = int.tryParse(id?.toString() ?? '');
    if (offerId == null) {
      setState(() => _loading = false);
      return;
    }
    try {
      final data = await ApiService.getOffer(offerId);
      setState(() => _offer = data);
    } catch (_) {
      _snack('تعذّر تحميل تفاصيل العرض');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _addToCart() async {
    if (Session.userId == null) {
      _snack('سجّل الدخول كزبون أولاً');
      return;
    }
    final productId = int.tryParse(_offer?['product_id'].toString() ?? '');
    if (productId == null) return;
    try {
      await ApiService.addToCart(Session.userId!, productId);
      _snack('تمت الإضافة إلى السلة');
    } catch (_) {
      _snack('تعذّرت الإضافة');
    }
  }

  void _snack(String m) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(m), behavior: SnackBarBehavior.floating));

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('تفاصيل العرض'),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : _offer == null
                ? const Center(child: Text('العرض غير متاح'))
                : _buildBody(),
        bottomNavigationBar: _offer == null ? null : _buildBottomBar(),
      ),
    );
  }

  Widget _buildBody() {
    final o = _offer!;
    final image = o['image_url']?.toString();
    final newPrice = o['new_price']?.toString() ?? o['original_price']?.toString() ?? '0';
    final oldPrice = o['old_price']?.toString() ?? o['original_price']?.toString() ?? '';

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (image != null && image.startsWith('http'))
              ? Image.network(image,
                  width: double.infinity,
                  height: 240,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _imgPlaceholder())
              : _imgPlaceholder(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(o['title']?.toString() ?? o['product_name']?.toString() ?? '',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                if (o['store_name'] != null)
                  Text('من: ${o['store_name']}',
                      style: const TextStyle(color: Color(0xFF585C61))),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text('$newPrice ل.س',
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF9B3F00))),
                    const SizedBox(width: 12),
                    if (oldPrice.isNotEmpty && oldPrice != newPrice)
                      Text('$oldPrice ل.س',
                          style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                              fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('الوصف',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                Text(
                  o['description']?.toString() ??
                      o['product_description']?.toString() ??
                      'لا يوجد وصف لهذا العرض.',
                  style: const TextStyle(color: Color(0xFF585C61), height: 1.6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: _addToCart,
          icon: const Icon(Icons.add_shopping_cart),
          label: const Text('أضف إلى السلة',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF7A2C),
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
      ),
    );
  }

  Widget _imgPlaceholder() => Container(
        width: double.infinity,
        height: 240,
        color: const Color(0xFFEDF1F7),
        child: const Icon(Icons.local_offer, size: 60, color: Color(0xFF9B3F00)),
      );
}
