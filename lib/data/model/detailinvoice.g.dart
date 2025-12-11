// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detailinvoice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetailInvoiceModel _$DetailInvoiceModelFromJson(Map<String, dynamic> json) =>
    DetailInvoiceModel(
      message: json['message'] as String,
      data: DetailInvoiceData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DetailInvoiceModelToJson(DetailInvoiceModel instance) =>
    <String, dynamic>{'message': instance.message, 'data': instance.data};

DetailInvoiceData _$DetailInvoiceDataFromJson(Map<String, dynamic> json) =>
    DetailInvoiceData(
      id: json['id'] as String,
      clientName: json['client_name'] as String,
      university: json['university'] as String,
      packageName: json['package_name'] as String,
      status: json['status'] as String,
      extra: json['extra'] == null?[]:(json['extra'] as List<dynamic>)
          .map((e) => ExtraItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalAmount: (json['total_amount'] as num).toInt(),
      paidAmount: (json['paid_amount'] as num).toInt(),
      unpaidAmount: (json['unpaid_amount'] as num).toInt(),
      transactions: (json['transactions'] as List<dynamic>)
          .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DetailInvoiceDataToJson(DetailInvoiceData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'client_name': instance.clientName,
      'university': instance.university,
      'package_name': instance.packageName,
      'status': instance.status,
      'extra': instance.extra,
      'total_amount': instance.totalAmount,
      'paid_amount': instance.paidAmount,
      'unpaid_amount': instance.unpaidAmount,
      'transactions': instance.transactions,
    };

ExtraItem _$ExtraItemFromJson(Map<String, dynamic> json) =>
    ExtraItem(id: json['id'] as String, name: json['name'] as String);

Map<String, dynamic> _$ExtraItemToJson(ExtraItem instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
};

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
  id: json['id'] as String,
  amount: (json['amount'] as num).toInt(),
  status: json['status'] as String,
  type: json['type'] as String,
  method: json['method'] as String,
  qrisImageUrl: json['qris_image_url'] as String?,
  transactionTime: json['transaction_time'] as String,
);

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'status': instance.status,
      'type': instance.type,
      'method': instance.method,
      'qris_image_url': instance.qrisImageUrl,
      'transaction_time': instance.transactionTime,
    };
