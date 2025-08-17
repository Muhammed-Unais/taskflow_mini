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
    final textTheme = GoogleFonts.interTextTheme();
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
        border: OutlineInputBorder(),
      ),
    );
  }
}
