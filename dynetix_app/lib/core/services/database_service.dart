import 'package:flutter/material.dart';
import 'supabase_service.dart';

class AppDatabase {
  static const String adminEmail = 'admin@dynetix.com';
  static const String adminPassword = 'admin123';
  static Map<String, dynamic>? currentUser;

  static Future<void> initializeUserSession() async {
    final user = SupabaseService.currentUser;
    if (user != null) {
      final profile = await SupabaseService.getProfile(user.id);
      currentUser = {
        'id': user.id,
        'name': profile?['full_name'] ?? 'Dynetix User',
        'email': user.email,
        'isAdmin': user.email == adminEmail,
        'imageUrl': profile?['avatar_url'],
        'bio': profile?['bio'] ?? 'Dynetix Member',
        'imagePath': null,
      };
    }
  }

  static void logout() {
    currentUser = null;
    SupabaseService.signOut();
  }

  static const List<String> initialServices = [
    '3D Modeling', 'Legal Drafting and Global Compliance', 'Full Stack Development with MERN',
    'Cloud Computing', 'Shopify Development and Dropshipping', 'Mobile Game and App Development',
    'UI/UX & Webflow', 'Artificial Intelligence using Python', 'Startup Strategies and Entrepreneurship',
    'Virtual Assistant', 'Data Analytics and Business Intelligence', 'QuickBooks',
    'SEO (Search Engine Optimization)', 'Graphic Design', 'Creative Writing', 'AutoCAD',
    'Digital Literacy', 'Digital Marketing', 'E-Commerce Management', 'Freelancing',
    'Communication and Soft Skills', 'Video Editing, Animation and Vlogging', 'Affiliate Marketing', 'WordPress'
  ];

  static String adminJazzCash = '03087249533';
  static String adminJazzCashName = 'Dynetix Official';
  static String adminEasyPaisa = '03451495330';
  static String adminEasyPaisaName = 'Dynetix Official';
  static String adminBank = '16277900607203';
  static String adminBankName = 'HBL - Dynetix Tech';

  static bool isDarkMode = true;

  static Future<void> syncWithSupabase() async {
    try {
      final settings = await SupabaseService.getAppSettings();
      if (settings.isNotEmpty) {
        adminJazzCash = settings['jazzcash_no'] ?? adminJazzCash;
        adminJazzCashName = settings['jazzcash_name'] ?? adminJazzCashName;
        adminEasyPaisa = settings['easypaisa_no'] ?? adminEasyPaisa;
        adminEasyPaisaName = settings['easypaisa_name'] ?? adminEasyPaisaName;
        adminBank = settings['bank_no'] ?? adminBank;
        adminBankName = settings['bank_name'] ?? adminBankName;
      }
    } catch (e) {
      debugPrint('Sync Error: $e');
    }
  }
}
