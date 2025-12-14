import 'dart:typed_data';

import 'package:waven/data/model/transactionmodel.dart';
import 'package:waven/domain/entity/transaction.dart';
import 'package:waven/domain/repository/booking_repository.dart';

class PostTransaction {
  final BookingRepository bookingRepository;
  const PostTransaction(this.bookingRepository);

  Future<TransactionEntityDetail> execute(TransactionRequest data,String invoiceid ,{Uint8List? image}){
    return bookingRepository.postTransaction(data, invoiceid, images: image);
  }
}