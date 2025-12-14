

import 'package:json_annotation/json_annotation.dart';
import 'package:waven/data/model/invoicemodel.dart';

part 'transactionmodel.g.dart';

@JsonSerializable()
class Transactionmodel {
  final String message;
  final DataTransactionModel data;
  const Transactionmodel(this.message, this.data);

  factory Transactionmodel.fromJson(Map<String, dynamic> json) =>
      _$TransactionmodelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionmodelToJson(this);
}

@JsonSerializable()
class DataTransactionModel {
  @JsonKey(name: 'transaction_detail')
  final BookingDetail transactiondetail;
  final List<Action>? actions;

  const DataTransactionModel(this.transactiondetail, this.actions);

  factory DataTransactionModel.fromJson(Map<String, dynamic> json) =>
      _$DataTransactionModelFromJson(json);

  Map<String, dynamic> toJson() => _$DataTransactionModelToJson(this);
}

@JsonSerializable()
class TransactionRequest {
  @JsonKey(name: 'payment_type')
  final String paymentType;

  @JsonKey(name: 'payment_method')
  final String paymentMethod;

  final int amount;

  TransactionRequest({
    required this.paymentType,
    required this.paymentMethod,
    required this.amount,
  });

  factory TransactionRequest.fromJson(Map<String, dynamic> json) =>
      _$TransactionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionRequestToJson(this);
}
