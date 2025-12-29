class ListGdriveEntity {
  final String message;
  final MetadataEntity metadata;
  final List<GoogleDriveFileEntity> data;

  ListGdriveEntity({
    required this.message,
    required this.metadata,
    required this.data,
  });
}

class MetadataEntity {
  final int count;
  final int page;
  final int limit;
  final bool hasMore;

  MetadataEntity({
    required this.count,
    required this.page,
    required this.limit,
    required this.hasMore,
  });
}

class GoogleDriveFileEntity {
  final String id;
  final String name;

  GoogleDriveFileEntity({
    required this.id,
    required this.name,
  });
}
