import 'package:flutter/material.dart';

class AppColors {
  // Premium VIP Palette - Exact matches from design specifications
  static const Color champagneGold = Color(0xFFD4AF37);
  static const Color obsidian = Color(0xFF0A0A0A);
  static const Color charcoalDepth = Color(0xFF1A1A1A);
  static const Color softIvory = Color(0xFFF7E7CE);
  
  static const Color primary = champagneGold;
  static const Color background = obsidian;
  static const Color surface = charcoalDepth;
  static const Color glassBorder = Color(0x1AFFFFFF); // 0.1 opacity white
  
  // Dashboard Tile Colors
  static const Color gold = Color(0xFFFFD700);
  static const Color darkBackground = Color(0xFF0F111A);
  static const Color cardBackground = Color(0xFF1E2230);
  
  // Text Colors
  static const Color textPrimary = Color(0xFFE5E2E1);
  static const Color textSecondary = Color(0xFFD0C5AF);
  static const Color textDisabled = Color(0xFF99907C);
  
  // Accents & Actions
  static const Color success = Color(0xFF00E676);
  static const Color error = Color(0xFFFFB4AB);

  // Gradients
  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFD4AF37), Color(0xFFF2CA50)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
