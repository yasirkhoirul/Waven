import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
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
      Logger().d("Loading page: $page dengan limit: $limit");
      final data = await getListInvoiceUser.execute(page, limit);
      Logger().d("Data diterima: ${data.data.length} items");
      Logger().d("Current state listdata: ${state.listdata.length} items");
      
      // Jika page pertama, replace semua data
      if (page == 1) {
        Logger().d("Page 1 - Replace semua data");
        emit(ListInvoiceState(
          step: RequestState.loaded,
          data: data,
          listdata: data.data,
        ));
      } else {
        // Jika page > 1, append data yang baru
        Logger().d("Page $page - Append data baru");
        final newList = [...state.listdata, ...data.data];
        Logger().d("Total setelah append: ${newList.length} items");
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
