import 'package:cybershelf/domain/media/media_item.dart';
import 'package:cybershelf/domain/media/media_metadata.dart';
import 'package:cybershelf/domain/media/media_user_data.dart';
import 'package:cybershelf/domain/media_type.dart';

abstract interface class MediaRepository {
  Future<MediaItem> create({
    required MediaType type,
    required MediaMetadata metadata,
    required MediaUserData userData,
  });

  Future<MediaItem?> getById(int id);

  Future<List<MediaItem>> getAll();

  Future<MediaItem> update(MediaItem media);

  Future<void> delete(int id);
}