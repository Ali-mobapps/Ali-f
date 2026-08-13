import 'package:flutter/material.dart';

enum UserRole { admin, student }

class UserAccount {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final bool isApproved;
  final int fineAmount;

  UserAccount({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isApproved,
    required this.fineAmount,
  });
}

class BookingEntry {
  final String userId;
  final DateTime date;
  final String category; // 'office' or 'remote'
  final bool isApproved;
  final bool showedUp;
  final bool isFinalized;
  final String? assignedSeat;
  final String? arrivalDeadline;

  BookingEntry({
    required this.userId,
    required this.date,
    required this.category,
    required this.isApproved,
    required this.showedUp,
    required this.isFinalized,
    this.assignedSeat,
    this.arrivalDeadline,
  });
}

class AppColors {
  // Deep Professional Palette
  static const Color primary = Color(0xFF0F172A); // Deep Slate (Navy/Black)
  static const Color onPrimary = Color(0xFFF8FAFC);
  static const Color secondary = Color(0xFF38BDF8); // Sky Blue Accent
  static const Color onSecondary = Color(0xFF0F172A);
  
  static const Color background = Color(0xFFF1F5F9); // Light Gray Surface
  static const Color onBackground = Color(0xFF1E293B);
  
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceBright = Color(0xFFF8FAFC);
  static const Color onSurface = Color(0xFF334155);
  static const Color onSurfaceVariant = Color(0xFF64748B);
  
  static const Color outline = Color(0xFFE2E8F0);
  static const Color outlineVariant = Color(0xFFCBD5E1);
  
  static const Color error = Color(0xFFEF4444);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  
  static const Color primaryContainer = Color(0xFF1E293B);
  static const Color onPrimaryContainer = Color(0xFFE2E8F0);
  
  static const Color secondaryContainer = Color(0xFFE0F2FE);
  static const Color onSecondaryContainer = Color(0xFF0369A1);

  // Seat States
  static const Color seatAvailable = Color(0xFFFFFFFF);
  static const Color seatOccupied = Color(0xFF1E293B);
  static const Color seatSelected = Color(0xFF38BDF8);
  static const Color seatMaintenance = Color(0xFF94A3B8);
}
