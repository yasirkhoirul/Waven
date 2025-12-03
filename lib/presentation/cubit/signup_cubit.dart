import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:waven/domain/entity/user.dart';
import 'package:waven/domain/usecase/post_signup.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final PostSignup postSignup;
  SignupCubit(this.postSignup) : super(SignupInitial());

  void onSignup(User data)async{
    emit(SignupLoading());
    try {
      final response = await postSignup.execute(data);
      emit(SignupLoaded(response));
    } catch (e) {
      emit(SignupError(e.toString()));
    }

  }

  void init(){
    emit(SignupInitial());
  }
}
