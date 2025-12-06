import 'package:waven/domain/entity/porto.dart';
import 'package:waven/domain/repository/package_repository.dart';

class GetPortoAll {
  final PackageRepository packageRepository;
  const GetPortoAll(this.packageRepository);

  Future<List<PortoEntity>> execute({String? idporto})async{
    return packageRepository.getPorto(idpackage: idporto);
  }
}