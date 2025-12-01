part of 'auth_cubit.dart';

@immutable
class AuthState {}

final class AuthInitial extends AuthState {}
final class AuthLoading extends AuthState {}
final class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
final class AuthLoaded extends AuthState {
  final String message;
  AuthLoaded(this.message);
}
