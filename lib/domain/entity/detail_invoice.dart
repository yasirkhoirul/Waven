import 'package:waven/domain/entity/transaction.dart';

class DetailInvoiceEntity {
  final String message;
  final DetailInvoiceDataEntity data;

  DetailInvoiceEntity({
    required this.message,
    required this.data,
  });
}

class DetailInvoiceDataEntity {
  final String id;
  final String clientName;
  final String university;
  final String packageName;
  final String status;
  final List<ExtraItemEntity> extra;
  final int totalAmount;
  final int paidAmount;
  final int unpaidAmount;
  final List<TransactionEntity> transactions;

  DetailInvoiceDataEntity({
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
}

class ExtraItemEntity {
  final String id;
  final String name;

  ExtraItemEntity({
    required this.id,
    required this.name,
  });
}


