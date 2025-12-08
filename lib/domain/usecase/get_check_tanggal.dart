import 'package:waven/domain/repository/booking_repository.dart';

class GetCheckTanggal {
  final BookingRepository bookingRepository;
  const GetCheckTanggal(this.bookingRepository);

  Future<bool> execute(String tanggal,String start,String end){
    return bookingRepository.checkTanggal(tanggal, start, end);
  }
}