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
  json['phonenumber'] as String,
  json['university'] as String,
);

Map<String, dynamic> _$SignUpToJson(SignUp instance) => <String, dynamic>{
  'username': instance.username,
  'email': instance.email,
  'password': instance.password,
  'name': instance.name,
  'university': instance.university,
  'phonenumber': instance.phonenumber,
};
