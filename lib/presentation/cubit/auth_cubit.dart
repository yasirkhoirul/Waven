import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/web.dart';
import 'package:waven/domain/usecase/get_token.dart';
import 'package:waven/domain/usecase/post_login.dart';
import 'package:waven/domain/usecase/post_logout.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final PostLogout postLogout;
  final PostLogin postLogin;
  final GetToken getToken;
  AuthCubit(this.postLogin, {required this.getToken, required this.postLogout}) : super(AuthInitial());

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
  
  void onLoginGoogle()async{
    try {
      final data = await postLogin.executeGoogle();
      emit(AuthRedirectGoogle("Silahkan Login Ke Google", data: data));
    } catch (e) {
      Logger().d(e.toString());
    }
  }

  void onInit(){
    emit(AuthInitial());
  }
  void onLogout(BuildContext context)async{
    try {
      await postLogout.execute();
      await getToken.execute();
      emit(AuthInitial());
      
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
