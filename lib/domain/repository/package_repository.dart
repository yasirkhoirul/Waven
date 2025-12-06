import 'package:waven/domain/entity/detail_package.dart';
import 'package:waven/domain/entity/package.dart';
import 'package:waven/domain/entity/porto.dart';

abstract class PackageRepository {
  Future<List<PackageEntity>> getAllPackage();
  Future<DetailPackageEntity> getDetailPackage(String idpackage);
  Future<List<PortoEntity>> getPorto({String? idpackage});
}