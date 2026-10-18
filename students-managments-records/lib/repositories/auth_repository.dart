import '../core/utilities/password_hasher.dart';
import '../database/database_helper.dart';
import '../models/user_model.dart';

class AuthRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<UserModel> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    final existingUser = await _dbHelper.getUserByEmail(email);
    if (existingUser != null) {
      throw Exception('An account with this email already exists.');
    }

    final passwordHash = PasswordHasher.hashPassword(password);
    final user = UserModel(
      name: name.trim(),
      email: email.trim().toLowerCase(),
      passwordHash: passwordHash,
      createdAt: DateTime.now().toIso8601String(),
    );

    final id = await _dbHelper.insertUser(user);
    return user.copyWith(id: id);
  }

  Future<UserModel> loginUser({
    required String email,
    required String password,
  }) async {
    final user = await _dbHelper.getUserByEmail(email);
    if (user == null) {
      throw Exception('No user found with this email address.');
    }

    final isValid = PasswordHasher.verifyPassword(password, user.passwordHash);
    if (!isValid) {
      throw Exception('Incorrect password. Please try again.');
    }

    return user;
  }

  Future<UserModel?> getUserById(int id) async {
    return await _dbHelper.getUserById(id);
  }

  Future<UserModel> updateProfile({
    required int id,
    required String name,
    required String email,
    String? newPassword,
  }) async {
    final currentUser = await _dbHelper.getUserById(id);
    if (currentUser == null) {
      throw Exception('User account not found.');
    }

    // Check if email changed and is taken
    if (email.trim().toLowerCase() != currentUser.email.toLowerCase()) {
      final existing = await _dbHelper.getUserByEmail(email);
      if (existing != null) {
        throw Exception('Email is already in use by another account.');
      }
    }

    String passwordHash = currentUser.passwordHash;
    if (newPassword != null && newPassword.isNotEmpty) {
      passwordHash = PasswordHasher.hashPassword(newPassword);
    }

    final updatedUser = currentUser.copyWith(
      name: name.trim(),
      email: email.trim().toLowerCase(),
      passwordHash: passwordHash,
    );

    await _dbHelper.updateUser(updatedUser);
    return updatedUser;
  }
}
