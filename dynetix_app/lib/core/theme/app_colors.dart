import 'package:flutter/material.dart';

class AppColors {
  // Premium VIP Palette
  static const Color gold = Color(0xFFFFD700); // Premium Gold
  static const Color darkBackground = Color(0xFF0F111A); // Deep Navy/Black
  static const Color cardBackground = Color(0xFF1E2230); // Dark Slate
  static const Color accentBlue = Color(0xFF6C5CE7); // Royal Purple/Blue

  // Semantic Aliases
  static const Color primary = gold;
  static const Color background = darkBackground;
  static const Color surface = cardBackground;
  static const Color navBarBackground = Color(0xFF161925);
  
  // Dashboard Tile Colors
  static const Color tilePurple = Color(0xFFA855F7);
  static const Color tileBlue = Color(0xFF3B82F6);
  static const Color tileGreen = Color(0xFF10B981);
  static const Color tileOrange = Color(0xFFF59E0B);
  static const Color tileRed = Color(0xFFEF4444);
  
  // Text Colors
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textDisabled = Color(0xFF475569);
  
  // Accents & Actions
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Gradients
  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFB8860B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF1E2230), Color(0xFF0F111A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
