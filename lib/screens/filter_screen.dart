import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  double _distance = 15;
  int _selectedCategory = 0;
  int _selectedDiscount = 0; // 0: 20%+, 1: 50%+
  int _selectedSort = 0; // 0: الأقرب, 1: الأعلى خصماً, 2: الأكثر تقييماً

  final List<String> _categories = ['مطاعم', 'سوبر ماركت', 'صيدليات', 'أزياء'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FC),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('فلترة العروض القريبة'),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _distance = 15;
                _selectedCategory = 0;
                _selectedDiscount = 0;
                _selectedSort = 0;
              });
            },
            child: const Text('إعادة تعيين', style: TextStyle(color: Color(0xFFFF7A2C), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            const Divider(height: 0),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Location Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('موقع البحث', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF585C61), fontSize: 12)),
                        TextButton(
                          onPressed: () {},
                          child: const Text('تغيير', style: TextStyle(color: Color(0xFFFF7A2C), fontSize: 12)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuCl8p8nZ0W-QBuMU2YEBc2nTw3P-Yk0ZXqI83jZGaTD_K8yWQrHdHle03oiBrF_ZYQpj51Knxm8Ly4sAXZToIAHtTn4vbR5y30ajwr_z3cgqk4heVqFfXDRk97T2FD_qSXf9oW1GKKfCpC-AC4FI6wLFcXh_G_XM9HXY9hAOO_uSsmFvvMd8hqfX7M2oRjTM6ztzg6uVnNdKhmFIw4PhSYFgm3jAVjJjrXG3wjd_Fp8wuI1GXG3-laalxsCISwtC00BRKc2ME_NJvB7',
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.location_on, size: 16, color: Color(0xFFFF7A2C)),
                                SizedBox(width: 6),
                                Text('دمشق، حي المزة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Distance Filter
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('نطاق المسافة', style: TextStyle(fontWeight: FontWeight.bold)),
                              Row(
                                children: [
                                  Text('${_distance.toInt()}', style: GoogleFonts.tajawal(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFFFF7A2C))),
                                  const Text(' كم', style: TextStyle(fontSize: 12, color: Color(0xFFFF7A2C))),
                                ],
                              ),
                            ],
                          ),
                          Slider(
                            value: _distance,
                            min: 1,
                            max: 20,
                            activeColor: const Color(0xFFFF7A2C),
                            inactiveColor: const Color(0xFFD8DDE5),
                            onChanged: (value) {
                              setState(() => _distance = value);
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('1 كم', style: TextStyle(fontSize: 10, color: Color(0xFF73777C))),
                              const Text('20 كم', style: TextStyle(fontSize: 10, color: Color(0xFF73777C))),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Categories
                    const Text('التصنيفات', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 60,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final isSelected = _selectedCategory == index;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedCategory = index),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFFFF7A2C) : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: isSelected ? null : Border.all(color: const Color(0xFFD8DDE5)),
                                boxShadow: isSelected ? [BoxShadow(color: const Color(0xFFFF7A2C).withOpacity(0.2), blurRadius: 8)] : null,
                              ),
                              child: Center(
                                child: Text(
                                  _categories[index],
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : const Color(0xFF585C61),
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Discount Range
                    const Text('الحد الأدنى للخصم', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDiscountCard('20% +', 'خصم متوسط', 0),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildDiscountCard('50% +', 'خصومات كبرى', 1),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Sort Options
                    const Text('الترتيب حسب', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDF1F7),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _buildSortOption('الأقرب', Icons.near_me, 0),
                          _buildSortOption('الأعلى خصماً', Icons.trending_up, 1),
                          _buildSortOption('الأكثر تقييماً', Icons.star, 2),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, -4)),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF7A2C),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('عرض العروض (12)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_back),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDiscountCard(String percentage, String label, int index) {
    final isSelected = _selectedDiscount == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedDiscount = index),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? const Color(0xFFFDD400) : Colors.transparent, width: 2),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(percentage, style: GoogleFonts.tajawal(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF6D5A00))),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF73777C))),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String title, IconData icon, int index) {
    final isSelected = _selectedSort == index;
    return InkWell(
      onTap: () => setState(() => _selectedSort = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFA2AAFF).withOpacity(0.2) : const Color(0xFFD8DDE5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 18, color: isSelected ? const Color(0xFF4953AC) : const Color(0xFF585C61)),
                ),
                const SizedBox(width: 12),
                Text(title, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
              ],
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? const Color(0xFFFF7A2C) : const Color(0xFF73777C),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}