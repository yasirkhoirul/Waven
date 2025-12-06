import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:logger/web.dart';
import 'package:meta/meta.dart';
import 'package:waven/domain/entity/addons.dart';
import 'package:waven/domain/entity/booking.dart';
import 'package:waven/domain/entity/package.dart';
import 'package:waven/domain/entity/univ_dropdown.dart';
import 'package:waven/domain/usecase/get_addons_all.dart';
import 'package:waven/domain/usecase/get_univdropdown.dart';

part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final GetUnivdropdown getUnivdropdown;
  final GetAddonsAll getAddonsAll;
  BookingCubit(this.getUnivdropdown, {required this.getAddonsAll})
    : super(BookingInitial());

  Future getAllDropDown() async {
    emit(BookingLoading());
    try {
      final renpse = await getUnivdropdown.execute();
      Logger().d("hasil ${renpse.first.name} ${renpse.last.name}");
      final addons = await getAddonsAll.execute();
      emit(BookingReady(data: renpse, dataaddons: addons));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  void onTahapOne(
    String univ,
    String starttime,
    String endtime,
    String tanggal,
  ) {
    if (univ.isNotEmpty &&
        starttime.isNotEmpty &&
        endtime.isNotEmpty &&
        tanggal.isNotEmpty) {
      emit(
        Bookingtahap1(
          univ: univ,
          starttime: starttime,
          endtime: endtime,
          tanggal: tanggal,
        ),
      );
    }
  }

  void onTahapTwo(
    String packageEntity,
    String nama,
    String nowa,
    String lokasi,
    String ig,
    String catatan,
    List<Addons> datadiplih,
  ) {
    emit(
      Bookingtahap2(
        catatan: catatan,
        packageEntity: packageEntity,
        nama: nama,
        nowa: nowa,
        lokasi: lokasi,
        ig: ig,
        datadiplih: datadiplih,
      ),
    );
    
  }

  void onTahapThree(
    String paytype,
    String paymethod
  ){
    emit(Bookingtahap3(
      paymentMethod: paymethod,
      paymentType: paytype
    ));
  }
}
