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
      final isMasterAdmin = cleanEmail == 'info@dynetixhub.com';

      // 1. First attempt regular Supabase Auth login
      try {
        final response = await _supabase.auth.signInWithPassword(
          email: cleanEmail,
          password: password,
        );

        if (response.user != null) {
          return _fetchUserProfile(response.user!.id, cleanEmail);
        }
      } catch (authErr) {
        // If auth fails, check if this is an authorized admin/team member created by admin
        final List<dynamic> whitelistCheck = await _supabase
            .from('users')
            .select()
            .eq('email', cleanEmail);

        if (whitelistCheck.isNotEmpty) {
          final userMap = Map<String, dynamic>.from(whitelistCheck.first);
          final userRole = (userMap['role'] ?? '').toString().toLowerCase();
          final isWhitelisted = userMap['is_whitelisted'] == true ||
              userRole == 'admin' ||
              userRole == 'team_member';
          final savedPass = (userMap['temp_password'] ?? '').toString();

          if (isWhitelisted && (savedPass.isNotEmpty && savedPass == password)) {
            // Authorized by Admin! Attempt to register or sign them into Supabase Auth seamlessly
            try {
              final signUpRes = await _supabase.auth.signUp(
                email: cleanEmail,
                password: password,
                data: {'name': userMap['name'] ?? cleanEmail.split('@').first},
              );
              if (signUpRes.user != null) {
                return _fetchUserProfile(signUpRes.user!.id, cleanEmail);
              }
            } catch (_) {
              // Sign up might fail if user already in Auth; try to update password
              try {
                await _supabase.auth.signInWithPassword(
                  email: cleanEmail,
                  password: password,
                );
              } catch (_) {}
            }

            // Return authorized UserModel directly so login succeeds
            return UserModel(
              id: userMap['id'] ?? cleanEmail,
              email: cleanEmail,
              role: userRole.isNotEmpty ? userRole : 'admin',
              name: userMap['name'] as String?,
            );
          }
        }

        if (authErr is AuthException) {
          if (authErr.message.toLowerCase().contains('email not confirmed')) {
            throw 'Please verify your email or disable Email Confirmation in Supabase Dashboard.';
          }
          throw authErr.message;
        }
        rethrow;
      }

      throw Exception('Login failed');
    } on AuthException catch (e) {
      if (e.message.toLowerCase().contains('email not confirmed')) {
        throw 'Please verify your email or disable Email Confirmation in Supabase Dashboard.';
      }
      throw e.message;
    } catch (e) {
      throw e.toString();
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

      // Create profile in public.users table
      try {
        await _supabase.from('users').upsert({
          'id': user.id,
          'email': cleanEmail,
          'name': name,
          'role': 'customer',
        });
      } catch (e) {
        // Log error properly or handle silently in production
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
  Future<void> updatePassword(String newPassword) async {
    await _supabase.auth.updateUser(
      UserAttributes(password: newPassword),
    );
  }

  @override
  Future<void> deleteAccount() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId != null) {
      // 1. Delete user record from public.users table
      await _supabase.from('users').delete().eq('id', userId);
      // 2. Note: Supabase auth user deletion usually requires admin privileges 
      // or an edge function. For now, we sign out and inform user.
      // In production, you would call an edge function here.
      await _supabase.auth.signOut();
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;
    return _fetchUserProfile(user.id, user.email ?? '');
  }

  Future<UserEntity> _fetchUserProfile(String id, String email) async {
    try {
      final cleanEmail = email.trim().toLowerCase();
      final isMasterAdmin = cleanEmail == 'info@dynetixhub.com';

      // 1. Check by email first (for whitelisted / added team members)
      if (cleanEmail.isNotEmpty) {
        final List<dynamic> emailData =
            await _supabase.from('users').select().eq('email', cleanEmail);
        if (emailData.isNotEmpty) {
          final profileData = Map<String, dynamic>.from(emailData.first);
          if (isMasterAdmin) {
            profileData['role'] = 'admin';
          } else if (profileData['is_whitelisted'] == true &&
              (profileData['role'] == null || profileData['role'] == 'customer')) {
            profileData['role'] = 'admin';
          }
          return UserModel.fromJson(profileData);
        }
      }

      // 2. Check by id
      final List<dynamic> data =
          await _supabase.from('users').select().eq('id', id);

      if (data.isNotEmpty) {
        final profileData = Map<String, dynamic>.from(data.first);
        if (isMasterAdmin) {
          profileData['role'] = 'admin';
        }
        return UserModel.fromJson(profileData);
      }

      // 3. Fallback default data
      final defaultData = {
        'id': id,
        'email': cleanEmail,
        'name': cleanEmail.split('@').first,
        'role': isMasterAdmin ? 'admin' : 'customer',
      };

      _supabase
          .from('users')
          .insert(defaultData)
          .then((_) => print('Default profile created'))
          .catchError((e) => print('Profile insert error: $e'));

      return UserModel.fromJson(defaultData);
    } catch (e) {
      final cleanEmail = email.trim().toLowerCase();
      return UserModel(
        id: id,
        email: cleanEmail,
        role: cleanEmail == 'info@dynetixhub.com' ? 'admin' : 'customer',
        name: cleanEmail.split('@').first,
      );
    }
  }
}
