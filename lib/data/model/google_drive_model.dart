import 'package:json_annotation/json_annotation.dart';
import 'package:waven/domain/entity/list_gdrive.dart';

part 'google_drive_model.g.dart';

@JsonSerializable()
class GoogleDriveResponse {
  final String message;
  final Metadata metadata;
  final List<GoogleDriveFile> data;

  GoogleDriveResponse({
    required this.message,
    required this.metadata,
    required this.data,
  });

  factory GoogleDriveResponse.fromJson(Map<String, dynamic> json) =>
      _$GoogleDriveResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GoogleDriveResponseToJson(this);

  ListGdriveEntity toEntity() {
    return ListGdriveEntity(
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
  @JsonKey(name: 'has_more')
  final bool hasMore;

  Metadata({
    required this.count,
    required this.page,
    required this.limit,
    required this.hasMore,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) =>
      _$MetadataFromJson(json);

  Map<String, dynamic> toJson() => _$MetadataToJson(this);

  MetadataEntity toEntity() {
    return MetadataEntity(
      count: count,
      page: page,
      limit: limit,
      hasMore: hasMore,
    );
  }
}

@JsonSerializable()
class GoogleDriveFile {
  final String id;
  final String name;

  GoogleDriveFile({
    required this.id,
    required this.name,
  });

  factory GoogleDriveFile.fromJson(Map<String, dynamic> json) =>
      _$GoogleDriveFileFromJson(json);

  Map<String, dynamic> toJson() => _$GoogleDriveFileToJson(this);

  GoogleDriveFileEntity toEntity() {
    return GoogleDriveFileEntity(
      id: id,
      name: name,
    );
  }
}
