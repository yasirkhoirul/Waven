import 'package:waven/domain/entity/univ_dropdown.dart';
import 'package:waven/domain/repository/booking_repository.dart';

class GetUnivdropdown {
  final BookingRepository bookingRepository;
  const GetUnivdropdown(this.bookingRepository);

  Future<List<UnivDropdown>> execute(int page,int limit,{String? search}){
    return bookingRepository.getUnivDropDown(page,limit,search: search);
  }
}