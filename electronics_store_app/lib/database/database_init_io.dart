import 'package:sqflite_common_ffi/sqflite_common_ffi.dart';
import 'dart:io' show Platform;

void initDatabaseFactory() {
  try {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
  } catch (_) {}
}
