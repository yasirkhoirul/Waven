
import 'package:json_annotation/json_annotation.dart';
import 'package:waven/domain/entity/package.dart';

part 'packagemodel.g.dart';

@JsonSerializable()
class Packagemodel {
  final String message;
  final List<DataPackage> data;  
  Packagemodel(this.message, this.data);

  factory Packagemodel.fromJson(Map<String,dynamic> json)=> _$PackagemodelFromJson(json);
}

@JsonSerializable()
class DataPackage{
  final String id;
  final String title;
  final double price;
  final String banner_url;
  final String description;
  DataPackage({required this.id, required this.title, required this.price, required this.banner_url, required this.description});

  factory DataPackage.fromJson(Map<String,dynamic> json) => _$DataPackageFromJson(json);

  PackageEntity toEntity(DataPackage data){
    return PackageEntity(id: id, tittle: title, price: price, bannerUrl: banner_url, description: description);
  }
}