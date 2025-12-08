import 'package:equatable/equatable.dart';

class Invoice extends Equatable {
  final String message;
  final BookingDetailEntity bookingDetail;
  final String? paymentQrUrl;

  const Invoice({
    required this.message,
    required this.bookingDetail,
    this.paymentQrUrl,
  });

  @override
  List<Object?> get props => [message, bookingDetail, paymentQrUrl];
}

class BookingDetailEntity extends Equatable {
  final String bookingId;
  final int totalAmount;
  final int paidAmount;
  final String? currency;
  final String paymentType;
  final String paymentMethod;
  final String transactionTime;
  final String paymentStatus;
  final String? acquirer;

  const BookingDetailEntity({
    required this.bookingId,
    required this.totalAmount,
    required this.paidAmount,
    this.currency,
    required this.paymentType,
    required this.paymentMethod,
    required this.transactionTime,
    required this.paymentStatus,
    this.acquirer,
  });

  @override
  List<Object?> get props => [
        bookingId,
        totalAmount,
        paidAmount,
        currency,
        paymentType,
        paymentMethod,
        transactionTime,
        paymentStatus,
        acquirer,
      ];
}
