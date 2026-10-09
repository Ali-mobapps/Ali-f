import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF003178);
  static const Color primaryContainer = Color(0xFF0D47A1);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryFixed = Color(0xFFD9E2FF);
  static const Color primaryFixedDim = Color(0xFFB0C6FF);
  static const Color onPrimaryFixed = Color(0xFF001945);
  
  static const Color secondary = Color(0xFF005FAF);
  static const Color secondaryContainer = Color(0xFF54A0FE);
  static const Color secondaryFixed = Color(0xFFD4E3FF);
  static const Color onSecondaryFixed = Color(0xFF001C3A);
  
  static const Color tertiary = Color(0xFF003D36);
  static const Color tertiaryContainer = Color(0xFF00564D);
  static const Color tertiaryFixed = Color(0xFF8DF5E4);
  static const Color onTertiaryFixed = Color(0xFF00201C);
  
  static const Color background = Color(0xFFF7F9FB);
  static const Color surface = Color(0xFFF7F9FB);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF2F4F6);
  static const Color surfaceContainer = Color(0xFFECEEF0);
  static const Color surfaceContainerHigh = Color(0xFFE6E8EA);
  static const Color surfaceContainerHighest = Color(0xFFE0E3E5);
  
  static const Color onSurface = Color(0xFF191C1E);
  static const Color onSurfaceVariant = Color(0xFF434652);
  static const Color outline = Color(0xFF737783);
  static const Color outlineVariant = Color(0xFFC3C6D4);
  
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        primaryContainer: AppColors.primaryContainer,
        onPrimary: AppColors.onPrimary,
        secondary: AppColors.secondary,
        secondaryContainer: AppColors.secondaryContainer,
        tertiary: AppColors.tertiary,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        error: AppColors.error,
        errorContainer: AppColors.errorContainer,
      ),
      fontFamily: 'Inter',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.onSurface),
        titleTextStyle: TextStyle(
          color: AppColors.onSurface,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceContainerLowest,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0x1AE2E8F0), width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceContainerLowest,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.outlineVariant, width: 0.8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.secondary, width: 2),
        ),
        hintStyle: const TextStyle(
          color: AppColors.outline,
          fontSize: 14,
        ),
      ),
    );
  }
}
