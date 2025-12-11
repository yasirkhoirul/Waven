part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  const ProfileState({this.data,this.requestState = RequestState.init});
  final Profile? data;
  final RequestState requestState;

  ProfileState copywith(
    {Profile? data,
    RequestState? step}
  ){
    return ProfileState(
      data: data??this.data,
      requestState: step?? requestState
    );
  }

  @override
  List<Object?> get props => [data,requestState];
}