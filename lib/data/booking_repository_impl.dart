import 'package:waven/data/remote/data_remote_impl.dart';
import 'package:waven/domain/entity/addons.dart';
import 'package:waven/domain/entity/univ_dropdown.dart';
import 'package:waven/domain/repository/booking_repository.dart';

class BookingRepositoryImpl implements BookingRepository{
  final DataRemote dataRemote;
  const BookingRepositoryImpl(this.dataRemote);

  @override
  Future<List<UnivDropdown>> getUnivDropDown() async{
    final data = await dataRemote.getUnivDropDown();
    try {
      final dataready = data.data.map((e) => e.toEntity(),).toList();
      return dataready;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<Addons>> getAllAddons() async{
    final data = await dataRemote.getAddons();
    try {
      final dataready = data.data.map((e) => e.toEntity(),).toList();
      return dataready;
    } catch (e) {
      throw Exception(e);
    }
  }
  
}