part of 'detail_invoice_cubit.dart';

sealed class DetailInvoiceState extends Equatable {
  const DetailInvoiceState();

  @override
  List<Object> get props => [];
}

final class DetailInvoiceInitial extends DetailInvoiceState {}
final class DetailInvoiceLoading extends DetailInvoiceState {}
final class DetailInvoiceerror extends DetailInvoiceState {
  final String message;
  const DetailInvoiceerror(this.message);
}
final class DetailInvoiceLoaded extends DetailInvoiceState {
  final DetailInvoiceDataEntity data;
  const DetailInvoiceLoaded(this.data);

  @override
  List<Object> get props => [data];
}

final class SessionExpired extends DetailInvoiceState{}
