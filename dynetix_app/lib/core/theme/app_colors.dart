import 'package:flutter/material.dart';

class AppColors {
  // Azure Enterprise Palette (Premium Blue & Pure White)
  static const Color royalBlue = Color(0xFF0066FF);
  static const Color deepAzure = Color(0xFF0047AB); // Slightly darker for better contrast
  static const Color midnightNavy = Color(0xFF0F172A);
  static const Color softBackground = Color(0xFFF8FAFF); 
  static const Color surfaceWhite = Colors.white;
  
  // Logical Aliases
  static const Color primary = royalBlue;
  static const Color background = softBackground; 
  static const Color surface = surfaceWhite;
  static const Color glassBorder = Color(0x1A0066FF); 
  
  // Backward Compatibility Aliases
  static const Color obsidian = midnightNavy;
  static const Color charcoalDepth = Color(0xFFE2E8F0);
  static const Color champagneGold = royalBlue; 
  static const Color electricBlue = royalBlue;
  static const Color pureWhite = Colors.white;
  static const Color softGrey = Color(0xFFF1F5F9);
  
  // Dashboard / Card Colors
  static const Color gold = Color(0xFFD97706); // Darker amber for visibility on white
  static const Color cardBackground = Colors.white;
  static const Color darkCardBackground = Color(0xFFF1F5F9);
  
  // Text Colors - INCREASED CONTRAST
  static const Color textPrimary = Color(0xFF0F172A); // Almost black for best readability
  static const Color textSecondary = Color(0xFF475569); // Darker grey
  static const Color textDisabled = Color(0xFF64748B); // Mid grey
  
  // Accents & Actions
  static const Color success = Color(0xFF059669);
  static const Color error = Color(0xFFDC2626);

  static Color getOnBackgroundColor(BuildContext context) {
    // Force high contrast dark text for light background
    return textPrimary;
  }
}
