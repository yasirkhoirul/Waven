// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'packagemodel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Packagemodel _$PackagemodelFromJson(Map<String, dynamic> json) => Packagemodel(
  json['message'] as String,
  (json['data'] as List<dynamic>)
      .map((e) => DataPackage.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PackagemodelToJson(Packagemodel instance) =>
    <String, dynamic>{'message': instance.message, 'data': instance.data};

DataPackage _$DataPackageFromJson(Map<String, dynamic> json) => DataPackage(
  id: json['id'] as String,
  title: json['title'] as String,
  price: (json['price'] as num).toDouble(),
  banner_url: json['banner_url'] as String,
  description: json['description'] as String,
);

Map<String, dynamic> _$DataPackageToJson(DataPackage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'price': instance.price,
      'banner_url': instance.banner_url,
      'description': instance.description,
    };
