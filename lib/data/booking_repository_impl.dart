import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:logger/logger.dart';
import 'package:waven/common/constant.dart';
import 'dart:typed_data';
import 'package:waven/data/model/booking_request_model.dart';
import 'package:waven/data/model/transactionmodel.dart';
import 'package:waven/data/remote/data_local_impl.dart';
import 'package:waven/data/remote/data_remote_impl.dart';
import 'package:waven/domain/entity/additional_info.dart';
import 'package:waven/domain/entity/addons.dart';
import 'package:waven/domain/entity/booking.dart';
import 'package:waven/domain/entity/customer.dart';
import 'package:waven/domain/entity/detail_invoice.dart';
import 'package:waven/domain/entity/invoice.dart';
import 'package:waven/domain/entity/list_gdrive.dart';
import 'package:waven/domain/entity/list_invoice_user.dart';
import 'package:waven/domain/entity/transaction.dart';
import 'package:waven/domain/entity/univ_dropdown.dart';
import 'package:waven/domain/repository/booking_repository.dart';

class BookingRepositoryImpl implements BookingRepository {
  final DataRemote dataRemote;
  final DataLocal dataLocal;
  const BookingRepositoryImpl(this.dataRemote, {required this.dataLocal});

  @override
  Future<List<UnivDropdown>> getUnivDropDown(
    int page,
    int limit, {
    String? search,
  }) async {
    final data = await dataRemote.getUnivDropDown(page, limit, search: search);
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
    List<int>? image,
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
          kIsWeb ? Platformdata.web.name : Platformdata.android.name,
        ),
      );

      final response = await dataRemote.postBooking(payload, image: image);

      // Prepare QR bytes and redirect to snap (web) if provided
      Uint8List? qrImageBytes;
      final redirectUrl = response.data.actions?.redirectUrl;
      final midtransId = response.data.bookingDetail.midtransId;

      // If web and redirect URL is present, open snap url in same tab
      if (kIsWeb && redirectUrl != null && redirectUrl.isNotEmpty) {
        try {
          final uri = Uri.parse(redirectUrl);
          await launchUrl(
            uri,
            mode: LaunchMode.platformDefault,
            webOnlyWindowName: '_self',
          );
        } catch (e) {
          Logger().e('Failed to open redirect url: $e');
        }
      }

      // Try fetching QR image bytes when midtransId exists
      if (midtransId != null && midtransId.isNotEmpty) {
        try {
          final bytes = await dataRemote.getQris(midtransId);
          qrImageBytes = Uint8List.fromList(bytes);
        } catch (e) {
          Logger().e('Failed to fetch QR image: $e');
          qrImageBytes = null;
        }
      }

      // Build domain entity
      final booking = response.data.bookingDetail;
      final bookingEntity = BookingDetailEntity(
        bookingId: booking.bookingId,
        midtransId: booking.midtransId,
        totalAmount: booking.totalAmount,
        paidAmount: booking.paidAmount,
        currency: booking.currency,
        paymentMethod: booking.paymentMethod,
        transactionTime: booking.transactionTime,
        paymentStatus: booking.paymentStatus,
        acquirer: booking.acquirer,
        paymentQrUrl: midtransId,
        gambarqr: qrImageBytes,
      );

      return Invoice(message: response.message, bookingDetail: bookingEntity);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> checkTanggal(String tanggal, String start, String end) async {
    try {
      final response = await dataRemote.checkBooking(tanggal, start, end);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ListInvoiceUserEntity> getlistinvoiceuser(int page, int limit) async {
    try {
      final data = await dataRemote.getlistinvoice(page, limit);
      Logger().d("iniadalah repo invoice ${data.data.first.photoResultUrl}");
      Logger().d(
        "iniadalah repo entity invoice ${data.toEntity().data.first.photoReslutUrl}",
      );
      return data.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DetailInvoiceDataEntity> getInvoice(String idinvoice) async {
    try {
      final data = await dataRemote.getDetailInvoice(idinvoice);
      final dataready = data.data.toEntity();
      return dataready;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> checkTransaction(String bookingid, String gatewayid) async {
    try {
      final data = await dataRemote.getCheckTransaction(bookingid, gatewayid);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<TransactionEntityDetail> postTransaction(
    TransactionRequest payload,
    String idinvoice, {
    Uint8List? images,
  }) async {
    try {
      final data = await dataRemote.postTransaction(
        payload,
        idinvoice,
        image: images,
      );
      Logger().d("data already model transaction ${data.data.actions}");
      List<int> gambarqr = [];
      if (payload.paymentMethod == "qris") {
        Logger().d(
          "data qris yang diterima ${data.data.actions?.first.url ?? ''}",
        );
        gambarqr = await dataRemote.getQris(
          data.data.transactiondetail.midtransId ?? '',
        );
        Logger().d("data qris gambar yang didapat ${gambarqr}");
      }
      return TransactionEntityDetail(
        message: "Sukses",
        gambarqr: Uint8List.fromList(gambarqr),
        paymentQrUrl: data.data.transactiondetail.midtransId ?? '',
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> postEditedPhoto(
    String listEditedPhoto,
    String idinvoice,
  ) async {
    try {
      final response = await dataRemote.postEditedPhoto(
        listEditedPhoto,
        idinvoice,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ListGdriveEntity> getGoogleDriveFiles(
    String bookingId,
    int page,
    int limit,
     {
    String? search,
  }) async {
    try {
      final response = await dataRemote.getGoogleDriveFiles(
        bookingId,
        page: page,
        limit: limit,
        search: search,
      );
      Logger().d(
        "Google Drive files retrieved from remote: ${response.data.length} files",
      );
      return response.toEntity();
    } catch (e) {
      Logger().e("Error fetching Google Drive files in repository: $e");
      rethrow;
    }
  }
}
