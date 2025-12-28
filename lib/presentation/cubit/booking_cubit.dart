import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/web.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:waven/common/constant.dart';
import 'package:waven/domain/entity/additional_info.dart';
import 'package:waven/domain/entity/addons.dart';
import 'package:waven/domain/entity/booking.dart';
import 'package:waven/domain/entity/customer.dart';
import 'package:waven/domain/entity/invoice.dart';
import 'package:waven/domain/entity/package.dart';
import 'package:waven/domain/entity/univ_dropdown.dart';
import 'package:waven/domain/usecase/get_addons_all.dart';
import 'package:waven/domain/usecase/get_check_tanggal.dart';
import 'package:waven/domain/usecase/get_check_transaction.dart';
import 'package:waven/domain/usecase/get_univdropdown.dart';
import 'package:waven/domain/usecase/post_booking.dart';

part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final GetUnivdropdown getUnivdropdown;
  final GetAddonsAll getAddonsAll;
  final ImagePicker imagePickers;
  final GetCheckTanggal getCheckTanggal;
  final PostBooking postBooking;
  final GetCheckTransaction getCheckTransaction;
  BookingCubit(
    this.getUnivdropdown, {
    required this.getAddonsAll,
    required this.postBooking,
    required this.getCheckTanggal, required this.imagePickers, required this.getCheckTransaction,
  }) : super(BookingState());

  Future getAllDropDown() async {
    emit(state.copyWith(step: BookingStep.loading));
    try {
      final renpse = await getUnivdropdown.execute(0,10);
      Logger().d("hasil ${renpse.first.name} ${renpse.last.name}");
      final addons = await getAddonsAll.execute();
      emit(
        state.copyWith(
          step: BookingStep.loaded,
          data: renpse,
          dataaddons: addons,
        ),
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  void goloaded() {
    emit(state.copyWith(step: BookingStep.loaded,amount: 0,datadiplih: [],));
  }

  void onTahapOne(
    String univ,
    String starttime,
    String endtime,
    String tanggal,
  ) async {
    emit(state.copyWith(step: BookingStep.loading));
    if (univ.isNotEmpty &&
        starttime.isNotEmpty &&
        endtime.isNotEmpty &&
        tanggal.isNotEmpty) {
      try {
        final response = await getCheckTanggal.execute(
          tanggal,
          starttime,
          endtime,
        );
        if (response) {
          emit(
            state.copyWith(
              step: BookingStep.tahap1,
              univ: univ,
              starttime: starttime,
              endtime: endtime,
              tanggal: tanggal,
            ),
          );
        } else {
          emit(
            state.copyWith(
              step: BookingStep.error,
              errorMessage: "Tanggal Penuh / jam sudah terlewat",
            ),
          );
        }
      }on DioException catch(e){
        Logger().d(e.response!.statusCode.toString());
      }  
      
      catch (e) {
        if (e.toString().contains("401")
          ||
            e.toString().contains("missing authorization header")) {

          Logger().d("session abis $e");
          emit(BookingSessionExpired());
        }
        emit(
          state.copyWith(step: BookingStep.error, errorMessage: e.toString()),
        );
      }
    }
  }

  void onTahapTwo(
    PackageEntity packageEntity,
    String nama,
    String nowa,
    String lokasi,
    String ig,
    String catatan,
    List<Addons> datadiplih,
  ) {
    final addonTotal = datadiplih.fold<double>(
      0,
      (sum, item) => sum + item.price,
    );
    final amount = addonTotal + packageEntity.price;
    
    
    Logger().d("jumlah $amount");
    emit(
      state.copyWith(
        step: BookingStep.tahap2,
        amount: amount,
        packageEntity: packageEntity,
        datadiplih: datadiplih,
        nama: nama,
        nowa: nowa,
        lokasi: lokasi,
        ig: ig,
        catatan: catatan,
      ),
    );
  }

  void onTahapThree(String paytype, String paymethod) {
    double totalamount;
    if (paytype == Constantclass.paymentType[1]) {
      totalamount = state.amount/2;
    }else{
      totalamount = state.amount;
    }
    Logger().d(totalamount);
    emit(
      state.copyWith(
        amount: totalamount,
        step: BookingStep.tahap3,
        paymentMethod: paymethod,
        paymentType: paytype,
      ),
    );
  }

  void onsubmit() async {
    emit(state.copyWith(step: BookingStep.loading));
    if (state.packageEntity == null ||
        state.nama == null ||
        state.nama!.isEmpty ||
        state.nowa == null ||
        state.nowa!.isEmpty ||
        state.tanggal == null ||
        state.starttime == null ||
        state.endtime == null ||
        state.paymentMethod == null ||
        state.paymentType == null ||
        state.univ == null ||
        state.lokasi == null ||
        state.lokasi!.isEmpty) {
      emit(
        state.copyWith(
          step: BookingStep.error,
          errorMessage: "Data belum lengkap! Silahkan isi semua field wajib.",
        ),
      );
      return;
    }

    
    List<String> dataaddons = [];
    if (state.datadiplih != null && state.datadiplih!.isNotEmpty) {
      dataaddons = state.datadiplih!.map((e) => e.id).toList();
    }

    final customerdata = Customer(state.nama!, state.nowa!, state.ig!);
    final bookingdata = Booking(
      state.packageEntity!.id,
      state.tanggal!,
      state.starttime!,
      state.endtime!,
      state.paymentMethod!,
      state.paymentType!,
      state.amount.toInt(),
      dataaddons,
    );
    final additonaldata = AdditionalInfo(
      state.univ!,
      state.lokasi!,
      state.catatan ?? "",
    );

    try {
      // Compress image before upload to avoid 413 error
      List<int>? compressedImage;
      if (state.dataimage != null) {
        final bytes = await state.dataimage!.readAsBytes();
        Logger().d("Original image size: ${bytes.length} bytes");
        
        // Compress to max 500KB with quality 70
        compressedImage = await FlutterImageCompress.compressWithList(
          bytes,
          minWidth: 1024,
          minHeight: 1024,
          quality: 70,
        );
        Logger().d("Compressed image size: ${compressedImage.length} bytes");
      }
      
      final invoice = await postBooking.execute(
        image: compressedImage,
        customer: customerdata,
        booking: bookingdata,
        additionalData: additonaldata,
      );
      emit(state.copyWith(step: BookingStep.submitted, invoice: invoice));
    } catch (e) {
      if (e.toString().contains("401") ||
          e.toString().contains("Session Expired")) {
        emit(BookingSessionExpired());
      } else {
        emit(
          state.copyWith(step: BookingStep.error, errorMessage: e.toString()),
        );
      }
    }
  }
  void onTapImage()async{
   try {
    final XFile? dataimage = await imagePickers.pickImage(source: ImageSource.gallery);
     Logger().d(dataimage);
     emit(state.copyWith(dataimage: dataimage));

   } catch (e) {
     emit(state.copyWith(step: BookingStep.error,errorMessage: "gagal mendapatkan foto"));
   }
  }

  Future<void> checkTransaction(String bookingid,String transactionid)async{
    emit(state.copyWith(step: BookingStep.loading));
    try {
      final data = await getCheckTransaction.execute(bookingid, transactionid);
      emit(state.copyWith(checkQris: data,step: BookingStep.submitted));
    } catch (e) {
      emit(state.copyWith(errorMessage: "terjadi kesalahan"));
    }
  }
}
