part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  const ProfileState({this.data,this.requestState = RequestState.init, this.bookingId, this.status});
  final Profile? data;
  final String? bookingId;
  final String? status;
  final RequestState requestState;

  ProfileState copywith(
    {Profile? data,
    String? bookingId,
    String? status,
    RequestState? step}
  ){
    return ProfileState(
      data: data??this.data,
      requestState: step?? requestState,
      status: status??this.status,
      bookingId: bookingId??this.bookingId
    );
  }

  @override
  List<Object?> get props => [data,requestState,bookingId,status];
}