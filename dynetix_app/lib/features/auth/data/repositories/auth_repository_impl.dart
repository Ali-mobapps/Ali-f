import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Future<UserEntity> login(String email, String password) async {
    try {
      final cleanEmail = email.trim().toLowerCase();
      final response = await _supabase.auth.signInWithPassword(
        email: cleanEmail, 
        password: password
      );
      
      if (response.user == null) throw Exception('Login failed');
      
      return _fetchUserProfile(response.user!.id, cleanEmail);
    } on AuthException catch (e) {
      if (e.message.toLowerCase().contains('email not confirmed')) {
        throw 'Please verify your email or disable Email Confirmation in Supabase Dashboard.';
      }
      throw e.message;
    } catch (e) {
      throw 'An unexpected error occurred during login.';
    }
  }

  @override
  Future<UserEntity> signUp(String email, String password, String name) async {
    try {
      final cleanEmail = email.trim().toLowerCase();
      
      final response = await _supabase.auth.signUp(
        email: cleanEmail,
        password: password,
        data: {'name': name},
      );

      final user = response.user;
      if (user == null) throw Exception('Signup failed: No user returned');

      // Create profile in public.users table - Do it in background so it doesn't block
      _supabase.from('users').upsert({
        'id': user.id,
        'email': cleanEmail,
        'name': name,
        'role': 'customer',
      }).then((_) => print('Profile synced')).catchError((e) => print('Profile sync error: $e'));

      if (response.session == null) {
        throw 'Account created! Please confirm your email OR disable Email Confirmation in Supabase settings to login directly.';
      }

      return UserModel(id: user.id, email: cleanEmail, role: 'customer', name: name);
    } on AuthException catch (e) {
      throw e.message;
    } catch (e) {
      throw e.toString();
    }
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
    try {
      final List<dynamic> data = await _supabase.from('users').select().eq('id', id);
      
      if (data.isEmpty) {
        // Automatically set 'admin' role for your specific admin email
        final isMasterAdmin = email.toLowerCase() == 'admin@dynetix.com';
        
        final defaultData = {
          'id': id,
          'email': email,
          'name': email.split('@').first,
          'role': isMasterAdmin ? 'admin' : 'customer',
        };
        
        // Try to save this profile in the background
        _supabase.from('users').insert(defaultData).then((_) => print('Default profile created')).catchError((e) => print('Profile insert error: $e'));
        
        return UserModel.fromJson(defaultData);
      }
      
      return UserModel.fromJson(data.first);
    } catch (e) {
      // Fallback if table doesn't exist yet
      return UserModel(
        id: id, 
        email: email, 
        role: email.toLowerCase() == 'admin@dynetix.com' ? 'admin' : 'customer',
        name: email.split('@').first
      );
    }
  }
}
