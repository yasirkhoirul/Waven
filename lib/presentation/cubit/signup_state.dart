part of 'signup_cubit.dart';

@immutable
sealed class SignupState {}

final class SignupInitial extends SignupState {
  final RequestState constantclass;
  final List<UnivDropdown> datauniv;

  SignupInitial({this.constantclass = RequestState.init, this.datauniv = const[]});
  SignupInitial copyWith({
    RequestState? requestate,
    List<UnivDropdown>? listdata,
  }) {
    return SignupInitial(constantclass:  requestate ?? constantclass,datauniv:  listdata ?? datauniv);
  }

  SignupInitial appendData({
    List<UnivDropdown>? listdata,
  }){
    return copyWith(listdata: [...datauniv,...listdata??[]],requestate: RequestState.loaded);
  }
}

final class SignupLoading extends SignupState {}

final class SignupError extends SignupState {
  final String message;
  SignupError(this.message);
}

final class SignupLoaded extends SignupState {
  final String message;
  SignupLoaded(this.message);
}
