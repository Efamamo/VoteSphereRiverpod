import 'package:meta/meta.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class LoginNavigateToSignupState extends AuthState {}

class SignupNavigateToLoginState extends AuthState {}

class LogInSuccessState extends AuthState {}

class LogInErrorState extends AuthState {
  final String error;
  LogInErrorState({required this.error});
}

class SignUpSuccessState extends AuthState {}

class SignupError extends AuthState {
  final String error;
  SignupError({required this.error});
}

class SignoutState extends AuthState {}
