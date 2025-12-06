// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portomodel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Portomodel _$PortomodelFromJson(Map<String, dynamic> json) => Portomodel(
  json['message'] as String,
  (json['data'] as List<dynamic>)
      .map((e) => DataPortoModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PortomodelToJson(Portomodel instance) =>
    <String, dynamic>{'message': instance.message, 'data': instance.data};

DataPortoModel _$DataPortoModelFromJson(Map<String, dynamic> json) =>
    DataPortoModel(json['id'] as String, json['url'] as String);

Map<String, dynamic> _$DataPortoModelToJson(DataPortoModel instance) =>
    <String, dynamic>{'id': instance.id, 'url': instance.url};
