import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Web Fallback memory storage to prevent browser assertions
  final Map<String, String> _webInMemoryStorage = {};

  static const String _accessTokenKey = 'JWT_ACCESS_TOKEN';
  static const String _refreshTokenKey = 'JWT_REFRESH_TOKEN';

  // Save Tokens
  Future<void> saveTokens({required String accessToken, required String refreshToken}) async {
    if (kIsWeb) {
      _webInMemoryStorage[_accessTokenKey] = accessToken;
      _webInMemoryStorage[_refreshTokenKey] = refreshToken;
      return;
    }
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  // Get Access Token
  Future<String?> getAccessToken() async {
    if (kIsWeb) {
      return _webInMemoryStorage[_accessTokenKey];
    }
    return await _storage.read(key: _accessTokenKey);
  }

  // Get Refresh Token
  Future<String?> getRefreshToken() async {
    if (kIsWeb) {
      return _webInMemoryStorage[_refreshTokenKey];
    }
    return await _storage.read(key: _refreshTokenKey);
  }

  // Clear Storage on Logout
  Future<void> clearAll() async {
    if (kIsWeb) {
      _webInMemoryStorage.clear();
      return;
    }
    await _storage.deleteAll();
  }
}