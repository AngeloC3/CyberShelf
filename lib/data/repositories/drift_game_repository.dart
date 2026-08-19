import 'package:drift/drift.dart';
import 'package:cybershelf/data/database/app_database.dart';
import 'package:cybershelf/data/repositories/drift_media_repository.dart';
import 'package:cybershelf/domain/game/game_item.dart';
import 'package:cybershelf/domain/game/game_metadata.dart';
import 'package:cybershelf/domain/game/game_repository.dart';
import 'package:cybershelf/domain/game/game_user_data.dart';
import 'package:cybershelf/domain/media/contributor.dart' as domain;
import 'package:cybershelf/domain/media/media_metadata.dart';
import 'package:cybershelf/domain/media/media_user_data.dart';
import 'package:cybershelf/domain/media_type.dart';

class DriftGameRepository implements GameRepository {
  DriftGameRepository(this._database)
      : _mediaRepository = DriftMediaRepository(_database);

  final AppDatabase _database;
  final DriftMediaRepository _mediaRepository;

  @override
  Future<GameItem> create({
    required MediaMetadata metadata,
    required MediaUserData userData,
    required GameMetadata gameMetadata,
    required GameUserData gameUserData,
  }) async {
    return _database.transaction(() async {
      final media = await _mediaRepository.create(
        type: MediaType.game,
        metadata: metadata,
        userData: userData,
      );

      await _database.into(_database.games).insert(
        GamesCompanion.insert(mediaId: Value(media.id)),
      );

      await _insertGameMetadata(media.id, gameMetadata);
      await _insertGameUserData(media.id, gameUserData);

      return GameItem(
        media: media,
        gameMetadata: gameMetadata,
        gameUserData: gameUserData,
      );
    });
  }

  @override
  Future<GameItem?> getById(int id) async {
    final media = await _mediaRepository.getById(id);
    if (media == null) return null;

    final gameRow = await (_database.select(_database.games)
      ..where((g) => g.mediaId.equals(id)))
        .getSingleOrNull();

    if (gameRow == null) return null;

    final gameMetadata = await _readGameMetadata(id);
    final gameUserData = await _readGameUserData(id);

    return GameItem(
      media: media,
      gameMetadata: gameMetadata,
      gameUserData: gameUserData,
    );
  }

  @override
  Future<List<GameItem>> getAll() async {
    final query = _database.select(_database.media).join([
      innerJoin(
        _database.games,
        _database.games.mediaId.equalsExp(_database.media.id),
      ),
    ])
      ..orderBy([
        OrderingTerm(
          expression: _database.media.createdAt,
          mode: OrderingMode.desc,
        ),
        OrderingTerm(
          expression: _database.media.id,
          mode: OrderingMode.desc,
        ),
      ]);

    final rows = await query.get();

    final result = <GameItem>[];

    for (final row in rows) {
      final mediaRow = row.readTable(_database.media);
      final game = await getById(mediaRow.id);

      if (game != null) {
        result.add(game);
      }
    }

    return result;
  }

  @override
  Future<GameItem> update(GameItem game) async {
    return _database.transaction(() async {
      final updatedMedia = await _mediaRepository.update(game.media);

      await (_database.delete(_database.gameAvailableModes)
        ..where((m) => m.mediaId.equals(game.media.id)))
          .go();
      await (_database.delete(_database.gameDevelopers)
        ..where((d) => d.mediaId.equals(game.media.id)))
          .go();
      await (_database.delete(_database.gamePublishers)
        ..where((p) => p.mediaId.equals(game.media.id)))
          .go();
      await (_database.delete(_database.gamePlayedModes)
        ..where((m) => m.mediaId.equals(game.media.id)))
          .go();
      await (_database.delete(_database.gamePlayedPlatforms)
        ..where((p) => p.mediaId.equals(game.media.id)))
          .go();

      await _insertGameMetadata(game.media.id, game.gameMetadata);
      await _insertGameUserData(game.media.id, game.gameUserData);

      return GameItem(
        media: updatedMedia,
        gameMetadata: game.gameMetadata,
        gameUserData: game.gameUserData,
      );
    });
  }

  @override
  Future<void> delete(int id) async {
    // The games row and all game-specific relationships cascade from
    // the media delete via foreign keys, so deleting through the
    // media repository is sufficient.
    await _mediaRepository.delete(id);
  }

  Future<void> _insertGameMetadata(
      int mediaId,
      GameMetadata gameMetadata,
      ) async {
    for (final mode in gameMetadata.availableModes) {
      await _database.into(_database.gameAvailableModes).insert(
        GameAvailableModesCompanion.insert(mediaId: mediaId, mode: mode),
      );
    }

    for (final developer in gameMetadata.developers) {
      await _database.into(_database.gameDevelopers).insert(
        GameDevelopersCompanion.insert(
          mediaId: mediaId,
          contributorId: developer.id,
        ),
      );
    }

    for (final publisher in gameMetadata.publishers) {
      await _database.into(_database.gamePublishers).insert(
        GamePublishersCompanion.insert(
          mediaId: mediaId,
          contributorId: publisher.id,
        ),
      );
    }
  }

  Future<void> _insertGameUserData(
      int mediaId,
      GameUserData gameUserData,
      ) async {
    for (final mode in gameUserData.playedModes) {
      await _database.into(_database.gamePlayedModes).insert(
        GamePlayedModesCompanion.insert(mediaId: mediaId, mode: mode),
      );
    }

    for (final platform in gameUserData.playedPlatforms) {
      await _database.into(_database.gamePlayedPlatforms).insert(
        GamePlayedPlatformsCompanion.insert(
          mediaId: mediaId,
          platform: platform,
        ),
      );
    }
  }

  Future<GameMetadata> _readGameMetadata(int mediaId) async {
    final modeRows = await (_database.select(_database.gameAvailableModes)
      ..where((m) => m.mediaId.equals(mediaId)))
        .get();

    final developerRows = await (_database.select(_database.gameDevelopers)
      ..where((d) => d.mediaId.equals(mediaId)))
        .get();

    final publisherRows = await (_database.select(_database.gamePublishers)
      ..where((p) => p.mediaId.equals(mediaId)))
        .get();

    final developers = await _readContributors(
      developerRows.map((row) => row.contributorId),
    );

    final publishers = await _readContributors(
      publisherRows.map((row) => row.contributorId),
    );

    return GameMetadata(
      availableModes: modeRows.map((row) => row.mode).toList(),
      developers: developers,
      publishers: publishers,
    );
  }

  Future<GameUserData> _readGameUserData(int mediaId) async {
    final modeRows = await (_database.select(_database.gamePlayedModes)
      ..where((m) => m.mediaId.equals(mediaId)))
        .get();

    final platformRows =
    await (_database.select(_database.gamePlayedPlatforms)
      ..where((p) => p.mediaId.equals(mediaId)))
        .get();

    return GameUserData(
      playedModes: modeRows.map((row) => row.mode).toList(),
      playedPlatforms: platformRows.map((row) => row.platform).toList(),
    );
  }

  Future<List<domain.Contributor>> _readContributors(
      Iterable<int> contributorIds,
      ) async {
    final contributors = <domain.Contributor>[];

    for (final contributorId in contributorIds) {
      final row = await (_database.select(_database.contributors)
        ..where((c) => c.id.equals(contributorId)))
          .getSingle();

      contributors.add(
        domain.Contributor(
          id: row.id,
          personId: row.personId,
          companyId: row.companyId,
        ),
      );
    }

    return contributors;
  }
}