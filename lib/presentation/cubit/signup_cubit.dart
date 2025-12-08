import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:waven/common/constant.dart';
import 'package:waven/data/model/univ_drop_model.dart';
import 'package:waven/domain/entity/univ_dropdown.dart';
import 'package:waven/domain/entity/user.dart';
import 'package:waven/domain/usecase/get_univdropdown.dart';
import 'package:waven/domain/usecase/post_signup.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final PostSignup postSignup;
  final GetUnivdropdown getUnivdropdown;
  SignupCubit(this.postSignup, {required this.getUnivdropdown}) : super(SignupInitial(RequestState.init,[]));

  void onSignup(User data)async{
    emit(SignupLoading());
    try {
      final response = await postSignup.execute(data);
      emit(SignupLoaded(response));
    } catch (e) {
      emit(SignupError(e.toString()));
    }

  }

  void getUnivdrop()async{
    emit(SignupInitial(RequestState.loading, []));
    try {
      final data = await getUnivdropdown.execute();
      emit(SignupInitial(RequestState.loaded, data));
      
    } catch (e) {
      emit(SignupInitial(RequestState.error, []));
      return;
    }
  }

  void init(){
    emit(SignupInitial(RequestState.init, []));
  }
}
