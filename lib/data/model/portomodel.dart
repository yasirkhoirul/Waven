import 'package:json_annotation/json_annotation.dart';
import 'package:waven/domain/entity/porto.dart';

part 'portomodel.g.dart';



@JsonSerializable()
class Portomodel {
  final String message;
  final List<DataPortoModel> data;
  Portomodel(this.message, this.data);
  factory Portomodel.fromJson(Map<String,dynamic> json) => _$PortomodelFromJson(json);
}

@JsonSerializable()
class DataPortoModel {
  final String id;
  final String url;
  DataPortoModel(this.id, this.url);

  factory DataPortoModel.fromJson(Map<String,dynamic> json) => _$DataPortoModelFromJson(json);

  PortoEntity toEntity(DataPortoModel data){
    return PortoEntity(id, url);
  }
}

