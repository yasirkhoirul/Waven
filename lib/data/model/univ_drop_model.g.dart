// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'univ_drop_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnivDropModel _$UnivDropModelFromJson(Map<String, dynamic> json) =>
    UnivDropModel(
      json['message'] as String,
      (json['data'] as List<dynamic>)
          .map((e) => DataUnivDropModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UnivDropModelToJson(UnivDropModel instance) =>
    <String, dynamic>{'message': instance.message, 'data': instance.data};

DataUnivDropModel _$DataUnivDropModelFromJson(Map<String, dynamic> json) =>
    DataUnivDropModel(json['id'] as String, json['name'] as String);

Map<String, dynamic> _$DataUnivDropModelToJson(DataUnivDropModel instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};
