import 'package:equatable/equatable.dart';

class ListInvoiceUserEntity extends Equatable {
  final String message;
  final MetadataEntity metadata;
  final List<BookingDataEntity> data;

  const ListInvoiceUserEntity({
    required this.message,
    required this.metadata,
    required this.data,
  });
  
  @override
  List<Object?> get props => [message,metadata,data];

  
}

class MetadataEntity {
  final int count;
  final int page;
  final int limit;

  MetadataEntity({
    required this.count,
    required this.page,
    required this.limit,
  });
}

class BookingDataEntity {
  final String id;
  final String packageName;
  final String university;
  final String status;
  final String date;
  final String startTime;
  final String endTime;
  final String location;

  BookingDataEntity({
    required this.id,
    required this.packageName,
    required this.university,
    required this.status,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.location,
  });
}

class AddonNameEntity {
  final String id;
  final String name;

  AddonNameEntity({
    required this.id,
    required this.name,
  });
}
