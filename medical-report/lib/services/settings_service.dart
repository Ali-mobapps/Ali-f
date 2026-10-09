import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _keyWifiOnly = 'auto_sync_wifi_only';
  static const String _keyPrivacyScreen = 'privacy_screen_enabled';
  static const String _keyPinCode = 'security_pin_code';

  static Future<bool> isWifiOnlyEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyWifiOnly) ?? true;
  }

  static Future<void> setWifiOnlyEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyWifiOnly, value);
  }

  static Future<bool> isPrivacyScreenEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyPrivacyScreen) ?? true;
  }

  static Future<void> setPrivacyScreenEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyPrivacyScreen, value);
  }

  static Future<String?> getPinCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPinCode) ?? '1234';
  }

  static Future<void> setPinCode(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPinCode, pin);
  }
}
