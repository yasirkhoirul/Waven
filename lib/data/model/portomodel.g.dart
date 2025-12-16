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

DataPortoModel _$DataPortoModelFromJson(Map<String, dynamic> json) =>
    DataPortoModel(json['id'] as String, json['url'] as String);
