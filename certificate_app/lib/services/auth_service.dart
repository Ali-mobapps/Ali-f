import 'dart:async';
import '../core/database_helper.dart';

class LocalUser {
  final String uid;
  final String email;

  LocalUser({required this.uid, required this.email});
}

class AuthService {
  static final _userStreamController = StreamController<LocalUser?>.broadcast();
  
  Stream<LocalUser?> get user async* {
    yield _currentUser;
    yield* _userStreamController.stream;
  }

  static LocalUser? _currentUser;
  LocalUser? get currentUser => _currentUser;

  Future<String?> getUserRole(String uid) async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query(
      'users',
      columns: ['role'],
      where: 'uid = ?',
      whereArgs: [uid],
    );

    if (maps.isNotEmpty) {
      return maps.first['role'] as String?;
    }
    return 'issuer';
  }

  Future<bool> signIn(String email, String password) async {
    // For local mode, we'll accept any password for the admin email
    // Or check against a local table. 
    // Here we'll simplify: admin@certifypro.com / admin123
    if (email == 'admin@certifypro.com' && password == 'admin123') {
      _currentUser = LocalUser(uid: 'admin_uid', email: email);
      _userStreamController.add(_currentUser);
      return true;
    }
    return false;
  }

  void signOut() {
    _currentUser = null;
    _userStreamController.add(null);
  }
}
