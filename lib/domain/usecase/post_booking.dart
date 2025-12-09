import 'package:waven/domain/entity/additional_info.dart';
import 'package:waven/domain/entity/booking.dart';
import 'package:waven/domain/entity/customer.dart';
import 'package:waven/domain/entity/invoice.dart';
import 'package:waven/domain/repository/booking_repository.dart';

class PostBooking {
  final BookingRepository bookingRepository;
  const PostBooking(this.bookingRepository);

  Future<Invoice> execute({
    List<int>? image,
    required Customer customer,
    required Booking booking,
    required AdditionalInfo additionalData,
  }) async {
    return await bookingRepository.submitBooking(
      customer: customer,
      bookingdata: booking,
      additionalData: additionalData,
      image: image
    );
  }
}
