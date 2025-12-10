import 'package:json_annotation/json_annotation.dart';
import 'package:waven/domain/entity/list_invoice_user.dart';

part 'listinvoicemodeluser.g.dart';

@JsonSerializable()
class ListInvoiceModelUser {
  final String message;
  final Metadata metadata;
  final List<BookingData> data;

  ListInvoiceModelUser({
    required this.message,
    required this.metadata,
    required this.data,
  });

  factory ListInvoiceModelUser.fromJson(Map<String, dynamic> json) =>
      _$ListInvoiceModelUserFromJson(json);

  Map<String, dynamic> toJson() => _$ListInvoiceModelUserToJson(this);

  ListInvoiceUserEntity toEntity() {
    return ListInvoiceUserEntity(
      message: message,
      metadata: metadata.toEntity(),
      data: data.map((e) => e.toEntity()).toList(),
    );
  }
}

@JsonSerializable()
class Metadata {
  final int count;
  final int page;
  final int limit;

  Metadata({
    required this.count,
    required this.page,
    required this.limit,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) =>
      _$MetadataFromJson(json);

  Map<String, dynamic> toJson() => _$MetadataToJson(this);

  MetadataEntity toEntity() {
    return MetadataEntity(
      count: count,
      page: page,
      limit: limit,
    );
  }
}

@JsonSerializable()
class BookingData {
  final String id;
  @JsonKey(name: 'package_name')
  final String packageName;
  final String university;
  final String status;
  final String date;
  @JsonKey(name: 'start_time')
  final String startTime;
  @JsonKey(name: 'end_time')
  final String endTime;
  final String location;

  BookingData({
    required this.id,
    required this.packageName,
    required this.university,
    required this.status,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.location,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) =>
      _$BookingDataFromJson(json);

  Map<String, dynamic> toJson() => _$BookingDataToJson(this);

  BookingDataEntity toEntity() {
    return BookingDataEntity(
      id: id,
      packageName: packageName,
      university: university,
      status: status,
      date: date,
      startTime: startTime,
      endTime: endTime,
      location: location,
    );
  }
}


