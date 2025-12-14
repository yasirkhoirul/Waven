import 'package:waven/domain/repository/booking_repository.dart';

class GetCheckTransaction {
  final BookingRepository bookingRepository;
  GetCheckTransaction(this.bookingRepository);

  Future<bool> execute(String bookingid, String transactionid){
    return bookingRepository.checkTransaction(bookingid, transactionid);
  }
}