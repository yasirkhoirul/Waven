import 'package:waven/domain/entity/list_invoice_user.dart';
import 'package:waven/domain/repository/booking_repository.dart';

class GetListInvoiceUser {
  final BookingRepository bookingRepository;
  const GetListInvoiceUser(this.bookingRepository);
  
  Future<ListInvoiceUserEntity> execute(int page,int limit) async{
    return bookingRepository.getlistinvoiceuser(page, limit);
  }
}