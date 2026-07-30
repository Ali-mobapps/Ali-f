import 'package:flutter/material.dart';

class AppConstants {
  // App Colors
  static const Color primaryColor = Color(0xFF0052CC);
  static const Color secondaryColor = Color(0xFF0747A6);
  static const Color backgroundColor = Color(0xFFF4F5F7);
  static const Color surfaceColor = Colors.white;

  // API Base URLs & Endpoints
  static const String baseUrl = "https://api.dynetix.com/v1";
  static const String loginEndpoint = "/auth/login";
  static const String profileEndpoint = "/user/profile";

  // Storage Keys
  static const String tokenKey = "JWT_TOKEN_KEY";
  static const String hiveCacheBox = "dynetix_cache_box";
}