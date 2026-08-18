import 'package:cybershelf/domain/media/media_item.dart';
import 'package:cybershelf/domain/media/media_metadata.dart';
import 'package:cybershelf/domain/media/media_user_data.dart';
import 'package:cybershelf/domain/media_repository.dart';
import 'package:cybershelf/domain/media_type.dart';

class MediaService {
  const MediaService(this._repository);

  final MediaRepository _repository;

  Future<MediaItem> create({
    required MediaType type,
    required MediaMetadata metadata,
    required MediaUserData userData,
  }) {
    return _repository.create(
      type: type,
      metadata: metadata,
      userData: userData,
    );
  }

  Future<MediaItem?> getById(int id) {
    return _repository.getById(id);
  }

  Future<List<MediaItem>> getAll() {
    return _repository.getAll();
  }

  Future<MediaItem> update(MediaItem media) {
    return _repository.update(media);
  }

  Future<void> delete(int id) {
    return _repository.delete(id);
  }
}