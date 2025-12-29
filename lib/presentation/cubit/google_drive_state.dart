part of 'google_drive_cubit.dart';

sealed class GoogleDriveState extends Equatable {
  const GoogleDriveState();

  @override
  List<Object> get props => [];
}

final class GoogleDriveInitial extends GoogleDriveState {}
final class GoogleDriveLoading extends GoogleDriveState {}
final class GoogleDriveError extends GoogleDriveState {
  final String message;
  const GoogleDriveError(this.message);
}
final class GoogleDriveLoaded extends GoogleDriveState {
  final ListGdriveEntity data;
  const GoogleDriveLoaded(this.data);
}
