import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dynetix_app/core/services/database_service.dart';
import 'package:dynetix_app/core/services/supabase_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
    on<SignedUp>(_onSignedUp);
    on<LoggedOut>(_onLoggedOut);
  }

  void _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    await AppDatabase.initializeUserSession();
    if (AppDatabase.currentUser != null) {
      emit(Authenticated(AppDatabase.currentUser!));
    } else {
      emit(Unauthenticated());
    }
  }

  void _onLoggedIn(LoggedIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await SupabaseService.signIn(event.email, event.password);
      await AppDatabase.initializeUserSession();
      if (AppDatabase.currentUser != null) {
        emit(Authenticated(AppDatabase.currentUser!));
      } else {
        emit(AuthError("User session initialization failed."));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onSignedUp(SignedUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await SupabaseService.signUp(event.email, event.password, event.fullName);
      await AppDatabase.initializeUserSession();
      if (AppDatabase.currentUser != null) {
        emit(Authenticated(AppDatabase.currentUser!));
      } else {
        emit(AuthError("Signup successful but session failed."));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onLoggedOut(LoggedOut event, Emitter<AuthState> emit) async {
    AppDatabase.logout();
    emit(Unauthenticated());
  }
}
