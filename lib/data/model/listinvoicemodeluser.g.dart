// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listinvoicemodeluser.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListInvoiceModelUser _$ListInvoiceModelUserFromJson(
  Map<String, dynamic> json,
) => ListInvoiceModelUser(
  message: json['message'] as String,
  metadata: Metadata.fromJson(json['metadata'] as Map<String, dynamic>),
  data: (json['data'] as List<dynamic>)
      .map((e) => BookingData.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ListInvoiceModelUserToJson(
  ListInvoiceModelUser instance,
) => <String, dynamic>{
  'message': instance.message,
  'metadata': instance.metadata,
  'data': instance.data,
};

Metadata _$MetadataFromJson(Map<String, dynamic> json) => Metadata(
  count: (json['count'] as num).toInt(),
  page: (json['page'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
);

Map<String, dynamic> _$MetadataToJson(Metadata instance) => <String, dynamic>{
  'count': instance.count,
  'page': instance.page,
  'limit': instance.limit,
};

BookingData _$BookingDataFromJson(Map<String, dynamic> json) => BookingData(
  id: json['id'] as String,
  packageName: json['package_name'] as String,
  university: json['university'] as String,
  status: json['status'] as String,
  date: json['date'] as String,
  startTime: json['start_time'] as String,
  endTime: json['end_time'] as String,
  location: json['location'] as String,
);

Map<String, dynamic> _$BookingDataToJson(BookingData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'package_name': instance.packageName,
      'university': instance.university,
      'status': instance.status,
      'date': instance.date,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'location': instance.location,
    };
