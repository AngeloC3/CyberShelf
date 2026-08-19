import 'package:cybershelf/domain/game/game_item.dart';
import 'package:cybershelf/domain/game/game_metadata.dart';
import 'package:cybershelf/domain/game/game_repository.dart';
import 'package:cybershelf/domain/game/game_user_data.dart';
import 'package:cybershelf/domain/media/media_item.dart';
import 'package:cybershelf/domain/media/media_metadata.dart';
import 'package:cybershelf/domain/media/media_user_data.dart';
import 'package:cybershelf/domain/media_type.dart';

class FakeGameRepository implements GameRepository {
  final List<GameItem> games = [];

  int createCallCount = 0;
  int updateCallCount = 0;
  int deleteCallCount = 0;
  int getByIdCallCount = 0;
  int getAllCallCount = 0;

  MediaMetadata? createdMetadata;
  MediaUserData? createdUserData;
  GameMetadata? createdGameMetadata;
  GameUserData? createdGameUserData;

  GameItem? updatedGame;
  int? deletedId;
  int? requestedId;

  int _nextId = 1;

  @override
  Future<GameItem> create({
    required MediaMetadata metadata,
    required MediaUserData userData,
    required GameMetadata gameMetadata,
    required GameUserData gameUserData,
  }) async {
    createCallCount++;
    createdMetadata = metadata;
    createdUserData = userData;
    createdGameMetadata = gameMetadata;
    createdGameUserData = gameUserData;

    final item = GameItem(
      media: MediaItem(
        id: _nextId++,
        type: MediaType.game,
        metadata: metadata,
        userData: userData,
      ),
      gameMetadata: gameMetadata,
      gameUserData: gameUserData,
    );

    games.add(item);
    return item;
  }

  @override
  Future<GameItem?> getById(int id) async {
    getByIdCallCount++;
    requestedId = id;

    try {
      return games.firstWhere((item) => item.media.id == id);
    } on StateError {
      return null;
    }
  }

  @override
  Future<List<GameItem>> getAll() async {
    getAllCallCount++;
    return List.unmodifiable(games);
  }

  @override
  Future<GameItem> update(GameItem item) async {
    updateCallCount++;
    updatedGame = item;

    final index = games.indexWhere((existing) => existing.media.id == item.media.id);

    if (index == -1) {
      throw StateError('Game with ID ${item.media.id} does not exist.');
    }

    games[index] = item;
    return item;
  }

  @override
  Future<void> delete(int id) async {
    deleteCallCount++;
    deletedId = id;

    games.removeWhere((item) => item.media.id == id);
  }
}