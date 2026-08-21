import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xFF000613),
        onPrimary: Color(0xFFFFFFFF),
        primaryContainer: Color(0xFF001F3F),
        onPrimaryContainer: Color(0xFF6F88AD),
        secondary: Color(0xFF795900),
        onSecondary: Color(0xFFFFFFFF),
        secondaryContainer: Color(0xFFFFBF00),
        onSecondaryContainer: Color(0xFF6D5000),
        tertiary: Color(0xFF02060A),
        onTertiary: Color(0xFFFFFFFF),
        tertiaryContainer: Color(0xFF191F25),
        onTertiaryContainer: Color(0xFF80878E),
        error: Color(0xFFBA1A1A),
        onError: Color(0xFFFFFFFF),
        errorContainer: Color(0xFFFFDAD6),
        onErrorContainer: Color(0xFF93000A),
        outline: Color(0xFF74777F),
        outlineVariant: Color(0xFFC4C6CF),
        background: Color(0xFFF9F9FF),
        onBackground: Color(0xFF111C2D),
        surface: Color(0xFFF9F9FF),
        onSurface: Color(0xFF111C2D),
        surfaceVariant: Color(0xFFD8E3FB),
        onSurfaceVariant: Color(0xFF43474E),
        inverseSurface: Color(0xFF263143),
        onInverseSurface: Color(0xFFECF1FF),
        inversePrimary: Color(0xFFAFC8F0),
        shadow: Color(0xFF000000),
        surfaceTint: Color(0xFF476083),
      ),
      fontFamily: 'Inter',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Hanken Grotesk',
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.64,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Hanken Grotesk',
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          fontFamily: 'Inter',
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        labelSmall: TextStyle(
          fontFamily: 'JetBrains Mono',
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.55,
        ),
      ),
    );
  }
}
