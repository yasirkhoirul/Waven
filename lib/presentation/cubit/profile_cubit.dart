import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:waven/common/constant.dart';
import 'package:waven/domain/entity/profile.dart';
import 'package:waven/domain/usecase/get_profile.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this.getProfile) : super(ProfileState());
  final GetProfile getProfile;

  void onGetdata()async{
    
    emit(state.copywith(step:  RequestState.loading));
    try {
      final data = await getProfile.execute();
      emit(state.copywith(step: RequestState.loaded, data: data));
    } catch (e) {
      emit(state.copywith(step: RequestState.error));
    }
  }
}
