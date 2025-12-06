
import 'package:json_annotation/json_annotation.dart';
import 'package:waven/domain/entity/addons.dart';

part 'addonsmodel.g.dart';

@JsonSerializable()
class Addonsmodel {
  final String message;
  final List<DataAddons> data;
  Addonsmodel(this.message, this.data);
  factory Addonsmodel.fromJson(Map<String,dynamic> json)=> _$AddonsmodelFromJson(json);
}

@JsonSerializable()
class DataAddons{
  final String id;
  final String title;
  final double price;
  const DataAddons(this.id, this.title, this.price);
  factory DataAddons.fromJson(Map<String,dynamic> json){
    return _$DataAddonsFromJson(json);
  }
  Addons toEntity(){
    return Addons(id, title, price);
  }
}