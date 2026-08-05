// File path: lib/core/services/database_service.dart
import 'package:flutter/material.dart';

class AppDatabase {
  // Admin Credentials
  static String adminEmail = 'dynetix.info@gmail.com';
  static String adminPassword = 'Dynetix@123';

  static Map<String, dynamic>? currentUser;

  static bool loginUser(String email, String password, String name) {
    if (email == adminEmail && password == adminPassword) {
      currentUser = {
        'name': 'Admin Dynetix',
        'email': adminEmail,
        'isAdmin': true,
        'imagePath': null,
      };
      return true;
    }

    currentUser = {
      'name': name.isNotEmpty ? name : 'User',
      'email': email,
      'isAdmin': false,
      'imagePath': null,
    };
    return true;
  }

  static double totalRevenue = 0.0;
  static List<Map<String, dynamic>> allPaymentsLog = [];

  static List<Map<String, dynamic>> servicesCatalog = [
    {'title': 'Mobile App Development', 'price': 50000.0, 'icon': Icons.phone_android},
    {'title': 'Web Development', 'price': 35000.0, 'icon': Icons.web},
    {'title': 'UI/UX Design', 'price': 20000.0, 'icon': Icons.design_services},
  ];

  // Tasks List (Admin can add, edit, delete tasks)
  static List<Map<String, dynamic>> tasksList = [
    {'title': 'UI/UX Design Review', 'due': '25 Jul 2026', 'priority': 'High', 'isCompleted': false},
    {'title': 'API Integration', 'due': '27 Jul 2026', 'priority': 'Medium', 'isCompleted': false},
    {'title': 'Testing & Bug Fixing', 'due': '30 Jul 2026', 'priority': 'Low', 'isCompleted': false},
  ];

  // Official Payment Accounts & Numbers
  static String adminJazzCash = '03087249533 (Dynetix Official)';
  static String adminEasyPaisa = '03451495330 (Dynetix Official)';
  static String adminBank = 'HBL - 16277900607203 (Dynetix Tech)';
  static String adminNayaPay = '03156717093 (Dynetix Official)';
  static String adminSadaPay = '03156717093 (Dynetix Official)';
}