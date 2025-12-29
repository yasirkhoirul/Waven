import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/web.dart';
import 'package:waven/common/constant.dart';
import 'package:waven/domain/entity/list_invoice_user.dart';
import 'package:waven/domain/usecase/get_list_invoice_user.dart';

part 'list_invoice_state.dart';

class ListInvoiceCubit extends Cubit<ListInvoiceState> {
  final GetListInvoiceUser getListInvoiceUser;
  ListInvoiceCubit(this.getListInvoiceUser) : super(ListInvoiceState());

  void getLoad(int page,int limit)async{
    emit(state.copyWith(step: RequestState.loading));
    try {
      final data = await getListInvoiceUser.execute(page, limit);
      Logger().d("ini adlaah dari cubit : ${data.data.first.photoReslutUrl}");
      
      // Jika page pertama, replace semua data
      if (page == 1) {
        emit(ListInvoiceState(
          step: RequestState.loaded,
          data: data,
          listdata: data.data,
        ));
      } else {
        final newList = [...state.listdata, ...data.data];
        emit(ListInvoiceState(
          step: RequestState.loaded,
          data: data,
          listdata: newList,
        ));
      }
    } catch (e) {
      if (e.toString().contains("401") ||
          e.toString().contains("Session Expired")) {
        emit(SessionExpired());
      }
      Logger().e("Error: $e");
      emit(state.copyWith(step: RequestState.error));
    }
  }
  void getRefresh(){
    emit(state.copyWith(listdata: [],data: ListInvoiceUserEntity(message: '', metadata: MetadataEntity(count: 0, page: 1, limit: 2), data: [])));
  }
}
