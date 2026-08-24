import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('certifypro.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      databaseFactory = databaseFactoryFfi;
      sqfliteFfiInit();
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const textType = 'TEXT NOT NULL';
    const idType = 'TEXT PRIMARY KEY';

    await db.execute('''
CREATE TABLE certificates (
  id $idType,
  recipientName $textType,
  recipientEmail $textType,
  courseTitle $textType,
  description $textType,
  issueDate $textType,
  expiryDate TEXT,
  status $textType,
  templateId $textType
)
''');

    await db.execute('''
CREATE TABLE templates (
  id $idType,
  config $textType
)
''');

    await db.execute('''
CREATE TABLE users (
  uid $idType,
  email $textType,
  role $textType
)
''');

    await db.insert('users', {
      'uid': 'admin_uid',
      'email': 'admin@certifypro.com',
      'role': 'admin',
    });
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
