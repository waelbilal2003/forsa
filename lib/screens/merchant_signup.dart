import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

class MerchantSignupScreen extends StatelessWidget {
  const MerchantSignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Merchant Account'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_forward),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(left: 16),
            child: const Text(
              'Souq Spark',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppColors.primaryFixed,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            // Hero Title
            _buildHeroTitle(),
            const SizedBox(height: 32),
            
            // Profile Image Upload
            _buildProfileUpload(),
            const SizedBox(height: 32),
            
            // Store Gallery
            _buildGallerySection(),
            const SizedBox(height: 32),
            
            // Input Fields
            _buildInputFields(),
            const SizedBox(height: 32),
            
            // Map Selection
            _buildMapSection(),
            const SizedBox(height: 24),
            
            // Terms
            _buildTermsText(),
            const SizedBox(height: 80),
          ],
        ),
      ),
      
      // Bottom Action Button (Floating)
      bottomNavigationBar: _buildBottomButton(),
    );
  }
  
  Widget _buildHeroTitle() {
    return Column(
      children: [
        Text(
          'إنشاء حساب تاجر جديد',
          style: AppTypography.headlineMedium.copyWith(
            color: AppColors.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'ابدأ رحلتك التجارية اليوم مع أقوى الأدوات التسويقية',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
  
  Widget _buildProfileUpload() {
    return Column(
      children: [
        Stack(
          children: [
            // Main Avatar
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 6,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.network(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuA74M9tcGP2AqoM5cdBALmHjcW-KIfl3ei18MesZv8Dz6sUS7CcqwTABMngqoKeC-fPOhO95-Ucs6ZTqe9-ctJq12hz5vQMijo3gUOssvcApeigdjwqNckdrYU_EZMp1AjpkbvBxDSadRvDOg5cT7LtaDHW4kXvOwRctJFmeqOG1Dms4mTKIZxyCAxkIl_an7NVYs0_6axAA0EE4PCsaiu0oAFWRfVf0RSkWIQ7d7ASl9qwzc7FAfAXs5y0hSOf_Zs_5s3MvLgeR2zB',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Edit Button
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryFixed,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
            // Decorative Rotating Ring
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  margin: const EdgeInsets.all(-8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primaryFixed.withOpacity(0.3),
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'تحميل شعار المتجر',
          style: AppTypography.labelLarge.copyWith(
            color: AppColors.primaryFixed,
          ),
        ),
      ],
    );
  }
  
  Widget _buildGallerySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'معرض صور المتجر',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryFixed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                'أضف حتى 5 صور',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primaryFixed,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildAddImageCard(),
              const SizedBox(width: 16),
              _buildGalleryImageCard(
                imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDv1s1tx9eDcn1Q-yGTJbSUjmL2fil0eNMf8-L0Pdk7A4ky_oiVUhnbUVlIx2O_hkc_HhANfIIVxL2MGxKCDmGbWORhmrY7urof6-ONnDE41AwcWsTyHPbDFXc1GHkm__S7n8jvJqsGjl8eubO2sY0bnfcCsFZ-SZcFHjqgbanOoxn0Rx_7To4QxmoG205I6k5d8SGGJ__-DQhzE3nDbL0SBJPeN97SMkXDuJOdC6blZAfAc3FKmLe_vv_Rz9W5lTzTvW5DJYSRw5cf',
              ),
              const SizedBox(width: 16),
              _buildGalleryImageCard(
                imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBvpcMWnG6mQ4gO51LrYfUDbL3PzPRIK_0NkzosOwA9fwKOFoT4Ms3d-BDz_shm9bT92sOzrg1RJRTQn8x5hLoi8Ty7vrteLL7vfLbsUJSGZJhuAF3nxyqphHSSElbfFTxtCqn9bxktuitJxT8-_fkOJ2YlEQnjcAI2YYJUtj5DBxsWKgK5RCpfsUb2rPfDbKu9OuCa-cwGj15Wni7TCTHAC7NMJULXa0UDVz6zbZTfYU99AxmRnBJnxO9dATVMPafRq93uDcnU5IO8',
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildAddImageCard() {
    return Container(
      width: 140,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.outlineVariant.withOpacity(0.3),
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add,
                  color: AppColors.outline,
                  size: 32,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'أضف صورة',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.outline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildGalleryImageCard({required String imageUrl}) {
    return Container(
      width: 140,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.network(
              imageUrl,
              width: 140,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInputFields() {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: 'اسم المتجر',
            labelStyle: AppTypography.labelMedium.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
            hintText: 'مثلاً: متجر البركة للأقمشة',
          ),
        ),
        const SizedBox(height: 24),
        TextField(
          maxLines: 4,
          decoration: InputDecoration(
            labelText: 'وصف المتجر',
            labelStyle: AppTypography.labelMedium.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
            hintText: 'أخبر عملاءك عن تميز متجرك...',
            alignLabelWithHint: true,
          ),
        ),
      ],
    );
  }
  
  Widget _buildMapSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'موقع المتجر',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            Row(
              children: [
                const Icon(
                  Icons.my_location,
                  size: 18,
                  color: AppColors.primaryFixed,
                ),
                const SizedBox(width: 4),
                Text(
                  'تحديد تلقائي',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.primaryFixed,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          height: 280,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Stack(
              children: [
                Image.network(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuCQybtyW12jlzQhQvMPd5nz5OXc8_Pa8DycV-p1097m0xJVKF24BHNakvI2NavFBKqlSwrrBOpIUYZXvl22ifTgTS-WlF38CYyHC2q8BcH23R5_L8e58sFSfcEAximI0mqFHhcRXNEULQGVMEZQ2WTqaFsdaHmVm0FcQ5kO0DjY5XZwHxYxAC3epQFJ7AwbmpXmjVFbPM5Z9x6xkMP9G7Ck23YHCIJ3P_D5hLzcAqGO_6YQwjOZ548lDB8C0Eil1daYtq-fXAn7MOL3',
                  width: double.infinity,
                  height: 280,
                  fit: BoxFit.cover,
                ),
                // Center Pin
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.primaryFixed.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.location_on,
                            color: AppColors.primaryFixed,
                            size: 48,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Bottom Button
                Positioned(
                  bottom: 24,
                  left: 24,
                  right: 24,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white.withOpacity(0.95),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.add_location_alt,
                                color: AppColors.primaryFixed,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'استخدم موقعي الحالي',
                                style: AppTypography.labelLarge.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildTermsText() {
    return Text.rich(
      TextSpan(
        text: 'بالنقر على إنشاء الحساب، فإنك توافق على ',
        style: AppTypography.bodySmall.copyWith(
          color: AppColors.outline,
        ),
        children: [
          TextSpan(
            text: 'شروط الاستخدام',
            style: const TextStyle(
              color: AppColors.primaryFixed,
              fontWeight: FontWeight.w700,
              decoration: TextDecoration.underline,
            ),
          ),
          const TextSpan(text: ' و '),
          TextSpan(
            text: 'سياسة الخصوصية',
            style: const TextStyle(
              color: AppColors.primaryFixed,
              fontWeight: FontWeight.w700,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
  
  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryFixed,
            foregroundColor: AppColors.onPrimaryFixed,
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            textStyle: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w800,
            ),
            elevation: 0,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('إنشاء الحساب'),
              SizedBox(width: 12),
              Icon(Icons.rocket_launch),
            ],
          ),
        ),
      ),
    );
  }
}