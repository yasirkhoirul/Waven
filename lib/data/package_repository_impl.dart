import 'package:waven/data/remote/data_remote_impl.dart';
import 'package:waven/data/model/packagemodel.dart';
import 'package:waven/domain/entity/detail_package.dart';
import 'package:waven/domain/entity/package.dart';
import 'package:waven/domain/entity/porto.dart';
import 'package:waven/domain/repository/package_repository.dart';

class PackageRepositoryImpl implements PackageRepository {
  DataRemote dataRemote;
  PackageRepositoryImpl(this.dataRemote);
  @override
  Future<List<PackageEntity>> getAllPackage() async {
    try {
      final Packagemodel response = await dataRemote.getPackage();
      return response.data.map((e) => e.toEntity(e)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<PortoEntity>> getPorto({String? idpackage}) async{
    final data = await dataRemote.getPorto(idpackage: idpackage);
    return data.data.map((e) => e.toEntity(e),).toList();
  }

  @override
  Future<DetailPackageEntity> getDetailPackage(String idpackage) async{
    final data = await dataRemote.getDetailPorto(idpackage);
    try {
      final dataready = data.toEntity(data.data);
      return dataready;
    } catch (e) {
      throw Exception(e);
    }
  }
}
