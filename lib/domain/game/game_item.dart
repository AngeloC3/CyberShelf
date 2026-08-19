import 'package:cybershelf/domain/media/media_item.dart';
import 'package:cybershelf/domain/game/game_metadata.dart';
import 'package:cybershelf/domain/game/game_user_data.dart';

/// A game, extending the common [MediaItem] rather than duplicating
/// its fields — mirrors the DB shape where `games.media_id` extends
/// `media.id`.
class GameItem {
  const GameItem({
    required this.media,
    required this.gameMetadata,
    required this.gameUserData,
  });

  final MediaItem media;
  final GameMetadata gameMetadata;
  final GameUserData gameUserData;

  GameItem copyWith({
    MediaItem? media,
    GameMetadata? gameMetadata,
    GameUserData? gameUserData,
  }) {
    return GameItem(
      media: media ?? this.media,
      gameMetadata: gameMetadata ?? this.gameMetadata,
      gameUserData: gameUserData ?? this.gameUserData,
    );
  }
}