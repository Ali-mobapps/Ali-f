import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  SupabaseClient get _supabase => Supabase.instance.client;

  @override
  Future<ProfileEntity> getProfile(String email) async {
    try {
      final List<dynamic> data = await _supabase
          .from('users')
          .select()
          .eq('email', email)
          .limit(1);

      if (data.isNotEmpty) {
        final user = data.first;
        return ProfileEntity(
          name: user['name'] ?? 'User',
          email: user['email'] ?? email,
          role: user['role'] ?? 'Customer',
          phone: user['phone'] ?? '+92 000 0000000',
        );
      } else {
        return ProfileEntity(
          name: 'Dynetix User',
          email: email,
          role: 'Customer',
          phone: '+92 300 1234567',
        );
      }
    } catch (e) {
      throw Exception('Failed to fetch profile: $e');
    }
  }

  @override
  Future<void> updateProfile(ProfileEntity profile) async {
    try {
      await _supabase.from('users').update({
        'name': profile.name,
        'phone': profile.phone,
        'role': profile.role,
      }).eq('email', profile.email);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }
}
