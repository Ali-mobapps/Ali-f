// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:convert';

Future<String> saveLocalBackup(String jsonString) async {
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final fileName = 'electro_store_backup_$timestamp.json';

  try {
    final existing = html.window.localStorage['electro_store_backups'] ?? '{}';
    final Map<String, dynamic> map = jsonDecode(existing);
    map[fileName] = jsonString;
    html.window.localStorage['electro_store_backups'] = jsonEncode(map);
  } catch (_) {}

  // Trigger browser download
  final bytes = utf8.encode(jsonString);
  final blob = html.Blob([bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', fileName)
    ..click();
  html.Url.revokeObjectUrl(url);

  return 'Downloaded: $fileName';
}

Future<List<Map<String, dynamic>>> listLocalBackups() async {
  try {
    final existing = html.window.localStorage['electro_store_backups'] ?? '{}';
    final Map<String, dynamic> map = jsonDecode(existing);
    List<Map<String, dynamic>> backups = [];
    map.forEach((name, jsonStr) {
      backups.add({
        'id': name,
        'name': name,
        'createdTime': DateTime.now().toIso8601String(),
        'size': jsonStr.length.toString(),
      });
    });
    backups.sort((a, b) => b['name'].compareTo(a['name']));
    return backups;
  } catch (_) {
    return [];
  }
}

Future<String> readLocalBackup(String fileKey) async {
  final existing = html.window.localStorage['electro_store_backups'] ?? '{}';
  final Map<String, dynamic> map = jsonDecode(existing);
  if (map.containsKey(fileKey)) {
    return map[fileKey] as String;
  }
  throw Exception('Backup not found in browser storage.');
}
