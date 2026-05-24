import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_bottom_nav.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FC),
      appBar: AppBar(
        title: const Text('سلة المشتريات'),
        centerTitle: false,
        actions: [
          IconButton(
            icon:
                const Icon(Icons.notifications_none, color: Color(0xFFFF6D00)),
            onPressed: () {},
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'لديك 3 عروض مميزة تنتظر التأكيد',
                      style: TextStyle(
                          color: const Color(0xFF585C61), fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    // Cart Items
                    _buildCartItem(
                      imageUrl:
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuDP_1pl4gLMgrbfdKZrRMCiaLX-Rj54FQoE1D1_1OXwiGrPIYLMpGh6USOm5Tgcs0kqs5ZrYDs82DsAsVTcQsQpQ8unYVUdsSwGCr90BMkLJnacBsyf3pbeHZWnkIz3aJhDIdQbQ5a7Shfq598AALTf-8M3Bf5Go5rnkasIoZcg2AAYC52yB4JhSSvdEM5dw1IALWQauwNR5-V04rqvpALesKN2za1Sd_5WDXBR9x8X74JVpBpgWuB0gFzF74ZPS8kXMNaJytF4S7oi',
                      title: 'حذاء رياضي الترا بوست',
                      store: 'متجر سبورت لاين',
                      price: 250,
                      originalPrice: 400,
                      discount: 'وفر 35%',
                    ),
                    const SizedBox(height: 12),
                    _buildCartItem(
                      imageUrl:
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuBk-mLl7Ze0oXYdS-Eh2bseFkCo1G51JyKIUVtgY-CN-WynDRe6WUVhhHcstpCXaJcQezOojUWNxL0QffVyPVugKIB7jYhTEkfUXIpCBk3cILGEKkjMCuzqjdn9HMVHmHe33wuQgbMuNfxKfacXCG42AqwwXa31rRXBm0YExzm1dT0Nc4wcwXK7oMrBSeRW5gyGvH35ZilNujqTDvoRDGGIuVNugD1C4NMFSZYRw4AMHeU5ZaNAW14ncU2p-Y_dug8-voTl5zUXoraO',
                      title: 'سماعات رأس لاسلكية',
                      store: 'عالم التكنولوجيا',
                      price: 850,
                      originalPrice: 1200,
                      discount: 'عرض محدود',
                    ),
                    const SizedBox(height: 12),
                    _buildCartItem(
                      imageUrl:
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuCxZ3Uqlvc1DEvXL9_oAqtdHz3mV7m6b_BfPXBEzyeBP-AtQ415TWkLxyRgRI97KLE5mUAgRsafHMv2ste7nH8oC0YCRFgvafgueSl52jPtsQ_nh2P4QWxePQVyhQ1bIzcstDx-tnZGsfe9ia3hY_Y-JqrnI1fzVPYKl8yX3HTmA1f6rzHeOzSQbHhic7gBqkw0IgDoZFyibSHbm0X6FPDO6G8w2vF9ZGofUqXWv0HjrQs-f0OjfVRurfZkx39XZX-I1INFZYNjtSYy',
                      title: 'ساعة كلاسيكية حديثة',
                      store: 'بوتيك الأناقة',
                      price: 420,
                      originalPrice: 550,
                      quantity: 2,
                    ),
                    const SizedBox(height: 20),
                    // Order Summary
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 24),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ملخص الطلب',
                            style: GoogleFonts.tajawal(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          _buildSummaryRow('المجموع الفرعي', '1,940 ريال'),
                          _buildSummaryRow('رسوم التوصيل', '25 ريال'),
                          _buildSummaryRow('خصم العروض', '- 410 ريال',
                              isDiscount: true),
                          const Divider(height: 24),
                          _buildSummaryRow('الإجمالي', '1,555 ريال',
                              isTotal: true),
                          const SizedBox(height: 20),
                          // Promo Code
                          const Text('كود الخصم',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'أدخل الكود هنا',
                                    filled: true,
                                    fillColor: const Color(0xFFEDF1F7),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2B2F33),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                child: const Text('تطبيق'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Checkout Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF6D00),
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('إتمام عملية الشراء',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_back),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'بالضغط على إتمام الشراء، فإنك توافق على شروط وأحكام Editorial Pulse.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 10, color: const Color(0xFF73777C)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 2),
    );
  }

  Widget _buildCartItem({
    required String imageUrl,
    required String title,
    required String store,
    required int price,
    int? originalPrice,
    String? discount,
    int quantity = 1,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          size: 20, color: Color(0xFFB02500)),
                      onPressed: () {},
                    ),
                  ],
                ),
                Text(store,
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF4953AC))),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('$price ريال',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFF6D00))),
                            if (originalPrice != null) ...[
                              const SizedBox(width: 6),
                              Text('$originalPrice ريال',
                                  style: const TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: 12,
                                      color: Color(0xFF73777C))),
                            ],
                          ],
                        ),
                        if (discount != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF6D00).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(discount,
                                style: const TextStyle(
                                    fontSize: 10, color: Color(0xFFFF6D00))),
                          ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove, size: 18),
                          onPressed: () {},
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                        ),
                        Container(
                          width: 32,
                          alignment: Alignment.center,
                          child: Text('$quantity',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, size: 18),
                          onPressed: () {},
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value,
      {bool isDiscount = false, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  color: isDiscount
                      ? const Color(0xFF4CAF50)
                      : const Color(0xFF73777C))),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 20 : 14,
              color: isDiscount
                  ? const Color(0xFF4CAF50)
                  : (isTotal ? const Color(0xFFFF6D00) : null),
            ),
          ),
        ],
      ),
    );
  }
}
