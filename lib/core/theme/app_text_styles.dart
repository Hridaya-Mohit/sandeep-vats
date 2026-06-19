import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  /// Cinzel — all-caps Roman, used for labels & section tags
  static TextStyle cinzel({
    double fontSize = 12,
    Color color = AppColors.gold,
    FontWeight weight = FontWeight.w400,
    double letterSpacing = 4.0,
  }) =>
      GoogleFonts.cinzel(
        fontSize: fontSize,
        color: color,
        fontWeight: weight,
        letterSpacing: letterSpacing,
      );

  /// Cormorant Garamond — elegant serif for headings
  static TextStyle cormorant({
    double fontSize = 48,
    Color color = AppColors.textPrimary,
    FontWeight weight = FontWeight.w300,
    FontStyle style = FontStyle.normal,
    double? height,
    double letterSpacing = 0,
  }) =>
      GoogleFonts.cormorantGaramond(
        fontSize: fontSize,
        color: color,
        fontWeight: weight,
        fontStyle: style,
        height: height,
        letterSpacing: letterSpacing,
      );

  /// Inter — clean sans-serif for body text
  static TextStyle inter({
    double fontSize = 16,
    Color color = AppColors.textMuted,
    FontWeight weight = FontWeight.w400,
    double? height,
    double letterSpacing = 0,
  }) =>
      GoogleFonts.inter(
        fontSize: fontSize,
        color: color,
        fontWeight: weight,
        height: height,
        letterSpacing: letterSpacing,
      );

  /// Noto Sans Devanagari — for Hindi text
  static TextStyle devanagari({
    double fontSize = 16,
    Color color = AppColors.textMuted,
    FontWeight weight = FontWeight.w400,
    double? height,
  }) =>
      GoogleFonts.notoSansDevanagari(
        fontSize: fontSize,
        color: color,
        fontWeight: weight,
        height: height,
      );
}
