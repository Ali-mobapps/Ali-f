import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  // Temporary in-memory storage for profiles based on email
  ProfileEntity _cachedProfile = const ProfileEntity(
    name: 'Dynetix User',
    email: 'user@dynetix.com',
    role: 'Customer',
    phone: '+92 300 1234567',
  );

  @override
  Future<ProfileEntity> getProfile(String email) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (email.contains('admin')) {
      return ProfileEntity(
        name: 'Dynetix Admin',
        email: email,
        role: 'Administrator',
        phone: '+92 321 9876543',
      );
    }
    return _cachedProfile.copyWith(email: email);
  }

  @override
  Future<void> updateProfile(ProfileEntity profile) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _cachedProfile = profile;
  }
}
