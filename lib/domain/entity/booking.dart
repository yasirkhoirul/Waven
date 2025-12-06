import 'package:equatable/equatable.dart';

class Booking extends Equatable {
  final String packageId;
  final String date;
  final String startTime;
  final String endTime;
  final String paymentMethod;
  final String paymentType;
  final int amount;
  final List<String> addonIds;

  const Booking(
    this.packageId,
    this.date,
    this.startTime,
    this.endTime,
    this.paymentMethod,
    this.paymentType,
    this.amount,
    this.addonIds,
  );

  @override
  List<Object?> get props => [
        packageId,
        date,
        startTime,
        endTime,
        paymentMethod,
        paymentType,
        amount,
        addonIds,
      ];
}
