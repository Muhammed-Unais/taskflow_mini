import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskflow_mini/core/theme/app_pallete.dart';

class AppTheme {
  static ThemeData light() => _base(false);
  static ThemeData dark() => _base(true);

  static ThemeData _base(bool isDark) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppPallete.brandBlue,
      brightness: isDark ? Brightness.dark : Brightness.light,
    );
    final textTheme = GoogleFonts.interTextTheme().copyWith(
      displayLarge: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: isDark ? AppPallete.whiteColor : AppPallete.blackColor,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: isDark ? AppPallete.whiteColor : AppPallete.blackColor,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: isDark ? AppPallete.whiteColor : AppPallete.blackColor,
      ),

      titleLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: isDark ? AppPallete.whiteColor : AppPallete.blackColor,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: isDark ? AppPallete.whiteColor : AppPallete.blackColor,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: isDark ? AppPallete.whiteColor : AppPallete.blackColor,
      ),

      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: isDark ? AppPallete.whiteColor : AppPallete.blackColor,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: isDark ? AppPallete.whiteColor : AppPallete.blackColor,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: isDark ? AppPallete.whiteColor : AppPallete.blackColor,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,

      cardTheme: const CardTheme(
        clipBehavior: Clip.antiAlias,
        elevation: 0.5,
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),

      inputDecorationTheme: const InputDecorationTheme(
        fillColor: Colors.white,
        border: OutlineInputBorder(),
      ),
    );
  }
}
