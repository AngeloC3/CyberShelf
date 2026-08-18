import 'package:cybershelf/domain/media_type.dart';
import 'package:cybershelf/domain/media/media_metadata.dart';
import 'package:cybershelf/domain/media/media_user_data.dart';

class MediaItem {
  const MediaItem({
    required this.id,
    required this.type,
    required this.metadata,
    required this.userData,
  });

  final int id;
  final MediaType type;
  final MediaMetadata metadata;
  final MediaUserData userData;

  MediaItem copyWith({
    int? id,
    MediaType? type,
    MediaMetadata? metadata,
    MediaUserData? userData,
  }) {
    return MediaItem(
      id: id ?? this.id,
      type: type ?? this.type,
      metadata: metadata ?? this.metadata,
      userData: userData ?? this.userData,
    );
  }
}