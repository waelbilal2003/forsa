// lib/theme/colors.dart
//
// لوحة ألوان "فرصة" (نظام شبيه بـ Material 3) — تجمع كل الرموز التي
// تستخدمها شاشات التاجر والسائق. الألوان مبنية حول البرتقالي والأصفر.

import 'package:flutter/material.dart';

class AppColors {
  // الأساسية (برتقالي)
  static const Color primary = Color(0xFFFF7A2C);
  static const Color primaryDim = Color(0xFFE56A1F);
  static const Color primaryFixed = Color(0xFFFF7A2C);
  static const Color primaryContainer = Color(0xFFFFE2D1);
  static const Color onPrimary = Colors.white;
  static const Color onPrimaryFixed = Color(0xFF2B2F33);
  static const Color onPrimaryContainer = Color(0xFF9B3F00);

  // الثانوية (أصفر)
  static const Color secondary = Color(0xFFFDD400);
  static const Color secondaryFixed = Color(0xFFFDD400);
  static const Color secondaryContainer = Color(0xFFFFF4C2);
  static const Color onSecondaryContainer = Color(0xFF6B5A00);
  static const Color onSecondaryFixed = Color(0xFF2B2F33);

  // الثلاثية (أزرق هادئ)
  static const Color tertiary = Color(0xFF4953AC);
  static const Color tertiaryContainer = Color(0xFFE0E3F7);
  static const Color onTertiary = Colors.white;
  static const Color onTertiaryContainer = Color(0xFF2A327A);

  // الأخطاء
  static const Color error = Color(0xFFD32F2F);
  static const Color errorDim = Color(0xFFB71C1C);
  static const Color errorContainer = Color(0xFFFFE5E5);

  // الأسطح والخلفيات
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceBright = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFEDF1F7);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF7F9FC);
  static const Color surfaceContainer = Color(0xFFF4F6FC);
  static const Color surfaceContainerHigh = Color(0xFFECEFF6);
  static const Color surfaceContainerHighest = Color(0xFFE3E7F0);

  // النصوص والحدود
  static const Color onSurface = Color(0xFF2B2F33);
  static const Color onSurfaceVariant = Color(0xFF585C61);
  static const Color outline = Color(0xFFBFC4CC);
  static const Color outlineVariant = Color(0xFFDDE1E8);
}
