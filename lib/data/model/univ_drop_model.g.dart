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


DataUnivDropModel _$DataUnivDropModelFromJson(Map<String, dynamic> json) =>
    DataUnivDropModel(json['id'] as String, json['name'] as String);

