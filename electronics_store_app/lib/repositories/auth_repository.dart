import '../database/database_helper.dart';
import '../models/user_model.dart';

class AuthRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<UserModel?> login(String email, String password) async {
    final db = await _dbHelper.database;
    final passwordHash = _dbHelper.hashPassword(password);

    final results = await db.query(
      'users',
      where: 'email = ? AND password_hash = ?',
      whereArgs: [email.trim().toLowerCase(), passwordHash],
    );

    if (results.isNotEmpty) {
      return UserModel.fromMap(results.first);
    }
    return null;
  }

  Future<UserModel?> signup({
    required String name,
    required String email,
    required String password,
    String role = 'customer',
    String? phone,
    String? address,
  }) async {
    final db = await _dbHelper.database;

    // Check if email already exists
    final existing = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email.trim().toLowerCase()],
    );

    if (existing.isNotEmpty) {
      throw Exception('Email is already registered');
    }

    final passwordHash = _dbHelper.hashPassword(password);
    final now = DateTime.now().toIso8601String();

    final user = UserModel(
      name: name.trim(),
      email: email.trim().toLowerCase(),
      passwordHash: passwordHash,
      role: role,
      phone: phone?.trim(),
      address: address?.trim(),
      createdAt: now,
    );

    final id = await db.insert('users', user.toMap());
    return user.copyWith(id: id);
  }

  Future<UserModel?> getUserById(int id) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return UserModel.fromMap(results.first);
    }
    return null;
  }

  Future<void> updateProfile(UserModel user) async {
    final db = await _dbHelper.database;
    await db.update(
      'users',
      {
        'name': user.name,
        'phone': user.phone,
        'address': user.address,
      },
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }
}
