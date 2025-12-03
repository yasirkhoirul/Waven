import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:waven/domain/usecase/get_token.dart';
import 'package:waven/domain/usecase/post_login.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final PostLogin postLogin;
  final GetToken getToken;
  AuthCubit(this.postLogin, {required this.getToken}) : super(AuthInitial());

  void onLogin(String ur,String pw)async{
    emit(AuthLoading());
    try {
      final response  = await postLogin.execute(ur, pw);
      final token = await getToken.execute();
      emit(AuthLoaded(response, data: token??''));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
  void onInit(){
    emit(AuthInitial());
  }
}
