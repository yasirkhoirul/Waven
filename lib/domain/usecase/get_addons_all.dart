import 'package:waven/domain/entity/addons.dart';
import 'package:waven/domain/repository/booking_repository.dart';

class GetAddonsAll {
  final BookingRepository bookingRepository;
  const GetAddonsAll(this.bookingRepository);

  Future<List<Addons>> execute(){
    return bookingRepository.getAllAddons();
  }
}