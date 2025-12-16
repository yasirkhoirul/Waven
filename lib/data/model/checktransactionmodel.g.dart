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

DataCheckTransaction _$DataCheckTransactionFromJson(
  Map<String, dynamic> json,
) => DataCheckTransaction(
  json['is_paid'] as bool,
  json['description'] as String,
);
