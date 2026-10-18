import 'dart:convert';
import 'package:crypto/crypto.dart';

class PasswordHasher {
  static const String _salt = 'StudentManagementSystemSalt2025!@#';

  /// Hashes a plain password securely using SHA-256 with salt.
  static String hashPassword(String password) {
    final bytes = utf8.encode(password + _salt);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Verifies a plain password against stored hash.
  static bool verifyPassword(String plainPassword, String storedHash) {
    final hashOfInput = hashPassword(plainPassword);
    return hashOfInput == storedHash;
  }
}
