import 'package:waven/domain/entity/additional_info.dart';
import 'package:waven/domain/entity/addons.dart';
import 'package:waven/domain/entity/booking.dart';
import 'package:waven/domain/entity/customer.dart';
import 'package:waven/domain/entity/invoice.dart';
import 'package:waven/domain/entity/list_invoice_user.dart';
import 'package:waven/domain/entity/univ_dropdown.dart';

abstract class BookingRepository {
  Future<List<UnivDropdown>> getUnivDropDown();
  Future<List<Addons>> getAllAddons();
  Future<Invoice> submitBooking({
    required Customer customer,
    required Booking bookingdata,
    required AdditionalInfo additionalData,
    List<int>? image
  });
  Future<bool> checkTanggal(String tanggal,String start,String end);
  Future<ListInvoiceUserEntity> getlistinvoiceuser(int page,int limit);
}
