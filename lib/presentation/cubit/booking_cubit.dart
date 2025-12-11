import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/web.dart';
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
import 'package:waven/domain/usecase/get_univdropdown.dart';
import 'package:waven/domain/usecase/post_booking.dart';

part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final GetUnivdropdown getUnivdropdown;
  final GetAddonsAll getAddonsAll;
  final ImagePicker imagePickers;
  final GetCheckTanggal getCheckTanggal;
  final PostBooking postBooking;
  BookingCubit(
    this.getUnivdropdown, {
    required this.getAddonsAll,
    required this.postBooking,
    required this.getCheckTanggal, required this.imagePickers,
  }) : super(BookingState());

  Future getAllDropDown() async {
    emit(state.copyWith(step: BookingStep.loading));
    try {
      final renpse = await getUnivdropdown.execute();
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
    final double totalamount;
    if (state.paymentType == Constantclass.paymentType[1]) {
      totalamount = amount/2;
    }else{
      totalamount = amount;
    }
    Logger().d("jumlah $amount");
    emit(
      state.copyWith(
        step: BookingStep.tahap2,
        amount: totalamount,
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
    emit(
      state.copyWith(
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
      final image = await state.dataimage?.readAsBytes();
      Logger().d("image dikirim dari cubic $image");
      final invoice = await postBooking.execute(
        image:  image,
        customer: customerdata,
        booking: bookingdata,
        additionalData: additonaldata,
      );
      Logger().d("invoice di cubic = ${invoice.paymentQrUrl}");
      emit(state.copyWith(step: BookingStep.submitted, invoice: invoice));
    } catch (e) {
      Logger().d("ini dari dio ${e}");
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
}
