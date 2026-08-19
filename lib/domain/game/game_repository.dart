import 'package:cybershelf/domain/game/game_item.dart';
import 'package:cybershelf/domain/game/game_metadata.dart';
import 'package:cybershelf/domain/game/game_user_data.dart';
import 'package:cybershelf/domain/media/media_metadata.dart';
import 'package:cybershelf/domain/media/media_user_data.dart';

/// Repository contract for games.
///
/// Separate from [MediaRepository] by design: Media is the shared
/// aggregate root across all media types (games, and eventually
/// books, movies, TV shows, etc.), while each media type gets its
/// own repository composing the shared media operations with its
/// own type-specific data.
abstract interface class GameRepository {
  Future<GameItem> create({
    required MediaMetadata metadata,
    required MediaUserData userData,
    required GameMetadata gameMetadata,
    required GameUserData gameUserData,
  });

  Future<GameItem?> getById(int id);

  Future<List<GameItem>> getAll();

  Future<GameItem> update(GameItem game);

  Future<void> delete(int id);
}