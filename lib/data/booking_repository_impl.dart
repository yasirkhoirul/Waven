import 'package:logger/logger.dart';
import 'package:waven/data/model/booking_request_model.dart';
import 'package:waven/data/remote/data_local_impl.dart';
import 'package:waven/data/remote/data_remote_impl.dart';
import 'package:waven/domain/entity/additional_info.dart';
import 'package:waven/domain/entity/addons.dart';
import 'package:waven/domain/entity/booking.dart';
import 'package:waven/domain/entity/customer.dart';
import 'package:waven/domain/entity/invoice.dart';
import 'package:waven/domain/entity/univ_dropdown.dart';
import 'package:waven/domain/repository/booking_repository.dart';

class BookingRepositoryImpl implements BookingRepository {
  final DataRemote dataRemote;
  final DataLocal dataLocal;
  const BookingRepositoryImpl(this.dataRemote, {required this.dataLocal});

  @override
  Future<List<UnivDropdown>> getUnivDropDown() async {
    final data = await dataRemote.getUnivDropDown();
    try {
      final dataready = data.data.map((e) => e.toEntity()).toList();
      return dataready;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<Addons>> getAllAddons() async {
    final data = await dataRemote.getAddons();
    try {
      final dataready = data.data.map((e) => e.toEntity()).toList();
      return dataready;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<Invoice> submitBooking({
    required Customer customer,
    required Booking bookingdata,
    required AdditionalInfo additionalData,
  }) async {
    try {
      final payload = BookingRequestModel(
        CustomerData(
          customer.fullName,
          customer.whatsappNumber,
          customer.instagram,
        ),
        BookingData(
          bookingdata.packageId,
          bookingdata.date,
          bookingdata.startTime,
          bookingdata.endTime,
          bookingdata.paymentMethod,
          bookingdata.paymentType,
          bookingdata.amount,
          bookingdata.addonIds,
        ),
        AdditionalData(
          additionalData.universityId,
          additionalData.location,
          additionalData.note,
        ),
      );
      final response = await dataRemote.postBooking(payload);
      Logger().d(response.data.actions!.first.url);
      return response.toEntity();
    } catch (e) {
      rethrow;
    }
  }
}
