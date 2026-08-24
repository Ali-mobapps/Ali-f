import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class StorageService {
  // We'll return the bytes directly to support both Web and Mobile persistence in SQL
  Future<Uint8List?> readAssetBytes(String path) async {
    try {
      if (kIsWeb) {
        // On web, we usually get a blob URL from image_picker, 
        // but since we want to store it in SQL, we'll need to fetch the bytes.
        // This is handled in the customizer UI via image_picker.readAsBytes()
        return null; 
      }
      final file = File(path);
      return await file.readAsBytes();
    } catch (e) {
      debugPrint("Read error: $e");
      return null;
    }
  }

  Future<String?> saveToLocalDisk(Uint8List bytes, String fileName) async {
    if (kIsWeb) return null; // No local disk access on web
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(bytes);
      return file.path;
    } catch (e) {
      debugPrint("Disk save error: $e");
      return null;
    }
  }
}
