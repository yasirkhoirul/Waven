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

Map<String, dynamic> _$AddonsmodelToJson(Addonsmodel instance) =>
    <String, dynamic>{'message': instance.message, 'data': instance.data};

DataAddons _$DataAddonsFromJson(Map<String, dynamic> json) => DataAddons(
  json['id'] as String,
  json['title'] as String,
  (json['price'] as num).toDouble(),
);

Map<String, dynamic> _$DataAddonsToJson(DataAddons instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'price': instance.price,
    };
