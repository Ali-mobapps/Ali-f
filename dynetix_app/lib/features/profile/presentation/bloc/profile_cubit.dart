import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/entities/profile_entity.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository repository;

  ProfileCubit(this.repository) : super(ProfileInitial());

  Future<void> fetchProfile(String email) async {
    emit(ProfileLoading());
    try {
      final profile = await repository.getProfile(email);
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> updateProfile(ProfileEntity profile, {String? localImagePath}) async {
    try {
      String? finalImageUrl = profile.profileImageUrl;
      
      if (localImagePath != null) {
        finalImageUrl = await repository.uploadProfileImage(localImagePath, profile.email);
      }
      
      final updatedProfile = profile.copyWith(profileImageUrl: finalImageUrl);
      await repository.updateProfile(updatedProfile);
      fetchProfile(profile.email);
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
