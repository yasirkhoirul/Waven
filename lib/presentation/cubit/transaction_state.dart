part of 'transaction_cubit.dart';

class TransactionState extends Equatable {
  const TransactionState( {this.transactionid, this.image, this.step = RequestState.init,this.errormessage = '',this.unpaidAmount = 0,this.transactionEntityDetail, this.checkQris = false});
  final String? transactionid;
  final TransactionEntityDetail? transactionEntityDetail;
  final RequestState step;
  final Uint8List? image;
  final String errormessage;
  final int unpaidAmount;
  final bool checkQris;
  @override
  List<Object?> get props => [
    image,transactionid,step,image,errormessage,unpaidAmount,transactionEntityDetail,checkQris
  ];

  TransactionState copyWith(
   { 

    int? unpaidAmount,
    Uint8List? images,
    String? transactionid,
    String? errormessage,
    RequestState? step,
    TransactionEntityDetail? transactionEntityDetail,
    bool? checkQris
    }
  ){
    return TransactionState(
      transactionid: transactionid??this.transactionid,
      image: images??image,
      step: step??this.step,
      errormessage: errormessage??this.errormessage,
      unpaidAmount: unpaidAmount??this.unpaidAmount,
      transactionEntityDetail:  transactionEntityDetail?? this.transactionEntityDetail,
      checkQris:checkQris??this.checkQris
    );
  }
}

final class TransactionInitial extends TransactionState {}
