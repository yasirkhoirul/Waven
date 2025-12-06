import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:waven/domain/entity/porto.dart';
import 'package:waven/domain/usecase/get_porto_all.dart';

part 'porto_all_state.dart';

class PortoAllCubit extends Cubit<PortoAllState> {
  final GetPortoAll getPorto;
  PortoAllCubit(this.getPorto) : super(PortoAllInitial());

  void getAllporto({String? idpackage})async{
    emit( PortoAllLoading());
    try {
      final response  = await getPorto.execute();
      emit(PortoAllLoaded(response));
    } catch (e) {
      emit(PortoAllError(e.toString()));
    }
  }

}
