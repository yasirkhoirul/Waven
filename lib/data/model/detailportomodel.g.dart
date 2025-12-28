// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detailportomodel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetailPortoModel _$DetailPortoModelFromJson(Map<String, dynamic> json) =>
    DetailPortoModel(
      json['message'] as String,
      DataDetailPortoModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DetailPortoModelToJson(DetailPortoModel instance) =>
    <String, dynamic>{'message': instance.message, 'data': instance.data};

DataDetailPortoModel _$DataDetailPortoModelFromJson(
  Map<String, dynamic> json,
) => DataDetailPortoModel(
  id: json['id'] as String,
  title: json['title'] as String,
  price: (json['price'] as num).toDouble(),
  banner_url: json['banner_url'] as String,
  description: json['description'] as String,
  benefits: (json['benefits'] as List<dynamic>)
      .map((e) => Benefits.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DataDetailPortoModelToJson(
  DataDetailPortoModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'price': instance.price,
  'banner_url': instance.banner_url,
  'description': instance.description,
  'benefits': instance.benefits,
};

Benefits _$BenefitsFromJson(Map<String, dynamic> json) => Benefits(
  id: json['id'] as String,
  description: json['description'] as String,
  type: json['type'] as String,
);

Map<String, dynamic> _$BenefitsToJson(Benefits instance) => <String, dynamic>{
  'id': instance.id,
  'description': instance.description,
  'type': instance.type,
};
