import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/web.dart';
import 'package:waven/domain/usecase/get_token.dart';
import 'package:waven/domain/usecase/post_login.dart';
import 'package:web/web.dart' as web; 
import 'dart:js_interop';
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
  
  void onLoginGoogle(StreamSubscription<web.MessageEvent>? stream)async{
    try {
     final String myOrigin = web.window.location.origin;

    // 2. Susun URL
    final String backendUrl = 'https://waven-development.site/v1/auth/google/login'
        '?origin=${Uri.encodeComponent(myOrigin)}';

    // 3. Listen Message
    // web.window.onMessage stream mengembalikan object 'MessageEvent'
    stream = web.window.onMessage.listen((web.MessageEvent event) {
      
      // KONVERSI PENTING:
      // event.data adalah objek JavaScript (JSAny).
      // Kita harus ubah ke Dart Object menggunakan .dartify()
      final data = event.data.dartify();

      // Cek apakah data berhasil diubah jadi Map
      if (data is Map) {
        // Sesuaikan key dengan JSON backend kamu
        if (data.containsKey('token')) {
          final token = data['token'];
          print("Token diterima via package:web: $token");

          stream?.cancel();
          emit(AuthRedirectGoogle("sukses", data: token.toString()));
        }
      }
    });

    // 4. Buka Popup (cara baru via package:web)
    // Parameter ke-3 'options' bertipe String
    web.window.open(backendUrl, "Google Login", "width=500,height=600");
    } catch (e) {
      emit(AuthRedirectGoogle("gaga;", data: "gagal ${e.toString()}"));
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
