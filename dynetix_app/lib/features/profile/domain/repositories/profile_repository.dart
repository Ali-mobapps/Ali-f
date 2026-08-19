import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<ProfileEntity> getProfile(String email);
  Future<void> updateProfile(ProfileEntity profile);
  Future<String> uploadProfileImage(dynamic fileSource, String email);
}
