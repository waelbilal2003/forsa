import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int _selectedTab = 0; // 0: جارية, 1: سابقة

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FC),
      appBar: AppBar(
        title: const Text('طلباتي'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {},
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            // Tabs
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDF1F7),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    _buildTabButton('طلبات جارية', 0),
                    const SizedBox(width: 8),
                    _buildTabButton('طلبات سابقة', 1),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    if (_selectedTab == 0) ...[
                      _buildActiveOrderCard(
                        orderNumber: '#SP-9921',
                        status: 'جاري التوصيل',
                        statusColor: const Color(0xFFFF7A2C),
                        bgColor: const Color(0xFFFFF0EA),
                        date: '12 أكتوبر, 04:30 م',
                        total: '145.50 ر.س',
                        items: 4,
                        imageUrls: [
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuCb-ctz4DD6S86zHu8hifdbRZO8YGOQkXzGqFK0vZr4yK7OyUmy-1HBsyT2dC6WQKm6StzuGHu7AMuxKBEXZaEYGjG4Q9pl4JcFuraGsTdCqX2mzYHwI2n-qPFsuToSZ7PNIgsjqIflW1dShe4i3HQ4SL1F2NjkBTk0OF8TMRqm9cLTP4AJevgH-sDbzuEiMHrPJkwGSa9WTmtaJGtVgpkBWhm9TvgtKwIKc41N1RDjITGW489JbRiBzNW31lCO2z9EcYhxqWYplsab',
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuBTk_r8beQ2l5pjVriLTYoyyUMY_Y8Rkf8wJh4ICGqFKuHy0iALSNM5yz094HW_Z5ZUsOQ7NAiFO1fLY-ancFfVlASjYzZj8lKoGkzKAwq67W9kxw6qaW8hoPNHuvbTR83dwj7EImNDR9z1-z88f1A0klylpnafIkMaueGFJ4vAFG6Yy8Uu8Z_yCUYkG_YvbwgyqHBU8d2QfUl0sXQ4RUktB72kM84zc_Q5ZmzLwpd3aLOmnA4Of-qbci0CXZBAs2u382-YrJsMrLi3',
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildActiveOrderCard(
                        orderNumber: '#SP-9844',
                        status: 'يتم التجهيز',
                        statusColor: const Color(0xFF6D5A00),
                        bgColor: const Color(0xFFFFFBEB),
                        date: '12 أكتوبر, 05:15 م',
                        total: '89.00 ر.س',
                        items: 2,
                        imageUrls: [
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuAk9E3NNOMIxWF9RRFqcj83Gk-Y6lytI1dXCdlEOKYaJCo7O7PlIaOQtnTC_eZyn3eQVO_qtkuljSUFJC9LQq5eP-33vq45dhekAHbFrxBW6WDiwDdf6LVpHzhmq-mv4FEs04cwsCeGMSlMSK7L9jTFLLcs87Eo64GtiPKrOg0Bi8P9lBA2ecCXa3JUOc8-czoNqJ3e-uaXyancu8VRB3rwcuaTj_ZUErwDvHc0fOr_6m50j3YLzzty9naVbaQRGPIjwFFF3qINwb5a',
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuCusonNVPaFaIKIapGtvhChT_SkEOwm1MrfF6UJM3M0GfRoQkNrX1l3bH7b6q9MdXb7qFS-ecji3nHus-2efK5Trmq5RcwzMsM73fYN8cTK2Fnjv9b9AKvg3ty_ErskfUMLtW5cjxu0Ry0cZnT8XK0Z7z38W8yRv07KorFqEgPFFBnjaXaBc-ysRKOuwqnOyDf27LO6yvKQjSE6Z_VeWtOKPxGw8L-VOqIgPrjCO3FwrsoOh5NcG1qi8ByerWJDTMt_uJDAOBZSbU6e',
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildSuggestionsSection(),
                    ] else ...[
                      _buildPastOrderCard(
                        orderNumber: '#SP-9502',
                        status: 'تم التوصيل',
                        date: '9 أكتوبر, 2023',
                        total: '240.00 ر.س',
                        imageUrl:
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuAr1JIBs7nxoEM0nOqhbMTB5U6mJZ_m2J0d4xCcMXVt6AO1-F9qJP7iSZuIR45PZiyYuJpiUm_ilZcd2h7izPCD5puv4i3nRpfWxXo3bSBW-AtDvWFS1ZT_VcMGKY_8XKxKmxAFfnBhzBXohkWdpNrcYV9BXoKK3lbe048t7doS2Lf4L8GpmOzEOJ80Ah1t0ECz1ogNAri-afUmR0t6sLrO5wmNV8IbUXOQiR1StAOxVM9YpgiSqje8-MKiHzu0kOQX3O0RZh19ExrT',
                      ),
                      const SizedBox(height: 12),
                      _buildPastOrderCard(
                        orderNumber: '#SP-9421',
                        status: 'تم التوصيل',
                        date: '5 أكتوبر, 2023',
                        total: '520.00 ر.س',
                        imageUrl:
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuDP_1pl4gLMgrbfdKZrRMCiaLX-Rj54FQoE1D1_1OXwiGrPIYLMpGh6USOm5Tgcs0kqs5ZrYDs82DsAsVTcQsQpQ8unYVUdsSwGCr90BMkLJnacBsyf3pbeHZWnkIz3aJhDIdQbQ5a7Shfq598AALTf-8M3Bf5Go5rnkasIoZcg2AAYC52yB4JhSSvdEM5dw1IALWQauwNR5-V04rqvpALesKN2za1Sd_5WDXBR9x8X74JVpBpgWuB0gFzF74ZPS8kXMNaJytF4S7oi',
                      ),
                    ],
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
    );
  }

  Widget _buildTabButton(String title, int index) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.04), blurRadius: 4)
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? const Color(0xFF9B3F00)
                    : const Color(0xFF585C61),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveOrderCard({
    required String orderNumber,
    required String status,
    required Color statusColor,
    required Color bgColor,
    required String date,
    required String total,
    required int items,
    required List<String> imageUrls,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20),
        ],
        border: Border(right: BorderSide(color: statusColor, width: 4)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('رقم الطلب',
                        style:
                            TextStyle(fontSize: 12, color: Color(0xFF585C61))),
                    Text(orderNumber,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(status,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: statusColor)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                // Product Images - تم إزالة الـ margin السالب
                Row(
                  children: [
                    for (int i = 0; i < imageUrls.length && i < 2; i++)
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(imageUrls[i], fit: BoxFit.cover),
                        ),
                      ),
                    if (items > 2)
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDD400),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Center(
                          child: Text('+${items - 2}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                Container(width: 1, height: 32, color: const Color(0xFFD8DDE5)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('تاريخ الطلب',
                        style:
                            TextStyle(fontSize: 10, color: Color(0xFF585C61))),
                    Text(date,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('الإجمالي',
                        style:
                            TextStyle(fontSize: 12, color: Color(0xFF585C61))),
                    Text(total,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF7A2C))),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/track-order');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF7A2C),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Row(
                    children: [
                      Text('تتبع الطلب',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(width: 4),
                      Icon(Icons.map, size: 18),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPastOrderCard({
    required String orderNumber,
    required String status,
    required String date,
    required String total,
    required String imageUrl,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD8DDE5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(imageUrl,
                  width: 64, height: 64, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(orderNumber,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD8DDE5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child:
                            Text(status, style: const TextStyle(fontSize: 10)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(date,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF585C61))),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(total,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF9B3F00)),
                        child: const Row(
                          children: [
                            Text('إعادة طلب',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(width: 4),
                            Icon(Icons.refresh, size: 14),
                          ],
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
    );
  }

  Widget _buildSuggestionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('اقتراحات لك',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFA2AAFF).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.loyalty,
                        color: Color(0xFF4953AC), size: 32),
                    const SizedBox(height: 32),
                    const Text('خصم 20% على طلبك القادم',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const Text('استخدم كود: SOOQ20',
                        style: TextStyle(fontSize: 10)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDD400).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.star, color: Color(0xFF6D5A00), size: 32),
                    const SizedBox(height: 32),
                    const Text('متجر الأسبوع',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const Text('أسواق المزرعة الحديثة',
                        style: TextStyle(fontSize: 10)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
