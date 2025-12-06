part of 'package_detail_cubit.dart';

@immutable
sealed class PackageDetailState {}

final class PackageDetailInitial extends PackageDetailState {}
final class PackageDetailLoading extends PackageDetailState {}
final class PackageDetailError extends PackageDetailState {
  final String message;
  PackageDetailError(this.message);

}
final class PackageDetailLoaded extends PackageDetailState {
  final DetailPackageEntity data;
  PackageDetailLoaded(this.data);
}
