import 'package:waven/domain/entity/detail_package.dart';
import 'package:waven/domain/repository/package_repository.dart';

class GetDetailPackage {
  final PackageRepository packageRepository;
  GetDetailPackage(this.packageRepository);

  Future<DetailPackageEntity> execute(String idpackage) async{
    return packageRepository.getDetailPackage(idpackage);
  }
}