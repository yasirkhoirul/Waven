
import 'dart:typed_data';

class TransactionEntity {
  final String id;
  final int amount;
  final String status;
  final String type;
  final String method;
  final String? qrisImageUrl;
  final String transactionTime;

  TransactionEntity({
    required this.id,
    required this.amount,
    required this.status,
    required this.type,
    required this.method,
    this.qrisImageUrl,
    required this.transactionTime,
  });
}

class TransactionEntityDetail {
  final String message;
  final String? paymentQrUrl;
  final Uint8List? gambarqr;

  TransactionEntityDetail({
    required this.message,
    this.paymentQrUrl,
    this.gambarqr,
  });
}
