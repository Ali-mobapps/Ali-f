import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const primaryColor = Color(0xFF000666);
  static const primaryContainer = Color(0xFF1A237E);
  static const secondaryColor = Color(0xFF0056C5);
  static const backgroundColor = Color(0xFFF3FAFF);
  static const surfaceColor = Color(0xFFF3FAFF);
  static const errorColor = Color(0xFFBA1A1A);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        primaryContainer: primaryContainer,
        secondary: secondaryColor,
        surface: surfaceColor,
        error: errorColor,
      ),
      textTheme: GoogleFonts.hankenGroteskTextTheme(),
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceColor,
        foregroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: primaryColor,
        ),
      ),
    );
  }
}
