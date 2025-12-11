// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profilemodel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profilemodel _$ProfilemodelFromJson(Map<String, dynamic> json) => Profilemodel(
  json['message'] as String,
  DataProfile.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ProfilemodelToJson(Profilemodel instance) =>
    <String, dynamic>{'message': instance.message, 'data': instance.data};

DataProfile _$DataProfileFromJson(Map<String, dynamic> json) => DataProfile(
  json['id'] as String,
  json['username'] as String,
  json['email'] as String,
  json['name'] as String,
  json['phone_number'] as String,
  json['created_at'] as String,
);

Map<String, dynamic> _$DataProfileToJson(DataProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'name': instance.name,
      'phone_number': instance.phonenumber,
      'created_at': instance.createdat,
    };
