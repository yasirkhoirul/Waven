part of 'booking_cubit.dart';

@immutable
sealed class BookingState {
  final List<UnivDropdown?>? data;
  final List<Addons>? dataaddons;
  final List<Addons>? datadiplih;
  final String? packageEntity;
  final String? paymentMethod;
  final String? paymentType;
  final String? nama;
  final String? nowa;
  final String? lokasi;
  final String? ig;
  final String? catatan;
  final String? univ;
  final String? tanggal;
  final String? starttime;
  final String? endtime;

  const BookingState({
    this.dataaddons,
    this.univ,
    this.tanggal,
    this.starttime,
    this.endtime,
    this.data,
    this.packageEntity,
    this.datadiplih,
    this.nama,
    this.nowa,
    this.lokasi,
    this.ig,
    this.catatan,
    this.paymentMethod,
    this.paymentType,
  });
}

final class BookingInitial extends BookingState {}

final class BookingLoading extends BookingState {}

final class BookingError extends BookingState {
  final String message;
  const BookingError(this.message);
}

final class BookingReady extends BookingState {
  const BookingReady({super.data, super.dataaddons});
}

final class Bookingtahap1 extends BookingState {
  const Bookingtahap1({
    super.univ,
    super.starttime,
    super.endtime,
    super.tanggal,
  });
}

final class Bookingtahap2 extends BookingState {
  const Bookingtahap2({
    super.packageEntity,
    super.nama,
    super.nowa,
    super.lokasi,
    super.ig,
    super.catatan,
    super.datadiplih,
  });
}
final class Bookingtahap3 extends BookingState {
  const Bookingtahap3({
    super.paymentMethod,
    super.paymentType,
  });
}

