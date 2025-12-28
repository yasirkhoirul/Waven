// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checktransactionmodel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Checktransactionmodel _$ChecktransactionmodelFromJson(
  Map<String, dynamic> json,
) => Checktransactionmodel(
  json['message'] as String,
  DataCheckTransaction.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ChecktransactionmodelToJson(
  Checktransactionmodel instance,
) => <String, dynamic>{'message': instance.message, 'data': instance.data};

DataCheckTransaction _$DataCheckTransactionFromJson(
  Map<String, dynamic> json,
) => DataCheckTransaction(
  json['is_paid'] as bool,
  json['description'] as String,
);

Map<String, dynamic> _$DataCheckTransactionToJson(
  DataCheckTransaction instance,
) => <String, dynamic>{
  'is_paid': instance.ispaid,
  'description': instance.description,
};
