import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_bottom_nav.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سوق سبارك'),
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.notifications_none)),
        ],
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFEDF1F7),
          backgroundImage: NetworkImage(
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBS0JH_gt94I7-tsc439KP0IkC_HUpFSdc4OByfe602QQ3Bbq9QO-8kfuNiH7AUTraKswORF18o4HuStLRCdVopqdbOsqMvUAtjAYA4WcRlI2OPxmGFbRFuOVML8cPvxo-IaTRTLFFMi6uE9x-sRek6-GlK9l-Sl5kSELewjEizuTj4F34E4wt6G8nr2c0KB5HoGvlty-rce5nRf9_-PnEXVVqUrnJmaUeWHvM_w8YroL20Rd1IU21euuVCX-XWp6TZgy6Chz7VjVzJ',
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'ابحث عن منتج، مطعم، أو متجر...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(28)),
              ),
            ),
            const SizedBox(height: 20),

            // Hero CTA
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
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/offer-details');
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'اكتشف العروض القريبة',
                            style: GoogleFonts.tajawal(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'خصومات تصل إلى 60%',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      ),
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

            // Flash Sale Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('عروض خاطفة',
                    style: GoogleFonts.tajawal(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const Text('عرض الكل',
                    style: TextStyle(
                        color: Color(0xFF4953AC), fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 230,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  return Container(
                    width: 220,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20)),
                          child: Image.network(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuBf-gvmLAguvSjukZCcG_wLaux86urnVxU-rTcMvnwsbrgkbzgDV1msEdCT6MjcWlDeCk3uEYO-9p-pVJL1WuZAme-Lhl2VvALLiMm__RwgctKwNt_4M39paV8zrVRXfcFmrd05Q6mJlsXQj8EhJhteDWSdOGniu5S6Dw6oiqSjg_ic29HesW5_o1joWlyeDW1qMJsHLovqyYPJnNQMLdQ7OHn8NgogE576uzpIk_20RnKd-3NBnUrd7KYrZFfrkLFqSzBR3-KAisAd',
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('ساعة ذكية',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Row(
                                children: [
                                  const Text('299 ر.س',
                                      style: TextStyle(
                                          color: Color(0xFF9B3F00),
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 8),
                                  const Text('450 ر.س',
                                      style: TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: Colors.grey)),
                                  const Spacer(),
                                  const Icon(Icons.add_circle,
                                      color: Color(0xFF9B3F00)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 0),
    );
  }
}
