import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:waven/common/constant.dart';
import 'package:waven/domain/entity/univ_dropdown.dart';
import 'package:waven/domain/entity/user.dart';
import 'package:waven/domain/usecase/get_univdropdown.dart';
import 'package:waven/domain/usecase/post_signup.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final PostSignup postSignup;
  final GetUnivdropdown getUnivdropdown;
  SignupCubit(this.postSignup, {required this.getUnivdropdown}) : super(SignupInitial());

  void onSignup(User data)async{
    emit(SignupLoading());
    try {
      final response = await postSignup.execute(data);
      emit(SignupLoaded(response));
    } catch (e) {
      emit(SignupError(e.toString()));
    }

  }

  Future<List<UnivDropdown>> getUnivdrop(int page,int limit,String? search)async{
    Logger().d("dipanggil");
    try {
      final data = await getUnivdropdown.execute(page,limit,search: search);
      Logger().d("dipanggil dan inni datanya$data");
      return data;
    } catch (e) {
      return [];
    }
  }

  
  void appendData(int page,int limit)async{
    final current = state is SignupInitial ? state as SignupInitial : SignupInitial();
    try {
      final data = await getUnivdropdown.execute(page,limit);
      // append new data to existing list without emitting an intermediate loading state
      emit(current.appendData(listdata: data));
    } catch (e) {
      // on error, keep current data but mark as error
      emit(current.copyWith(requestate: RequestState.error));
      return;
    }
  }

  void init(){
    emit(SignupInitial());
  }
}
