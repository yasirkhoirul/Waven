// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignUp _$SignUpFromJson(Map<String, dynamic> json) => SignUp(
  json['username'] as String,
  json['email'] as String,
  json['password'] as String,
  json['name'] as String,
  json['phone_number'] as String,
  json['university_id'] as String,
);

Map<String, dynamic> _$SignUpToJson(SignUp instance) => <String, dynamic>{
  'username': instance.username,
  'email': instance.email,
  'password': instance.password,
  'name': instance.name,
  'university_id': instance.university_id,
  'phone_number': instance.phone_number,
};
