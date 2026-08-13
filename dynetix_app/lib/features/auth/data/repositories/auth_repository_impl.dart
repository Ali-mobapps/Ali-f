import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  SupabaseClient get _supabase => Supabase.instance.client;

  AuthRepositoryImpl();

  @override
  Future<UserEntity> login(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) throw Exception('User not found');

      // Fetch user data from public.users table (equivalent to Firestore users collection)
      final userData = await _supabase
          .from('users')
          .select()
          .eq('id', user.id)
          .single();

      return UserModel(
        id: user.id,
        email: user.email ?? '',
        role: userData['role'] ?? 'customer',
        name: userData['name'],
      );
    } on AuthException catch (e) {
      throw e.message;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<UserEntity> signUp(String email, String password, String name) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );

      final user = response.user;
      if (user == null) throw Exception('User creation failed');

      // Create user entry in public.users table
      await _supabase.from('users').insert({
        'id': user.id,
        'email': email,
        'name': name,
        'role': 'customer',
      });

      return UserModel(
        id: user.id,
        email: email,
        role: 'customer',
        name: name,
      );
    } on AuthException catch (e) {
      throw e.message;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    try {
      final userData = await _supabase
          .from('users')
          .select()
          .eq('id', user.id)
          .single();

      return UserModel(
        id: user.id,
        email: user.email ?? '',
        role: userData['role'] ?? 'customer',
        name: userData['name'],
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> logout() async {
    await _supabase.auth.signOut();
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw e.toString();
    }
  }
}
