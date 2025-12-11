import 'package:waven/domain/entity/detail_invoice.dart';
import 'package:waven/domain/repository/booking_repository.dart';

class GetDetailInvoice {
  final BookingRepository bookingRepository;
  const GetDetailInvoice(this.bookingRepository);

  Future<DetailInvoiceDataEntity> execute(String idInvoice) async{
    return bookingRepository.getInvoice(idInvoice);
  }
}