import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import '../core/constants/app_constants.dart';
import '../models/student_model.dart';
import '../models/user_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    try {
      _database = await _initDB(AppConstants.dbName);
    } catch (e) {
      // Ensure app never blocks or crashes on database open failure
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      _database = await openDatabase(
        inMemoryDatabasePath,
        version: AppConstants.dbVersion,
        onCreate: _createDB,
        onUpgrade: _onUpgrade,
      );
    }
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    if (kIsWeb) {
      try {
        databaseFactory = databaseFactoryFfiWeb;
      } catch (_) {
        databaseFactory = databaseFactoryFfi;
      }
    } else if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, filePath);

      return await openDatabase(
        path,
        version: AppConstants.dbVersion,
        onCreate: _createDB,
        onUpgrade: _onUpgrade,
      );
    } catch (_) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      return await openDatabase(
        inMemoryDatabasePath,
        version: AppConstants.dbVersion,
        onCreate: _createDB,
        onUpgrade: _onUpgrade,
      );
    }
  }

  Future<void> _createDB(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE ${AppConstants.tableUsers} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password_hash TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    // Students table
    await db.execute('''
      CREATE TABLE ${AppConstants.tableStudents} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        full_name TEXT NOT NULL,
        roll_number TEXT NOT NULL UNIQUE,
        email TEXT NOT NULL,
        phone TEXT NOT NULL,
        department TEXT NOT NULL,
        semester TEXT NOT NULL,
        section TEXT,
        gender TEXT,
        address TEXT,
        cgpa TEXT NOT NULL DEFAULT '3.00',
        photo_path TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Index on roll_number and department for faster queries
    await db.execute(
      'CREATE INDEX idx_students_roll ON ${AppConstants.tableStudents}(roll_number);',
    );
    await db.execute(
      'CREATE INDEX idx_students_dept ON ${AppConstants.tableStudents}(department);',
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE ${AppConstants.tableStudents} ADD COLUMN cgpa TEXT DEFAULT "3.00"');
    }
  }

  // ================= USERS CRUD =================

  Future<int> insertUser(UserModel user) async {
    final db = await instance.database;
    return await db.insert(AppConstants.tableUsers, user.toMap());
  }

  Future<UserModel?> getUserByEmail(String email) async {
    final db = await instance.database;
    final maps = await db.query(
      AppConstants.tableUsers,
      where: 'LOWER(email) = ?',
      whereArgs: [email.toLowerCase().trim()],
    );

    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  Future<UserModel?> getUserById(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      AppConstants.tableUsers,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateUser(UserModel user) async {
    final db = await instance.database;
    return await db.update(
      AppConstants.tableUsers,
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // ================= STUDENTS CRUD =================

  Future<int> insertStudent(StudentModel student) async {
    final db = await instance.database;
    return await db.insert(AppConstants.tableStudents, student.toMap());
  }

  Future<StudentModel?> getStudentById(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      AppConstants.tableStudents,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return StudentModel.fromMap(maps.first);
    }
    return null;
  }

  Future<bool> isRollNumberTaken(String rollNumber, {int? excludeId}) async {
    final db = await instance.database;
    String whereClause = 'LOWER(roll_number) = ?';
    List<dynamic> whereArgs = [rollNumber.toLowerCase().trim()];

    if (excludeId != null) {
      whereClause += ' AND id != ?';
      whereArgs.add(excludeId);
    }

    final result = await db.query(
      AppConstants.tableStudents,
      columns: ['id'],
      where: whereClause,
      whereArgs: whereArgs,
    );

    return result.isNotEmpty;
  }

  Future<List<StudentModel>> getAllStudents({
    String? searchQuery,
    String? department,
    String? semester,
    String sortBy = 'name', // 'name', 'roll', 'date'
    bool ascending = true,
  }) async {
    final db = await instance.database;

    List<String> whereClauses = [];
    List<dynamic> whereArgs = [];

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final q = '%${searchQuery.trim().toLowerCase()}%';
      whereClauses.add('(LOWER(full_name) LIKE ? OR LOWER(roll_number) LIKE ? OR LOWER(email) LIKE ?)');
      whereArgs.addAll([q, q, q]);
    }

    if (department != null && department != 'All') {
      whereClauses.add('department = ?');
      whereArgs.add(department);
    }

    if (semester != null && semester != 'All') {
      whereClauses.add('semester = ?');
      whereArgs.add(semester);
    }

    String whereString = whereClauses.isNotEmpty ? whereClauses.join(' AND ') : '';

    String orderBy;
    switch (sortBy) {
      case 'roll':
        orderBy = 'roll_number ${ascending ? 'ASC' : 'DESC'}';
        break;
      case 'date':
        orderBy = 'created_at ${ascending ? 'ASC' : 'DESC'}';
        break;
      case 'name':
      default:
        orderBy = 'full_name ${ascending ? 'ASC' : 'DESC'}';
        break;
    }

    final maps = await db.query(
      AppConstants.tableStudents,
      where: whereString.isEmpty ? null : whereString,
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
      orderBy: orderBy,
    );

    return maps.map((m) => StudentModel.fromMap(m)).toList();
  }

  Future<int> updateStudent(StudentModel student) async {
    final db = await instance.database;
    return await db.update(
      AppConstants.tableStudents,
      student.toMap(),
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }

  Future<int> deleteStudent(int id) async {
    final db = await instance.database;
    return await db.delete(
      AppConstants.tableStudents,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ================= DASHBOARD & STATS =================

  Future<int> getStudentsCount() async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT COUNT(*) as total FROM ${AppConstants.tableStudents}');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<Map<String, int>> getDepartmentCounts() async {
    final db = await instance.database;
    final result = await db.rawQuery(
      'SELECT department, COUNT(*) as count FROM ${AppConstants.tableStudents} GROUP BY department',
    );

    Map<String, int> deptCounts = {};
    for (var row in result) {
      final dept = row['department'] as String? ?? 'Other';
      final count = row['count'] as int? ?? 0;
      deptCounts[dept] = count;
    }
    return deptCounts;
  }

  Future<Map<String, int>> getSemesterCounts() async {
    final db = await instance.database;
    final result = await db.rawQuery(
      'SELECT semester, COUNT(*) as count FROM ${AppConstants.tableStudents} GROUP BY semester',
    );

    Map<String, int> semCounts = {};
    for (var row in result) {
      final sem = row['semester'] as String? ?? 'Other';
      final count = row['count'] as int? ?? 0;
      semCounts[sem] = count;
    }
    return semCounts;
  }

  Future<List<StudentModel>> getRecentStudents({int limit = 5}) async {
    final db = await instance.database;
    final maps = await db.query(
      AppConstants.tableStudents,
      orderBy: 'created_at DESC',
      limit: limit,
    );
    return maps.map((m) => StudentModel.fromMap(m)).toList();
  }

  // ================= BACKUP & RESTORE UTILITIES =================

  /// Exports database contents as JSON string with schema metadata.
  Future<String> exportBackupData() async {
    final db = await instance.database;
    final students = await db.query(AppConstants.tableStudents);
    final users = await db.query(AppConstants.tableUsers);

    final backupPayload = {
      'app': AppConstants.appName,
      'schema_version': AppConstants.dbVersion,
      'timestamp': DateTime.now().toIso8601String(),
      'students_count': students.length,
      'users_count': users.length,
      'students': students,
      'users': users,
    };

    return jsonEncode(backupPayload);
  }

  /// Restores database from JSON backup string cleanly inside a transaction.
  Future<bool> restoreBackupData(String jsonString, {required bool replaceExisting}) async {
    final db = await instance.database;

    try {
      final Map<String, dynamic> data = jsonDecode(jsonString);
      if (!data.containsKey('students') || !data.containsKey('users')) {
        throw Exception('Invalid backup format: Missing required tables');
      }

      final List<dynamic> studentsList = data['students'] ?? [];
      final List<dynamic> usersList = data['users'] ?? [];

      await db.transaction((txn) async {
        if (replaceExisting) {
          await txn.delete(AppConstants.tableStudents);
          await txn.delete(AppConstants.tableUsers);
        }

        // Restore users
        for (var userMap in usersList) {
          final Map<String, dynamic> user = Map<String, dynamic>.from(userMap as Map);
          final existingUser = await txn.query(
            AppConstants.tableUsers,
            where: 'LOWER(email) = ?',
            whereArgs: [user['email'].toString().toLowerCase().trim()],
          );
          if (existingUser.isEmpty) {
            user.remove('id'); // let SQLite assign ID
            await txn.insert(AppConstants.tableUsers, user);
          }
        }

        // Restore students
        for (var studentMap in studentsList) {
          final Map<String, dynamic> student = Map<String, dynamic>.from(studentMap as Map);
          final rollNum = student['roll_number'].toString().toLowerCase().trim();

          final existingStudent = await txn.query(
            AppConstants.tableStudents,
            where: 'LOWER(roll_number) = ?',
            whereArgs: [rollNum],
          );

          if (existingStudent.isNotEmpty) {
            if (replaceExisting) {
              student.remove('id');
              await txn.update(
                AppConstants.tableStudents,
                student,
                where: 'LOWER(roll_number) = ?',
                whereArgs: [rollNum],
              );
            }
          } else {
            student.remove('id'); // let SQLite assign new ID if merging
            await txn.insert(AppConstants.tableStudents, student);
          }
        }
      });

      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> close() async {
    final db = await instance.database;
    await db.close();
  }
}
