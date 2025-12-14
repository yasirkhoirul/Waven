import 'package:waven/domain/repository/booking_repository.dart';

class PostEditedPhoto {
  final BookingRepository bookingRepository;
  const PostEditedPhoto(this.bookingRepository);

  Future<String> execute(String listEditedPhoto,String idInvoice){
    return bookingRepository.postEditedPhoto(listEditedPhoto, idInvoice);
  }
}