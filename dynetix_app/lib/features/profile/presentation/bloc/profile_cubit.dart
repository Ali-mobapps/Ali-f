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

  Future<void> updateProfile(ProfileEntity profile) async {
    try {
      await repository.updateProfile(profile);
      fetchProfile(profile.email);
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
