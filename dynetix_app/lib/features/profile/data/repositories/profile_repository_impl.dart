import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  SupabaseClient get _supabase => Supabase.instance.client;

  @override
  Future<ProfileEntity> getProfile(String email) async {
    try {
      final List<dynamic> data =
          await _supabase.from('users').select().eq('email', email).limit(1);

      if (data.isNotEmpty) {
        final user = data.first;
        return ProfileEntity(
          name: user['name'] ?? 'User',
          email: user['email'] ?? email,
          role: user['role'] ?? 'Customer',
          phone: user['phone'] ?? '+92 000 0000000',
          gender: user['gender'],
          profileImageUrl: user['profile_image_url'],
        );
      } else {
        return ProfileEntity(
          name: 'Dynetix User',
          email: email,
          role: 'Customer',
          phone: '+92 300 1234567',
          gender: 'Not Specified',
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
        'gender': profile.gender,
        'profile_image_url': profile.profileImageUrl,
      }).eq('email', profile.email);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  @override
  Future<String> uploadProfileImage(dynamic fileSource, String email) async {
    try {
      final String fileExt = 'jpg'; // Default or extract from path if string
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      // Use 'avatars' folder as per initial setup
      final String path = 'avatars/$email/$fileName';

      if (fileSource is List<int>) {
        await _supabase.storage.from('profiles').uploadBinary(
          path, 
          Uint8List.fromList(fileSource),
          fileOptions: const FileOptions(cacheControl: '3600', upsert: true)
        );
      } else {
        // This part will only run on mobile where File is supported
        // But we handle it generically to avoid crash on web
        await _supabase.storage.from('profiles').upload(path, fileSource,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: true));
      }

      final String imageUrl = _supabase.storage.from('profiles').getPublicUrl(path);
      // Supabase sometimes needs a cache buster for immediate updates
      return '$imageUrl?t=${DateTime.now().millisecondsSinceEpoch}';
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
}
