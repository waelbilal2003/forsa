import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OfferDetailsScreen extends StatelessWidget {
  const OfferDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FC),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Offer Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Color(0xFFFF7A2C)),
            onPressed: () {},
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Image
              Stack(
                children: [
                  Container(
                    height: 380,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuAsvkkomlx6qGOLAZAB37nc5NnF-FeYEUWkCDotOosVDB2y0wVgGz_uZjhjQpVEIkfprCuTlcQCkpCuQIMxm7_zSCpq-TohMFNF_u1ay37ujd8LWKQoevlAaT8tlC08NU5VIyjpBtIt4VUkNExlxRW6hztt78XMVSdmJatqOvAfLENrF_-iggTOPo_ZTUJBWVl0qiutmf0jVpcF08v0gkM0ktndUSaDzb572sR9r8Gx0DX0gtVWz9WdFLlTxrOB4SSUnvPD2HAPGkPZ',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Badge
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: Transform.rotate(
                      angle: -0.07,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDD400),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 8,
                                offset: const Offset(0, 4)),
                          ],
                        ),
                        child: const Column(
                          children: [
                            Text('خصم',
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.bold)),
                            Text('35%',
                                style: TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Pricing & Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '749,000 ل.س',
                          style: GoogleFonts.tajawal(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFFF7A2C),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '1,150,000 ل.س',
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Color(0xFF73777C),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'سماعات الرأس اللاسلكية "سبارك برو" - الإصدار الفاخر',
                      style: GoogleFonts.tajawal(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2B2F33),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'استمتع بتجربة صوتية غامرة لا مثيل لها مع تقنية إلغاء الضوضاء النشطة المتقدمة. صُممت لتدوم طويلاً مع راحة استثنائية طوال اليوم.',
                      style: TextStyle(
                        color: Color(0xFF585C61),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Store Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 24,
                          offset: const Offset(0, 12)),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD8DDE5),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child:
                            const Icon(Icons.store, color: Color(0xFF4953AC)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'عالم التقنية الحديثة',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    size: 16, color: Color(0xFF6D5A00)),
                                const SizedBox(width: 4),
                                const Text('4.9',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(width: 4),
                                Text('(1.2k تقييم)',
                                    style: TextStyle(
                                        color: const Color(0xFF73777C),
                                        fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                        ),
                        child: const Text('متابعة'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Features Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'المواصفات الأساسية',
                      style: GoogleFonts.tajawal(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      children: [
                        _buildFeatureCard(Icons.sick, 'عمر البطارية',
                            '40 ساعة متواصلة', const Color(0xFFFF7A2C)),
                        _buildFeatureCard(Icons.noise_aware, 'عزل الضوضاء',
                            'نشط (ANC)', const Color(0xFF4953AC)),
                        _buildFeatureCard(Icons.bluetooth, 'الاتصال',
                            'بلوتوث 5.3', const Color(0xFF6D5A00)),
                        _buildFeatureCard(Icons.speed, 'شحن سريع',
                            '10 دقائق لـ 3 ساعات', const Color(0xFF883700)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Location Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'موقع المتجر',
                      style: GoogleFonts.tajawal(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Stack(
                      children: [
                        Container(
                          height: 180,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: const Color(0xFFD8DDE5),
                            image: const DecorationImage(
                              image: NetworkImage(
                                'https://lh3.googleusercontent.com/aida-public/AB6AXuB060nmHcZ_foj3MoPPCT8DM4XokyogeSXdjUZg9YDczo9-9EuwVMJAcmwTHJBEMc2fn4rZ74agLcY2aAGVuPMhEWBqhObx2MCqpLtOM4hMDkR0GZ2Bv6h4-MFiKiVJOnqQ0GOrb9YN9AHfsjubMz7b7oKkJiL5hoQay9fGydfdCZ5x6ZpIapnz1EH0net9feQZQy2_1iu4AxPjQ462UeBHyE81vwbucgf6etPMRbeuzWVFk_e6-XZlSdAw0Co0huEFF-wmN2jh3dxJ',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const Positioned(
                          left: 16,
                          bottom: 16,
                          right: 16,
                          child: Card(
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('المزة، دمشق',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text('فتح في الخرائط',
                                      style: TextStyle(
                                          color: Color(0xFFFF7A2C),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, -4)),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF7A2C),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('احصل على العرض الآن',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(width: 8),
                  Icon(Icons.bolt),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
      IconData icon, String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEDF1F7),
        borderRadius: BorderRadius.circular(16),
        border: Border(right: BorderSide(color: color, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(title,
              style: const TextStyle(fontSize: 10, color: Color(0xFF73777C))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
