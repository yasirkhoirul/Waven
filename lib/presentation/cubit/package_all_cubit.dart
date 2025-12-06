import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:waven/domain/entity/package.dart';
import 'package:waven/domain/usecase/get_package_all.dart';

part 'package_all_state.dart';

class PackageAllCubit extends Cubit<PackageAllState> {
  final GetPackageAll getPackageAll;
  PackageAllCubit(this.getPackageAll) : super(PackageAllInitial());

  Future<void> getAllpackage()async{
    emit(PackageAllLoading());
    try {
      final data = await getPackageAll.execute();
      Logger().d(data);
      emit(PackageAllLoaded(data));
    } catch (e) {
      emit(PackageAllError(e.toString()));
    }
  }
}
