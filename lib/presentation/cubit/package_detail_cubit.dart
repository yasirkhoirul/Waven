import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:waven/domain/entity/detail_package.dart';
import 'package:waven/domain/usecase/get_detail_package.dart';

part 'package_detail_state.dart';

class PackageDetailCubit extends Cubit<PackageDetailState> {
  final GetDetailPackage getDetailPackage;
  PackageDetailCubit(this.getDetailPackage) : super(PackageDetailInitial());

  void getPackageDetail(String idpackgage) async {
    emit(PackageDetailLoading());
    try {
      final data = await getDetailPackage.execute(idpackgage);
      emit(PackageDetailLoaded(data));
    } catch (e) {
      emit(PackageDetailError(e.toString()));
    }
  }
}
