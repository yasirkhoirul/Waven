import 'package:json_annotation/json_annotation.dart';
import 'package:waven/domain/entity/detail_invoice.dart';
import 'package:waven/domain/entity/transaction.dart';

part 'detailinvoice.g.dart';

@JsonSerializable()
class DetailInvoiceModel {
  final String message;
  final DetailInvoiceData data;

  DetailInvoiceModel({
    required this.message,
    required this.data,
  });

  factory DetailInvoiceModel.fromJson(Map<String, dynamic> json) =>
      _$DetailInvoiceModelFromJson(json);

  Map<String, dynamic> toJson() => _$DetailInvoiceModelToJson(this);

  DetailInvoiceEntity toEntity() {
    return DetailInvoiceEntity(
      message: message,
      data: data.toEntity(),
    );
  }
}

@JsonSerializable()
class DetailInvoiceData {
  final String id;
  @JsonKey(name: 'client_name')
  final String clientName;
  final String university;
  @JsonKey(name: 'package_name')
  final String packageName;
  final String status;
  final List<ExtraItem>? extra;
  @JsonKey(name: 'total_amount')
  final int totalAmount;
  @JsonKey(name: 'paid_amount')
  final int paidAmount;
  @JsonKey(name: 'unpaid_amount')
  final int unpaidAmount;
  final List<Transaction> transactions;

  DetailInvoiceData({
    required this.id,
    required this.clientName,
    required this.university,
    required this.packageName,
    required this.status,
    required this.extra,
    required this.totalAmount,
    required this.paidAmount,
    required this.unpaidAmount,
    required this.transactions,
  });

  factory DetailInvoiceData.fromJson(Map<String, dynamic> json) =>
      _$DetailInvoiceDataFromJson(json);

  Map<String, dynamic> toJson() => _$DetailInvoiceDataToJson(this);

  DetailInvoiceDataEntity toEntity() {
    return DetailInvoiceDataEntity(
      id: id,
      clientName: clientName,
      university: university,
      packageName: packageName,
      status: status,
      extra: extra?.map((e) => e.toEntity()).toList()??[],
      totalAmount: totalAmount,
      paidAmount: paidAmount,
      unpaidAmount: unpaidAmount,
      transactions: transactions.map((e) => e.toEntity()).toList(),
    );
  }
}

@JsonSerializable()
class ExtraItem {
  final String id;
  final String name;

  ExtraItem({
    required this.id,
    required this.name,
  });

  factory ExtraItem.fromJson(Map<String, dynamic> json) =>
      _$ExtraItemFromJson(json);

  Map<String, dynamic> toJson() => _$ExtraItemToJson(this);

  ExtraItemEntity toEntity() {
    return ExtraItemEntity(
      id: id,
      name: name,
    );
  }
}

@JsonSerializable()
class Transaction {
  final String id;
  final int amount;
  final String status;
  final String type;
  final String method;
  @JsonKey(name: 'qris_image_url')
  final String? qrisImageUrl;
  @JsonKey(name: 'transaction_time')
  final String transactionTime;

  Transaction({
    required this.id,
    required this.amount,
    required this.status,
    required this.type,
    required this.method,
    this.qrisImageUrl,
    required this.transactionTime,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);

  TransactionEntity toEntity() {
    return TransactionEntity(
      id: id,
      amount: amount,
      status: status,
      type: type,
      method: method,
      qrisImageUrl: qrisImageUrl,
      transactionTime: transactionTime,
    );
  }
}
