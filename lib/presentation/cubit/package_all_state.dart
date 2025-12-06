part of 'package_all_cubit.dart';

@immutable
sealed class PackageAllState {}

final class PackageAllInitial extends PackageAllState {}
final class PackageAllLoading extends PackageAllState {}
final class PackageAllError extends PackageAllState {
  final String message;
  PackageAllError(this.message);

}
final class PackageAllLoaded extends PackageAllState {
  final List<PackageEntity> data;
  PackageAllLoaded(this.data);
}
