import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/auth_remote_data_source.dart';

// 1. Events
abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  LoginRequested(this.email, this.password);
}

// 2. User Data Model
class AuthUser {
  final String name;
  final String email;
  AuthUser({required this.name, required this.email});
}

// 3. States
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final AuthUser user;
  AuthAuthenticated(this.user);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

// 4. Bloc Class
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRemoteDataSource remoteDataSource;

  AuthBloc({required this.remoteDataSource}) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final res = await remoteDataSource.login(event.email, event.password);
        final userName = res['user']?['name'] ?? 'Ali Hassan';
        final userEmail = res['user']?['email'] ?? event.email;
        emit(AuthAuthenticated(AuthUser(name: userName, email: userEmail)));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
  }
}