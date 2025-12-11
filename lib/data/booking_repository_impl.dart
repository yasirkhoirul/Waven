import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:waven/data/model/booking_request_model.dart';
import 'package:waven/data/remote/data_local_impl.dart';
import 'package:waven/data/remote/data_remote_impl.dart';
import 'package:waven/domain/entity/additional_info.dart';
import 'package:waven/domain/entity/addons.dart';
import 'package:waven/domain/entity/booking.dart';
import 'package:waven/domain/entity/customer.dart';
import 'package:waven/domain/entity/detail_invoice.dart';
import 'package:waven/domain/entity/invoice.dart';
import 'package:waven/domain/entity/list_invoice_user.dart';
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
    List<int>? image
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
      
      final response = await dataRemote.postBooking(payload,image: image);
      Logger().d("Booking response received with QR URL: ${response.data.actions?.first.url}");
      List<int>? qrImageBytes;
      // Fetch QR code image bytes if midtransId exists
      if (response.data.bookingDetail.midtransId != null) {
        try {
          qrImageBytes = await dataRemote.getQris(response.data.bookingDetail.midtransId!);
          Logger().d("QR code image fetched successfully: ${qrImageBytes.length} bytes");
        } catch (e) {
          Logger().w("Warning: Failed to fetch QR image - $e");
          // Don't throw, continue with invoice response
        }
      }
      
      return response.toEntity(Uint8List.fromList(qrImageBytes??[]));
    } catch (e) {
      rethrow;
    }
  }
  
  @override
  Future<bool> checkTanggal(String tanggal, String start, String end) async{
    try {
      final response = await dataRemote.checkBooking(tanggal, start, end);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ListInvoiceUserEntity> getlistinvoiceuser(int page, int limit) async{
    try {
      
      final data = await dataRemote.getlistinvoice(page, limit);
      Logger().d("iniadalah repo invoice ${data}");
      return data.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DetailInvoiceDataEntity> getInvoice(String idinvoice)async {
    try {
      final data = await dataRemote.getDetailInvoice(idinvoice);
      final dataready = data.data.toEntity();
      return dataready;
    } catch (e) {
      rethrow;
    }
  }
}
