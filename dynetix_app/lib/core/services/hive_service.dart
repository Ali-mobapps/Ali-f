import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const String servicesBox = 'services_cache';
  static const String coursesBox = 'courses_cache';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(servicesBox);
    await Hive.openBox(coursesBox);
  }

  static Future<void> cacheItems(String boxName, List<dynamic> items) async {
    final box = Hive.box(boxName);
    await box.put('items', items);
  }

  static List<dynamic> getCachedItems(String boxName) {
    final box = Hive.box(boxName);
    return box.get('items', defaultValue: []);
  }
}
