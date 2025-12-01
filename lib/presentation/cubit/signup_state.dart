part of 'signup_cubit.dart';

@immutable
sealed class SignupState {}

final class SignupInitial extends SignupState {}
final class SignupLoading extends SignupState {}
final class SignupError extends SignupState {
  final String message;
  SignupError(this.message);
}
final class SignupLoaded extends SignupState {
  final String message;
  SignupLoaded(this.message);
}

