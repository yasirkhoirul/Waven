part of 'booking_cubit.dart';


class BookingState extends Equatable {
  final BookingStep step; // Penanda kita ada di tahap mana
  final String? errorMessage;
  
  // Data Form
  final List<UnivDropdown?>? data;
  final List<Addons>? dataaddons;
  final List<Addons>? datadiplih;
  final PackageEntity? packageEntity;
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
  final double amount;
  final Invoice? invoice;

  const BookingState({
    this.step = BookingStep.initial,
    this.amount = 0,
    this.errorMessage,
    this.data,
    this.dataaddons,
    this.datadiplih,
    this.packageEntity,
    this.paymentMethod,
    this.paymentType,
    this.nama,
    this.nowa,
    this.lokasi,
    this.ig,
    this.catatan,
    this.univ,
    this.tanggal,
    this.starttime,
    this.endtime, this.invoice,
  });

  // Fitur KUNCI: copyWith
  // Ini menduplikasi state lama dan hanya mengganti field yang kita mau
  BookingState copyWith({
    BookingStep? step,
    String? errorMessage,
    List<UnivDropdown?>? data,
    List<Addons>? dataaddons,
    List<Addons>? datadiplih,
    PackageEntity? packageEntity,
    String? paymentMethod,
    String? paymentType,
    String? nama,
    String? nowa,
    String? lokasi,
    String? ig,
    String? catatan,
    String? univ,
    String? tanggal,
    String? starttime,
    String? endtime,
    double? amount,
    Invoice? invoice,
  }) {
    return BookingState(
      step: step ?? this.step,
      errorMessage: errorMessage ?? this.errorMessage,
      data: data ?? this.data,
      dataaddons: dataaddons ?? this.dataaddons,
      datadiplih: datadiplih ?? this.datadiplih,
      packageEntity: packageEntity ?? this.packageEntity,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentType: paymentType ?? this.paymentType,
      nama: nama ?? this.nama,
      nowa: nowa ?? this.nowa,
      lokasi: lokasi ?? this.lokasi,
      ig: ig ?? this.ig,
      catatan: catatan ?? this.catatan,
      univ: univ ?? this.univ,
      tanggal: tanggal ?? this.tanggal,
      starttime: starttime ?? this.starttime,
      endtime: endtime ?? this.endtime,
      amount: amount??this.amount,
      invoice: invoice??this.invoice
    );
  }

  @override
  List<Object?> get props => [
        step, errorMessage, data, dataaddons, datadiplih, packageEntity,
        paymentMethod, paymentType, nama, nowa, lokasi, ig, catatan,
        univ, tanggal, starttime, endtime,amount,invoice
      ];
}

final class BookingSessionExpired extends BookingState{}