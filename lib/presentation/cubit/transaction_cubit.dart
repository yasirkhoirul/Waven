import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/web.dart';
import 'package:waven/common/constant.dart';
import 'package:waven/data/model/transactionmodel.dart';
import 'package:waven/domain/entity/transaction.dart';
import 'package:waven/domain/usecase/get_check_transaction.dart';
import 'package:waven/domain/usecase/post_transaction.dart';

part 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  final PostTransaction postTransaction;
  final GetCheckTransaction getCheckTransaction;
  final ImagePicker imagePicker;
  TransactionCubit(this.imagePicker, {required this.postTransaction, required this.getCheckTransaction})
    : super(TransactionInitial());

  void pickimage() async {
    try {
      final data = await imagePicker.pickImage(source: ImageSource.gallery);
      final dataready = await data!.readAsBytes();
      emit(state.copyWith(images: dataready));
    } catch (e) {
      emit(state.copyWith(errormessage: e.toString()));
    }
  }

  void inUnpaidAmount(int amount, String type) async {
    Logger().d("inunpaiddipanggil $type");
    int amountTotal = amount;
    if (type == "DP") {
      amountTotal = amount ~/ 2;
      emit(state.copyWith(unpaidAmount: amountTotal));
      Logger().d(state.unpaidAmount);
    } else {
      emit(state.copyWith(unpaidAmount: amountTotal));
    }
  }

  void toTransaction(String paymentType,String paymentMethod) async {
    emit(state.copyWith(step: RequestState.loading));
    final payload = TransactionRequest(
      paymentType: paymentType,
      paymentMethod: paymentMethod,
      amount: state.unpaidAmount,
    );
    if (state.transactionid==null) {
      emit(state.copyWith(step: RequestState.error,errormessage: "tidak ada request id"));
      return;
    }
    try {
      final data = await postTransaction.execute(
        payload,
        state.transactionid!,
        image: state.image,
      );
      emit(state.copyWith(checkQris: false, step: RequestState.loaded,transactionEntityDetail: data));
    } catch (e) {
      emit(state.copyWith(step: RequestState.error,errormessage: e.toString()));
    }
  }

  void initIdInvoice(String id){
    emit(state.copyWith(transactionid: id));
  }

  void resetState() {
    emit(TransactionInitial());
  }

  Future<void> checkTransaction()async{
    emit(state.copyWith(step: RequestState.loading));
    try {
      final data = await getCheckTransaction.execute(state.transactionid!, state.transactionEntityDetail!.paymentQrUrl!);
      emit(state.copyWith(checkQris: data,step: RequestState.loaded));
    } catch (e) {
      emit(state.copyWith(errormessage: "terjadi kesalahan"));
    }
  }
}
