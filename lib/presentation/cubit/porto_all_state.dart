part of 'porto_all_cubit.dart';

@immutable
sealed class PortoAllState {}

final class PortoAllInitial extends PortoAllState {}
final class PortoAllLoading extends PortoAllState {}
final class PortoAllError extends PortoAllState {
  final String message;
  PortoAllError(this.message);

}
final class PortoAllLoaded extends PortoAllState {
  final List<PortoEntity> data;
  PortoAllLoaded(this.data);
}
