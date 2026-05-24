import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrackOrderScreen extends StatelessWidget {
  const TrackOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FC),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('تتبع الطلب'),
        centerTitle: false,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Map Section
              Stack(
                children: [
                  Container(
                    height: 280,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: const Color(0xFFD8DDE5),
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuADm5mFCNmETYa4Ou9CbrNhUEMw9-rcQ6wU0ikqVPmwM0nCoipKPfLR7mJKOqLIVqHvcio7sUuUOeB42S28oBAOY_X56ei55yXmzuiG4gGbvpnZkFt-KGGYmpuyPv4mQ8BrV75Dh0evElnBZDXG10QWgUWbg81ma4jwTRlLOyDI6M2so1yTcAcnl7r9zQBPloMDlxdMkAP4DdH4E_WqgyxqNl_cL_Y3WtbIlePXrKZXFl46IpZGX8r4HaaTXUd3_LMDz_ZLlQeT-tKx',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Store Marker
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4953AC),
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.storefront,
                          color: Colors.white, size: 20),
                    ),
                  ),
                  // Driver Marker (Kinetic)
                  Positioned(
                    top: 120,
                    left: 80,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF7A2C),
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8),
                          ],
                        ),
                        child: const Icon(Icons.motorcycle,
                            color: Colors.white, size: 24),
                      ),
                    ),
                  ),
                  // User Marker
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDD400),
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.person_pin_circle,
                          color: Color(0xFF433700), size: 20),
                    ),
                  ),
                  // Distance Badge
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8),
                        ],
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.schedule,
                              color: Color(0xFFFF7A2C), size: 16),
                          SizedBox(width: 6),
                          Text('8 دقائق متبقية',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Order Status Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.04), blurRadius: 20),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'جاري التوصيل',
                              style: GoogleFonts.tajawal(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFFF7A2C),
                              ),
                            ),
                            const Text('طلبك في طريقه إليك الآن',
                                style: TextStyle(color: Color(0xFF585C61))),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDD400),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text('#SP-9921',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Stepper
                    Row(
                      children: [
                        _buildStep('تأكيد\nالطلب', true, true),
                        Expanded(child: _buildProgressLine(true)),
                        _buildStep('قيد\nالتحضير', true, true),
                        Expanded(child: _buildProgressLine(true)),
                        _buildStep('جاري\nالتوصيل', true, true, isActive: true),
                        Expanded(child: _buildProgressLine(false)),
                        _buildStep('تم\nالوصول', false, false),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Driver Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border(
                      right:
                          BorderSide(color: const Color(0xFFFDD400), width: 4)),
                ),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundImage: NetworkImage(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuAoy-WVW8mfd75IHZgZKz4gWMkJy3u7C5fB4PZcTl47JTDkrIlulGuPHvjS-z_VACHRxOUw_CCnaIE731ldWAgEFsYYfke2jnPekWl0dYbtvhH02YNpQBK59w6sY04gUAhN3vhbiSA-Kr2dYCda1OkmwsgofIWvYHomBe7kjUYYBnHaMgFU2ee4-U6WmPsrNEXjnDo7BlYrjlH7A-mA2gy5LR2rPI4sNlzURrrDg6NApXvDVB-9ZU24chEKRijpU8dRqADWvsuzlCP2',
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDD400),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(Icons.star,
                                size: 12, color: Color(0xFF433700)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('أحمد منصور',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          Row(
                            children: [
                              const Icon(Icons.directions_bike,
                                  size: 14, color: Color(0xFF585C61)),
                              const SizedBox(width: 4),
                              const Text('سوزوكي GSX-R • 8829 أ م',
                                  style: TextStyle(
                                      fontSize: 12, color: Color(0xFF585C61))),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.call, color: Color(0xFFFF7A2C)),
                          onPressed: () {},
                          style: IconButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFFFF7A2C).withOpacity(0.1)),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.chat, color: Colors.white),
                          onPressed: () {},
                          style: IconButton.styleFrom(
                              backgroundColor: const Color(0xFF4953AC)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Delivery Details
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDF1F7),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info,
                            size: 16, color: Color(0xFF4953AC)),
                        const SizedBox(width: 6),
                        const Text('تفاصيل التسليم',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('رقم الطلب:',
                            style: TextStyle(color: Color(0xFF585C61))),
                        const Text('#SP-992144',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('الوقت المتوقع:',
                            style: TextStyle(color: Color(0xFF585C61))),
                        const Text('08:45 م',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Product Summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.list_alt,
                            size: 16, color: Color(0xFFFF7A2C)),
                        const SizedBox(width: 6),
                        const Text('المنتجات (2)',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildProductThumb(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuD-i_xX4VOEaVBA6geIn6KyiBTP7byS4FIeN84SngoIB9zgts9jjt9-1rrBniLDsQOv69esobdlpbwnoF5F6ZKJqu0KbuMTR9-yjdflIkBj6FWAc9hBklxtK1_uSaLnXPQC_ns7Xp7k2kDeAApsVVvZt1nlHcS2kEdWpPmLahLXYoG3mAa6EWaQu5bD5Bqu_dptVcn4U1_-EzkrDkZ_jv129tLCc_5qJ9DzrB8Hz0lQgbHKSPJqIYbMj-vk2XT7h5i_-EVCI-PzPVs1',
                            'حذاء رياضي',
                            'عدد 1',
                          ),
                          const SizedBox(width: 12),
                          _buildProductThumb(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuBq2OvXE_MRzHalZ4McfvO2uC931jxXaKor1SK2KUtDLfRk6ZgxjRgKV7U3x_wNG47NAW6-otgAvl6RhCmwPSmfCyw5ln2e-PYp_KkwCEkSI7zFQ-ZUiPCUs6QQCuzb6B8ZjmUN8ab--_GTGXdPlmiY1BiZePEQE7qtlENazSa2Rf1J4WDStLDRhx2Ce0QBomVoEFs00BKUEMnH5_j5E230CzI5pkOzY4pN5u6qH7oOLXyPWIppCfiJD4pXVb3CMQHAwuYpMXVl6hVG',
                            'سماعات',
                            'عدد 1',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Promo Banner
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Color(0xFFFF7A2C), Color(0xFFFF9D66)]),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('استمتع بخصم 15%',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white)),
                        const Text('على طلبك القادم باستخدام كود SPARK15',
                            style:
                                TextStyle(fontSize: 12, color: Colors.white70)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: const Text('نسخ الكود',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Action Buttons
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF7A2C),
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star),
                    SizedBox(width: 8),
                    Text('تقييم السائق',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFB02500),
                  side: const BorderSide(color: Color(0xFFB02500), width: 1.5),
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cancel),
                    SizedBox(width: 8),
                    Text('إلغاء الطلب',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'يمكنك إلغاء الطلب قبل وصول السائق للمتجر',
                  style: TextStyle(fontSize: 10, color: Color(0xFF585C61)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildStep(String label, bool isCompleted, bool isReached,
      {bool isActive = false}) {
    return Column(
      children: [
        Container(
          width: isActive ? 40 : 32,
          height: isActive ? 40 : 32,
          decoration: BoxDecoration(
            color:
                isCompleted ? const Color(0xFFFF7A2C) : const Color(0xFFD8DDE5),
            shape: BoxShape.circle,
            boxShadow: isActive
                ? [
                    BoxShadow(
                        color: const Color(0xFFFF7A2C).withOpacity(0.3),
                        blurRadius: 8)
                  ]
                : null,
          ),
          child: Icon(
            isCompleted ? Icons.check : Icons.shopping_bag,
            size: isActive ? 20 : 16,
            color: isCompleted ? Colors.white : const Color(0xFF73777C),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isActive ? 10 : 9,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color:
                isCompleted ? const Color(0xFFFF7A2C) : const Color(0xFF73777C),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressLine(bool isActive) {
    return Container(
      height: 2,
      color: isActive ? const Color(0xFFFF7A2C) : const Color(0xFFD8DDE5),
    );
  }

  Widget _buildProductThumb(String imageUrl, String title, String quantity) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child:
              Image.network(imageUrl, width: 40, height: 40, fit: BoxFit.cover),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
            Text(quantity,
                style: const TextStyle(fontSize: 10, color: Color(0xFF585C61))),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_outlined, 'الرئيسية'),
              _buildNavItem(Icons.reorder, 'طلباتي', isActive: true),
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF7A2C),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: const Color(0xFFFF7A2C).withOpacity(0.4),
                          blurRadius: 12),
                    ],
                  ),
                  child: const Icon(Icons.shopping_cart,
                      color: Colors.white, size: 28),
                ),
              ),
              _buildNavItem(Icons.local_offer_outlined, 'العروض'),
              _buildNavItem(Icons.person_outline, 'الحساب'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, {bool isActive = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon,
            color:
                isActive ? const Color(0xFFFF7A2C) : const Color(0xFF73777C)),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? const Color(0xFFFF7A2C) : const Color(0xFF73777C),
          ),
        ),
      ],
    );
  }
}
