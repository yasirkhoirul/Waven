// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addonsmodel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Addonsmodel _$AddonsmodelFromJson(Map<String, dynamic> json) => Addonsmodel(
  json['message'] as String,
  (json['data'] as List<dynamic>)
      .map((e) => DataAddons.fromJson(e as Map<String, dynamic>))
      .toList(),
);


DataAddons _$DataAddonsFromJson(Map<String, dynamic> json) => DataAddons(
  json['id'] as String,
  json['title'] as String,
  (json['price'] as num).toDouble(),
);
