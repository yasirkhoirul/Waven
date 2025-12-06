import 'package:waven/domain/entity/package.dart';
import 'package:waven/domain/repository/package_repository.dart';

class GetPackageAll {
  final PackageRepository packageRepository;
  const GetPackageAll(this.packageRepository);

  Future<List<PackageEntity>> execute()async{
    return packageRepository.getAllPackage();
  }
}