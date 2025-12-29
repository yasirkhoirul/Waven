import 'package:waven/domain/entity/list_gdrive.dart';
import 'package:waven/domain/repository/booking_repository.dart';

class GetListGdrive {
  final BookingRepository bookingRepository;
  const GetListGdrive(this.bookingRepository);

  Future<ListGdriveEntity> execute(
    String bookingId,
    int page,
    int limit, {

    String? search,
  }) async {
    return bookingRepository.getGoogleDriveFiles(
      bookingId,
      page,
      limit,
      search: search
    );
  }
}
