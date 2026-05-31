// lib/screens/home_screen.dart
//
// نفس تصميم الشاشة الرئيسية — لكن العروض الآن تُحمَّل فعلياً من الـ API
// بدل البيانات الثابتة. الضغط على عرض يفتح تفاصيله، وزر + يضيفه للسلة.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_bottom_nav.dart';
import '../services/api_service.dart';
import '../services/session.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _offers = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadOffers();
  }

  Future<void> _loadOffers({String? q}) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final offers = await ApiService.getOffers(query: q);
      if (!mounted) return;
      setState(() => _offers = offers);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = 'تعذّر تحميل العروض');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _addToCart(int productId) async {
    if (Session.userId == null) {
      _snack('سجّل الدخول كزبون أولاً');
      return;
    }
    try {
      await ApiService.addToCart(Session.userId!, productId);
      _snack('تمت الإضافة إلى السلة');
    } catch (e) {
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
          title: const Text('فرصة'),
          actions: [
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.notifications_none)),
          ],
          leading: const CircleAvatar(
            backgroundColor: Color(0xFFEDF1F7),
            child: Icon(Icons.person, color: Color(0xFF9B3F00)),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _loadOffers,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  onSubmitted: (v) =>
                      _loadOffers(q: v.trim().isEmpty ? null : v),
                  decoration: InputDecoration(
                    hintText: 'ابحث عن منتج، مطعم، أو متجر...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28)),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Color(0xFFFF7A2C), Color(0xFF9B3F00)]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('اكتشف العروض القريبة',
                                style: GoogleFonts.tajawal(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            const SizedBox(height: 4),
                            const Text('خصومات تصل إلى 60%',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 14)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(40)),
                        child: const Icon(Icons.near_me, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('عروض خاطفة',
                        style: GoogleFonts.tajawal(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const Text('عرض الكل',
                        style: TextStyle(
                            color: Color(0xFF4953AC),
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                _buildOffersList(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const CustomBottomNav(currentIndex: 0),
      ),
    );
  }

  Widget _buildOffersList() {
    if (_loading) {
      return const SizedBox(
          height: 230, child: Center(child: CircularProgressIndicator()));
    }
    if (_error != null) {
      return SizedBox(
        height: 230,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_error!),
              TextButton(
                  onPressed: () => _loadOffers(),
                  child: const Text('إعادة المحاولة')),
            ],
          ),
        ),
      );
    }
    if (_offers.isEmpty) {
      return const SizedBox(
          height: 230, child: Center(child: Text('لا توجد عروض حالياً')));
    }
    return SizedBox(
      height: 230,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _offers.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final o = _offers[index];
          final offerPrice = o['offer_price']?.toString() ?? '0';
          final oldPrice = o['old_price']?.toString() ?? '';
          final productId = int.tryParse(o['product_id'].toString()) ?? 0;
          final image = o['image_url']?.toString();

          // مدة العرض المتبقية وحالة الكمية
          final endDate = DateTime.tryParse(o['end_date']?.toString() ?? '');
          final stock = int.tryParse(o['stock']?.toString() ?? '');
          final expired = endDate != null && endDate.isBefore(DateTime.now());
          final outOfStock = stock != null && stock <= 0;
          final inactive = expired || outOfStock;
          final durationText = _durationLabel(endDate, expired);

          return GestureDetector(
            onTap: inactive
                ? null
                : () => Navigator.pushNamed(context, '/offer-details',
                    arguments: o['id']),
            child: Opacity(
              opacity: inactive ? 0.55 : 1.0,
              child: Container(
                width: 220,
                decoration: BoxDecoration(
                    color: inactive ? const Color(0xFFF1F1F4) : Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(20)),
                      child: (image != null && image.startsWith('http'))
                          ? Image.network(image,
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _imgPlaceholder())
                          : _imgPlaceholder(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(o['title']?.toString() ?? 'عرض',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text('$offerPrice ل.س',
                                  style: const TextStyle(
                                      color: Color(0xFF9B3F00),
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(width: 8),
                              if (oldPrice.isNotEmpty && oldPrice != offerPrice)
                                Text('$oldPrice ل.س',
                                    style: const TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.grey)),
                              const Spacer(),
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: inactive
                                    ? null
                                    : () => _addToCart(productId),
                                icon: Icon(Icons.add_circle,
                                    color: inactive
                                        ? Colors.grey
                                        : const Color(0xFF9B3F00)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          // مدة العرض / حالة الانتهاء أو نفاذ الكمية
                          Row(
                            children: [
                              Icon(
                                outOfStock
                                    ? Icons.inventory_2_outlined
                                    : (expired
                                        ? Icons.timer_off_outlined
                                        : Icons.schedule),
                                size: 14,
                                color: inactive
                                    ? Colors.grey
                                    : const Color(0xFF585C61),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  outOfStock ? 'تم نفاذ الكمية' : durationText,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: inactive
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: inactive
                                          ? Colors.grey.shade600
                                          : const Color(0xFF585C61)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // نص مدة العرض المتبقية بالأيام/الساعات.
  String _durationLabel(DateTime? endDate, bool expired) {
    if (endDate == null) return 'مدة العرض غير محددة';
    if (expired) return 'انتهى العرض';
    final diff = endDate.difference(DateTime.now());
    if (diff.inDays >= 1) return 'يتبقى ${diff.inDays} يوم';
    if (diff.inHours >= 1) return 'يتبقى ${diff.inHours} ساعة';
    return 'يتبقى ${diff.inMinutes} دقيقة';
  }

  Widget _imgPlaceholder() => Container(
        height: 120,
        width: double.infinity,
        color: const Color(0xFFEDF1F7),
        child:
            const Icon(Icons.local_offer, size: 40, color: Color(0xFF9B3F00)),
      );
}
