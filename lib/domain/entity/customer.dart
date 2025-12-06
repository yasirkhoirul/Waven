import 'package:equatable/equatable.dart';

class Customer extends Equatable {
  final String fullName;
  final String whatsappNumber;
  final String instagram;

  const Customer(
    this.fullName,
    this.whatsappNumber,
    this.instagram,
  );

  @override
  List<Object?> get props => [fullName, whatsappNumber, instagram];
}
