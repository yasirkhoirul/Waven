import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';
import 'package:waven/domain/entity/invoice.dart';

part 'invoicemodel.g.dart';

@JsonSerializable()
class InvoiceModel {
  final String message;
  final InvoiceData data;

  InvoiceModel({
    required this.message,
    required this.data,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) =>
      _$InvoiceModelFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceModelToJson(this);

  
}

@JsonSerializable()
class InvoiceData {
  @JsonKey(name: 'booking_detail')
  final BookingDetail bookingDetail;

  final ActionData? actions;

  InvoiceData({
    required this.bookingDetail,
    this.actions,
  });

  factory InvoiceData.fromJson(Map<String, dynamic> json) =>
      _$InvoiceDataFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceDataToJson(this);
}

@JsonSerializable()
class BookingDetail {
  @JsonKey(name: 'booking_id')
  final String bookingId;

  @JsonKey(name: 'gateway_transaction_id')
  final String? midtransId;

  @JsonKey(name: 'total_amount')
  final int totalAmount;

  @JsonKey(name: 'paid_amount')
  final int paidAmount;

  final String? currency;

  

  @JsonKey(name: 'payment_method')
  final String paymentMethod;

  @JsonKey(name: 'transaction_time')
  final String transactionTime;

  @JsonKey(name: 'status')
  final String paymentStatus;

  final String? acquirer;

  BookingDetail({
    required this.bookingId,
    this.midtransId,
    required this.totalAmount,
    required this.paidAmount,
    this.currency,
    
    required this.paymentMethod,
    required this.transactionTime,
    required this.paymentStatus,
    this.acquirer,
  });

  factory BookingDetail.fromJson(Map<String, dynamic> json) =>
      _$BookingDetailFromJson(json);

  Map<String, dynamic> toJson() => _$BookingDetailToJson(this);

  BookingDetailEntity toEntity() {
    return BookingDetailEntity(
      bookingId: bookingId,
      midtransId: midtransId,
      totalAmount: totalAmount,
      paidAmount: paidAmount,
      currency: currency,
      paymentMethod: paymentMethod,
      transactionTime: transactionTime,
      paymentStatus: paymentStatus,
      acquirer: acquirer,
    );
  }
}

@JsonSerializable()
class Action {
  final String name;
  final String url;
  final String method;

  Action({
    required this.name,
    required this.url,
    required this.method,
  });

  factory Action.fromJson(Map<String, dynamic> json) =>
      _$ActionFromJson(json);

  Map<String, dynamic> toJson() => _$ActionToJson(this);
}

@JsonSerializable()
class ActionData{
  final String? token;
  @JsonKey(name: 'redirect_url')
  final String? redirectUrl;
  const ActionData(this.token,this.redirectUrl);

  factory ActionData.fromJson(Map<String,dynamic> json)=>_$ActionDataFromJson(json);
}
