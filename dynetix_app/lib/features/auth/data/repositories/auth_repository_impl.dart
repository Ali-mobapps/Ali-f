import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Future<UserEntity> login(String email, String password) async {
    final response = await _supabase.auth.signInWithPassword(email: email, password: password);
    if (response.user == null) throw Exception('Login failed');
    
    return _fetchUserProfile(response.user!.id, email);
  }

  @override
  Future<UserEntity> signUp(String email, String password, String name) async {
    final response = await _supabase.auth.signUp(email: email, password: password, data: {'full_name': name});
    if (response.user == null) throw Exception('Signup failed');

    // Create profile in public.users table
    await _supabase.from('users').insert({
      'id': response.user!.id,
      'email': email,
      'name': name,
      'role': 'customer',
    });

    return UserModel(id: response.user!.id, email: email, role: 'customer', name: name);
  }

  @override
  Future<void> logout() async {
    await _supabase.auth.signOut();
  }

  @override
  Future<void> resetPassword(String email) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;
    return _fetchUserProfile(user.id, user.email ?? '');
  }

  Future<UserEntity> _fetchUserProfile(String id, String email) async {
    final data = await _supabase.from('users').select().eq('id', id).single();
    return UserModel.fromJson(data);
  }
}
