// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactionmodel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transactionmodel _$TransactionmodelFromJson(Map<String, dynamic> json) =>
    Transactionmodel(
      json['message'] as String,
      DataTransactionModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TransactionmodelToJson(Transactionmodel instance) =>
    <String, dynamic>{'message': instance.message, 'data': instance.data};

DataTransactionModel _$DataTransactionModelFromJson(
  Map<String, dynamic> json,
) => DataTransactionModel(
  BookingDetail.fromJson(json['transaction_detail'] as Map<String, dynamic>),
  (json['actions'] as List<dynamic>?)
      ?.map((e) => Action.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DataTransactionModelToJson(
  DataTransactionModel instance,
) => <String, dynamic>{
  'transaction_detail': instance.transactiondetail,
  'actions': instance.actions,
};

TransactionRequest _$TransactionRequestFromJson(Map<String, dynamic> json) =>
    TransactionRequest(
      paymentType: json['payment_type'] as String,
      paymentMethod: json['payment_method'] as String,
      amount: (json['amount'] as num).toInt(),
    );

Map<String, dynamic> _$TransactionRequestToJson(TransactionRequest instance) =>
    <String, dynamic>{
      'payment_type': instance.paymentType,
      'payment_method': instance.paymentMethod,
      'amount': instance.amount,
    };
