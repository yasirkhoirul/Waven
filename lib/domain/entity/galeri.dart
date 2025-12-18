import 'package:waven/domain/entity/package.dart';
import 'package:waven/domain/entity/porto.dart';

class Galeri {
  final PackageEntity data;
  final List<PortoEntity> datapack;
  const Galeri(this.data, this.datapack);
}
