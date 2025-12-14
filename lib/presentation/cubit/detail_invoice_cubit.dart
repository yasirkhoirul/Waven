import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:waven/domain/entity/detail_invoice.dart';
import 'package:waven/domain/usecase/get_detail_invoice.dart';

part 'detail_invoice_state.dart';

class DetailInvoiceCubit extends Cubit<DetailInvoiceState> {
  DetailInvoiceCubit(this.getDetailInvoice) : super(DetailInvoiceInitial());
  final GetDetailInvoice getDetailInvoice;
  String? _lastInvoiceId;

  void ongetDetail(String idInvoice) async {
    _lastInvoiceId = idInvoice;
    emit(DetailInvoiceLoading());
    try {
      final data = await getDetailInvoice.execute(idInvoice);
      emit(DetailInvoiceLoaded(data));
    } catch (e) {
      if (e.toString().contains("401") ||
          e.toString().contains("Session Expired")) {
        emit(SessionExpired());
      }
      emit(DetailInvoiceerror(e.toString()));
    }
  }

  void refreshDetail() async {
    if (_lastInvoiceId != null) {
      ongetDetail(_lastInvoiceId!);
    }
  }
}
