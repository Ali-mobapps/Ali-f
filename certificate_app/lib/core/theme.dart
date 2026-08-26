import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CertifyProTheme {
  // Brand Colors - Premium Navy & Gold
  static const Color primary = Color(0xFF1E293B); // Deep Navy Slate
  static const Color secondary = Color(0xFFB4975A); // Premium Muted Gold
  static const Color accentGold = Color(0xFFB4975A);
  
  static const Color background = Color(0xFFF1F5F9);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color outline = Color(0xFFCBD5E1);
  static const Color outlineVariant = Color(0xFFE2E8F0);
  
  static const Color success = Color(0xFF059669);
  static const Color error = Color(0xFFDC2626);
  static const Color onSurfaceVariant = Color(0xFF475569);

  static const Color primaryContainer = Color(0xFFF8FAFC); 
  static const Color surfaceContainerLow = Color(0xFFF1F5F9);
  static const Color surfaceContainer = Color(0xFFE2E8F0);
  static const Color surfaceContainerHigh = Color(0xFFCBD5E1);
  static const Color surfaceContainerHighest = Color(0xFF94A3B8);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  
  static const Color surfaceBright = Color(0xFFFFFFFF);

  static ThemeData get lightTheme {
    final base = ThemeData.light(useMaterial3: true);
    
    return base.copyWith(
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: secondary,
        surface: surface,
        error: error,
        onSurfaceVariant: onSurfaceVariant,
        outline: outline,
        outlineVariant: outlineVariant,
      ),
      scaffoldBackgroundColor: background,
      
      // Professional Typography
      textTheme: GoogleFonts.montserratTextTheme(base.textTheme).copyWith(
        headlineLarge: GoogleFonts.playfairDisplay(fontSize: 32, fontWeight: FontWeight.w900, color: primary),
        headlineMedium: GoogleFonts.playfairDisplay(fontSize: 24, fontWeight: FontWeight.w700, color: primary),
        titleLarge: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w700, color: primary),
        bodyLarge: GoogleFonts.montserrat(fontSize: 15, fontWeight: FontWeight.w500, color: primary),
        bodyMedium: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w400, color: onSurfaceVariant),
        labelMedium: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.1, color: onSurfaceVariant),
      ),

      // Modern Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: outline)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: outline)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: primary, width: 1.5)),
      ),

      // Premium Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: outline),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ),

      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: outline),
        ),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(color: primary, fontSize: 20, fontWeight: FontWeight.w800),
        iconTheme: IconThemeData(color: primary),
      ),
    );
  }
}
