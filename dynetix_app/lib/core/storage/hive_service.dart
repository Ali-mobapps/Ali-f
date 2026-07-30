import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const String userBoxName = 'user_session_box';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(userBoxName);
  }

  static Future<void> saveUserData(String key, String value) async {
    final box = Hive.box(userBoxName);
    await box.put(key, value);
  }

  static String? getUserData(String key) {
    final box = Hive.box(userBoxName);
    return box.get(key);
  }

  static Future<void> clearSession() async {
    final box = Hive.box(userBoxName);
    await box.clear();
  }
}