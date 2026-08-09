import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AppStarted extends AuthEvent {}

class LoggedIn extends AuthEvent {
  final String email;
  final String password;
  LoggedIn(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class SignedUp extends AuthEvent {
  final String email;
  final String password;
  final String fullName;
  SignedUp(this.email, this.password, this.fullName);

  @override
  List<Object?> get props => [email, password, fullName];
}

class LoggedOut extends AuthEvent {}
