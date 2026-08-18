import 'package:cybershelf/domain/media_type.dart';
import 'package:cybershelf/domain/media/media_metadata.dart';
import 'package:cybershelf/domain/media/media_user_data.dart';

abstract class MediaItem {
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
}