import 'package:json_annotation/json_annotation.dart';
import 'package:waven/domain/entity/univ_dropdown.dart';

part 'univ_drop_model.g.dart';

@JsonSerializable()
class UnivDropModel {
  final String message;
  final List<DataUnivDropModel> data;

  const UnivDropModel(this.message, this.data);

  factory UnivDropModel.fromJson(Map<String, dynamic> json) =>
      _$UnivDropModelFromJson(json);

  
}

@JsonSerializable()
class DataUnivDropModel {
  final String id;
  final String name;
  const DataUnivDropModel(this.id, this.name);

  factory DataUnivDropModel.fromJson(Map<String, dynamic> json) =>
      _$DataUnivDropModelFromJson(json);

  UnivDropdown toEntity(){
    return UnivDropdown(id, name);
  }
}
