import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/settings_provider.dart';

final themeProvider = Provider<ThemeData>((ref) {
  final settings = ref.watch(settingsProvider);
  return AppTheme.getTheme(
    fontFamily: settings.fontFamily,
    borderRadius: settings.borderRadius,
    accentColor: Color(settings.accentColor),
    fontSizeScale: settings.fontSizeScale,
  );
});

class AppTheme {
  static const Color background = Color(0xFF0D0D0D);
  static const Color surface = Color(0xFF1C1C1E);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF8E8E93);

  static ThemeData getTheme({
    required String fontFamily,
    required double borderRadius,
    required Color accentColor,
    required double fontSizeScale,
  }) {
    final baseBorder = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    );

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: accentColor,
      fontFamily: fontFamily,
      colorScheme: ColorScheme.dark(
        primary: accentColor,
        secondary: accentColor,
        surface: surface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.w700, fontSize: 32 * fontSizeScale, letterSpacing: -1.0),
        headlineMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 24 * fontSizeScale),
        headlineSmall: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 20 * fontSizeScale),
        bodyLarge: TextStyle(color: textPrimary, fontSize: 16 * fontSizeScale),
        bodyMedium: TextStyle(color: textSecondary, fontSize: 14 * fontSizeScale),
        labelLarge: TextStyle(color: textPrimary, fontSize: 14 * fontSizeScale, fontWeight: FontWeight.bold),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: baseBorder,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius * 0.8),
          ),
          textStyle: TextStyle(fontSize: 18 * fontSizeScale, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
