import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<String> saveLocalBackup(String jsonString) async {
  final directory = await getApplicationDocumentsDirectory();
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final file = File('${directory.path}/electro_store_backup_$timestamp.json');
  await file.writeAsString(jsonString);
  return file.path;
}

Future<List<Map<String, dynamic>>> listLocalBackups() async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final dir = Directory(directory.path);
    if (!await dir.exists()) return [];
    final list = dir.listSync();
    List<Map<String, dynamic>> backups = [];
    for (var entity in list) {
      if (entity is File && entity.path.contains('electro_store_backup_')) {
        final stat = await entity.stat();
        backups.add({
          'id': entity.path,
          'name': entity.path.split('/').last.split('\\').last,
          'createdTime': stat.modified.toIso8601String(),
          'size': stat.size.toString(),
        });
      }
    }
    backups.sort((a, b) => b['createdTime'].compareTo(a['createdTime']));
    return backups;
  } catch (e) {
    return [];
  }
}

Future<String> readLocalBackup(String filePath) async {
  final file = File(filePath);
  return await file.readAsString();
}
