import 'package:equatable/equatable.dart';

class AdditionalInfo extends Equatable {
  final String universityId;
  final String location;
  final String note;

  const AdditionalInfo(
    this.universityId,
    this.location,
    this.note,
  );

  @override
  List<Object?> get props => [universityId, location, note];
}
