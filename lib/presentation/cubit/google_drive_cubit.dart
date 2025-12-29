import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:waven/domain/entity/list_gdrive.dart';
import 'package:waven/domain/usecase/get_list_gdrive.dart';

part 'google_drive_state.dart';

class GoogleDriveCubit extends Cubit<GoogleDriveState> {
  GoogleDriveCubit(this.getListGdrive) : super(GoogleDriveInitial());
  final GetListGdrive getListGdrive;
  void getData(String bookingId,int page,int limit,{String? search})async{
    emit(GoogleDriveLoading());
    try {
      final response = await getListGdrive.execute(bookingId, page, limit,search: search);
      emit(GoogleDriveLoaded(response));
    } catch (e) {
      emit(GoogleDriveError(e.toString()));
    }
  }

  Future<List<GoogleDriveFileEntity>> getDataReturn(String bookingId,int page,int limit,{String?  search})async{
    try {
      final response = await getListGdrive.execute(bookingId, page, limit,search: search);
      return response.data;
    } catch (e) {
      return [];
    }
  }
}
