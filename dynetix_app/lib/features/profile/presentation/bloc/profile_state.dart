import '../../domain/entities/profile_entity.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileEntity profile;

  ProfileLoaded(this.profile);
}

class ProfileUpdateSuccess extends ProfileState {
  final ProfileEntity profile;
  final String message;

  ProfileUpdateSuccess(this.profile, this.message);
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}
