import 'package:cybershelf/domain/media/media_item.dart';
import 'package:cybershelf/domain/media/media_metadata.dart';
import 'package:cybershelf/domain/media/media_user_data.dart';
import 'package:cybershelf/domain/media_repository.dart';
import 'package:cybershelf/domain/media_type.dart';

class FakeMediaRepository implements MediaRepository {
  final List<MediaItem> media = [];

  int createCallCount = 0;
  int updateCallCount = 0;
  int deleteCallCount = 0;
  int getByIdCallCount = 0;
  int getAllCallCount = 0;

  MediaType? createdType;
  MediaMetadata? createdMetadata;
  MediaUserData? createdUserData;

  MediaItem? updatedMedia;
  int? deletedId;
  int? requestedId;

  @override
  Future<MediaItem> create({
    required MediaType type,
    required MediaMetadata metadata,
    required MediaUserData userData,
  }) async {
    createCallCount++;
    createdType = type;
    createdMetadata = metadata;
    createdUserData = userData;

    final item = MediaItem(
      id: media.length + 1,
      type: type,
      metadata: metadata,
      userData: userData,
    );

    media.add(item);
    return item;
  }

  @override
  Future<MediaItem?> getById(int id) async {
    getByIdCallCount++;
    requestedId = id;

    for (final item in media) {
      if (item.id == id) {
        return item;
      }
    }

    return null;
  }

  @override
  Future<List<MediaItem>> getAll() async {
    getAllCallCount++;
    return List.unmodifiable(media);
  }

  @override
  Future<MediaItem> update(MediaItem item) async {
    updateCallCount++;
    updatedMedia = item;

    final index = media.indexWhere((existing) => existing.id == item.id);

    if (index == -1) {
      throw StateError('Media with ID ${item.id} does not exist.');
    }

    media[index] = item;
    return item;
  }

  @override
  Future<void> delete(int id) async {
    deleteCallCount++;
    deletedId = id;

    media.removeWhere((item) => item.id == id);
  }
}