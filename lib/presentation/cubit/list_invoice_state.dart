part of 'list_invoice_cubit.dart';

class ListInvoiceState extends Equatable {
  final RequestState step;
  final ListInvoiceUserEntity? data;
  final List<BookingDataEntity> listdata;
  const ListInvoiceState({
    this.data,
    this.listdata = const [],
    this.step = RequestState.init,
  });

  ListInvoiceState copyWith({
    ListInvoiceUserEntity? data,
    List<BookingDataEntity>? listdata,
    RequestState? step,
  }) {
    // Untuk error state, tetap gunakan old listdata
    return ListInvoiceState(
      step: step ?? this.step,
      data: data ?? this.data,
      listdata: listdata ?? this.listdata,
    );
  }

  @override
  List<Object?> get props => [step, listdata,data];
}
