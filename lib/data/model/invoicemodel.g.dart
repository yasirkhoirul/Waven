// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoicemodel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoiceModel _$InvoiceModelFromJson(Map<String, dynamic> json) => InvoiceModel(
  message: json['message'] as String,
  data: InvoiceData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$InvoiceModelToJson(InvoiceModel instance) =>
    <String, dynamic>{'message': instance.message, 'data': instance.data};

InvoiceData _$InvoiceDataFromJson(Map<String, dynamic> json) => InvoiceData(
  bookingDetail: BookingDetail.fromJson(
    json['booking_detail'] as Map<String, dynamic>,
  ),
  actions: (json['actions'] as List<dynamic>?)
      ?.map((e) => Action.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$InvoiceDataToJson(InvoiceData instance) =>
    <String, dynamic>{
      'booking_detail': instance.bookingDetail,
      'actions': instance.actions,
    };

BookingDetail _$BookingDetailFromJson(Map<String, dynamic> json) =>
    BookingDetail(
      bookingId: json['booking_id'] as String,
      midtransId: json['gateway_transaction_id'] as String?,
      totalAmount: (json['total_amount'] as num).toInt(),
      paidAmount: (json['paid_amount'] as num).toInt(),
      currency: json['currency'] as String?,
      paymentMethod: json['payment_method'] as String,
      transactionTime: json['transaction_time'] as String,
      paymentStatus: json['status'] as String,
      acquirer: json['acquirer'] as String?,
    );

Map<String, dynamic> _$BookingDetailToJson(BookingDetail instance) =>
    <String, dynamic>{
      'booking_id': instance.bookingId,
      'gateway_transaction_id': instance.midtransId,
      'total_amount': instance.totalAmount,
      'paid_amount': instance.paidAmount,
      'currency': instance.currency,
      'payment_method': instance.paymentMethod,
      'transaction_time': instance.transactionTime,
      'status': instance.paymentStatus,
      'acquirer': instance.acquirer,
    };

Action _$ActionFromJson(Map<String, dynamic> json) => Action(
  name: json['name'] as String,
  url: json['url'] as String,
  method: json['method'] as String,
);

Map<String, dynamic> _$ActionToJson(Action instance) => <String, dynamic>{
  'name': instance.name,
  'url': instance.url,
  'method': instance.method,
};
