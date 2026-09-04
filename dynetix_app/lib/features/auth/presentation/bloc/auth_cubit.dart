import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';
import '../../../../core/notifications/notification_service.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repository;

  AuthCubit(this.repository) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await repository.login(email, password);
      emit(AuthAuthenticated(user));
      // Save FCM token to Supabase after successful login
      NotificationService.updateDeviceToken();
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    emit(AuthLoading());
    try {
      await repository.signUp(email, password, name);
      emit(AuthSignUpSuccess('Account created successfully! Please sign in to continue.'));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> checkAuth() async {
    try {
      final user = await repository.getCurrentUser();
      if (user != null) {
        emit(AuthAuthenticated(user));
        // Refresh FCM token on app start if user is already authenticated
        NotificationService.updateDeviceToken();
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (_) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> logout() async {
    await repository.logout();
    emit(AuthUnauthenticated());
  }

  Future<void> forgotPassword(String email) async {
    try {
      await repository.resetPassword(email);
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> updatePassword(String newPassword) async {
    emit(AuthLoading());
    try {
      await repository.updatePassword(newPassword);
      emit(AuthInitial()); // Reset to initial state or success state
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> deleteAccount() async {
    emit(AuthLoading());
    try {
      await repository.deleteAccount();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
