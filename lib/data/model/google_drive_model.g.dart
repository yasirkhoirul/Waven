// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_drive_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoogleDriveResponse _$GoogleDriveResponseFromJson(Map<String, dynamic> json) =>
    GoogleDriveResponse(
      message: json['message'] as String,
      metadata: Metadata.fromJson(json['metadata'] as Map<String, dynamic>),
      data: (json['data'] as List<dynamic>)
          .map((e) => GoogleDriveFile.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GoogleDriveResponseToJson(
  GoogleDriveResponse instance,
) => <String, dynamic>{
  'message': instance.message,
  'metadata': instance.metadata,
  'data': instance.data,
};

Metadata _$MetadataFromJson(Map<String, dynamic> json) => Metadata(
  count: (json['count'] as num).toInt(),
  page: (json['page'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  hasMore: json['has_more'] as bool,
);

Map<String, dynamic> _$MetadataToJson(Metadata instance) => <String, dynamic>{
  'count': instance.count,
  'page': instance.page,
  'limit': instance.limit,
  'has_more': instance.hasMore,
};

GoogleDriveFile _$GoogleDriveFileFromJson(Map<String, dynamic> json) =>
    GoogleDriveFile(id: json['id'] as String, name: json['name'] as String);

Map<String, dynamic> _$GoogleDriveFileToJson(GoogleDriveFile instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};
