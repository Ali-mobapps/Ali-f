import 'package:hive_flutter/hive_flutter.dart';

class OfflineService {
  static const String _boxName = 'offline_queue';

  static Future<void> initialize() async {
    await Hive.openBox(_boxName);
  }

  static Future<void> addToQueue({required String action, required Map<String, dynamic> data}) async {
    final box = Hive.box(_boxName);
    await box.add({
      'action': action,
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  static List<Map<String, dynamic>> getQueue() {
    final box = Hive.box(_boxName);
    return box.values.cast<Map<String, dynamic>>().toList();
  }

  static Future<void> clearQueue() async {
    final box = Hive.box(_boxName);
    await box.clear();
  }
}
