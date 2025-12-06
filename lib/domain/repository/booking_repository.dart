import 'package:waven/domain/entity/addons.dart';
import 'package:waven/domain/entity/univ_dropdown.dart';

abstract class BookingRepository {
  Future<List<UnivDropdown>> getUnivDropDown();
  Future<List<Addons>> getAllAddons();
}