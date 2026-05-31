import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

typedef AppTextStyles = AppTypography;

class AppTypography {
  static TextStyle get displayMedium =>
      GoogleFonts.tajawal(fontSize: 32, fontWeight: FontWeight.bold);

  static TextStyle get headlineMedium =>
      GoogleFonts.tajawal(fontSize: 26, fontWeight: FontWeight.bold);

  static TextStyle get titleLarge =>
      GoogleFonts.tajawal(fontSize: 20, fontWeight: FontWeight.bold);

  static TextStyle get titleMedium =>
      GoogleFonts.tajawal(fontSize: 17, fontWeight: FontWeight.w600);

  static TextStyle get bodyLarge => GoogleFonts.tajawal(fontSize: 16);

  static TextStyle get bodyMedium => GoogleFonts.tajawal(fontSize: 14);

  static TextStyle get bodySmall =>
      GoogleFonts.tajawal(fontSize: 12, color: const Color(0xFF585C61));

  static TextStyle get labelLarge =>
      GoogleFonts.tajawal(fontSize: 14, fontWeight: FontWeight.w600);

  static TextStyle get labelMedium =>
      GoogleFonts.tajawal(fontSize: 12, fontWeight: FontWeight.w600);

  static TextStyle get labelSmall =>
      GoogleFonts.tajawal(fontSize: 11, fontWeight: FontWeight.w500);
}
