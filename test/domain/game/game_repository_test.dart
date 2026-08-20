import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:cybershelf/data/database/app_database.dart';
import 'package:cybershelf/data/repositories/drift_game_repository.dart';
import 'package:cybershelf/domain/game/game_metadata.dart';
import 'package:cybershelf/domain/game/game_mode.dart';
import 'package:cybershelf/domain/game/game_platform.dart';
import 'package:cybershelf/domain/game/game_user_data.dart';
import 'package:cybershelf/domain/media/contributor.dart' as domain;
import 'package:cybershelf/domain/media/media_metadata.dart';
import 'package:cybershelf/domain/media/media_user_data.dart';
import 'package:cybershelf/domain/media_status.dart';
import 'package:cybershelf/domain/media_type.dart';

void main() {
  late AppDatabase database;
  late DriftGameRepository repository;

  setUp(() {
    database = AppDatabase.forTesting();
    repository = DriftGameRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('create inserts the complete game aggregate', () async {
    final game = await repository.create(
      metadata: const MediaMetadata(title: 'Test Game'),
      userData: const MediaUserData(status: MediaStatus.planned),
      gameMetadata: const GameMetadata(),
      gameUserData: const GameUserData(),
    );

    expect(game.media.id, 1);
    expect(game.media.metadata.title, 'Test Game');
    expect(game.media.userData.status, MediaStatus.planned);

    final storedGames = await database.select(database.games).get();
    expect(storedGames, hasLength(1));
    expect(storedGames.single.mediaId, game.media.id);
  });

  test('create stores and returns played modes and platforms', () async {
    final game = await repository.create(
      metadata: const MediaMetadata(title: 'Test Game'),
      userData: const MediaUserData(status: MediaStatus.completed),
      gameMetadata: const GameMetadata(),
      gameUserData: const GameUserData(
        playedModes: [GameMode.cooperative],
        playedPlatforms: [GamePlatform.pc, GamePlatform.steamDeck],
      ),
    );

    expect(game.gameUserData.playedModes, [GameMode.cooperative]);
    expect(game.gameUserData.playedPlatforms, [
      GamePlatform.pc,
      GamePlatform.steamDeck,
    ]);

    final modes = await database.select(database.gamePlayedModes).get();
    final platforms =
    await database.select(database.gamePlayedPlatforms).get();
    expect(modes, hasLength(1));
    expect(platforms, hasLength(2));
  });

  test('create stores and returns developers and publishers', () async {
    final personId = await database.into(database.people).insert(
      PeopleCompanion.insert(name: 'Hideo Kojima'),
    );
    final companyId = await database.into(database.companies).insert(
      CompaniesCompanion.insert(name: 'Konami'),
    );
    final developerContributorId =
    await database.into(database.contributors).insert(
      ContributorsCompanion.insert(personId: Value(personId)),
    );
    final publisherContributorId =
    await database.into(database.contributors).insert(
      ContributorsCompanion.insert(companyId: Value(companyId)),
    );

    final game = await repository.create(
      metadata: const MediaMetadata(title: 'Test Game'),
      userData: const MediaUserData(status: MediaStatus.planned),
      gameMetadata: GameMetadata(
        developers: [
          domain.Contributor(id: developerContributorId, personId: personId),
        ],
        publishers: [
          domain.Contributor(
            id: publisherContributorId,
            companyId: companyId,
          ),
        ],
      ),
      gameUserData: const GameUserData(),
    );

    expect(game.gameMetadata.developers, hasLength(1));
    expect(game.gameMetadata.developers.first.id, developerContributorId);
    expect(game.gameMetadata.publishers, hasLength(1));
    expect(game.gameMetadata.publishers.first.id, publisherContributorId);

    final developers = await database.select(database.gameDevelopers).get();
    final publishers = await database.select(database.gamePublishers).get();
    expect(developers, hasLength(1));
    expect(publishers, hasLength(1));
  });

  test('getById returns the complete game item', () async {
    final created = await repository.create(
      metadata: const MediaMetadata(title: 'Test Game'),
      userData: const MediaUserData(
        status: MediaStatus.completed,
        rating: 90,
      ),
      gameMetadata: const GameMetadata(),
      gameUserData: const GameUserData(
        playedModes: [GameMode.singlePlayer],
        playedPlatforms: [GamePlatform.pc],
      ),
    );

    final result = await repository.getById(created.media.id);

    expect(result, isNotNull);
    expect(result!.media.id, created.media.id);
    expect(result.media.metadata.title, 'Test Game');
    expect(result.media.userData.rating, 90);
    expect(result.gameMetadata.developers, isEmpty);
    expect(result.gameMetadata.publishers, isEmpty);
    expect(result.gameUserData.playedModes, [GameMode.singlePlayer]);
    expect(result.gameUserData.playedPlatforms, [GamePlatform.pc]);
  });

  test('getById returns null for an unknown ID', () async {
    final result = await repository.getById(999);
    expect(result, isNull);
  });

  test('getById returns null when media exists but is not a game', () async {
    final mediaId = await database.into(database.media).insert(
      MediaCompanion.insert(
        mediaType: MediaType.game,
        createdAt: DateTime(2026, 8, 18),
        updatedAt: DateTime(2026, 8, 18),
      ),
    );
    await database.into(database.mediaMetadata).insert(
      MediaMetadataCompanion.insert(
        mediaId: Value(mediaId),
        title: 'No Game Row',
        updatedAt: DateTime(2026, 8, 18),
      ),
    );
    await database.into(database.mediaUserData).insert(
      MediaUserDataCompanion.insert(
        mediaId: Value(mediaId),
        status: MediaStatus.planned,
        updatedAt: DateTime(2026, 8, 18),
      ),
    );

    final result = await repository.getById(mediaId);
    expect(result, isNull);
  });

  test('getAll returns an empty list when there are no games', () async {
    final result = await repository.getAll();
    expect(result, isEmpty);
  });

  test('getAll returns all games newest first', () async {
    final first = await repository.create(
      metadata: const MediaMetadata(title: 'First Game'),
      userData: const MediaUserData(status: MediaStatus.planned),
      gameMetadata: const GameMetadata(),
      gameUserData: const GameUserData(),
    );

    final second = await repository.create(
      metadata: const MediaMetadata(title: 'Second Game'),
      userData: const MediaUserData(status: MediaStatus.planned),
      gameMetadata: const GameMetadata(),
      gameUserData: const GameUserData(),
    );

    final result = await repository.getAll();

    expect(result, hasLength(2));
    expect(result[0].media.id, second.media.id);
    expect(result[1].media.id, first.media.id);
  });

  test('update changes values while preserving createdAt', () async {
    final original = await repository.create(
      metadata: const MediaMetadata(title: 'Original Title'),
      userData: const MediaUserData(status: MediaStatus.planned),
      gameMetadata: const GameMetadata(),
      gameUserData: const GameUserData(),
    );

    final originalMediaRow =
    await database.select(database.media).getSingle();

    await Future<void>.delayed(const Duration(milliseconds: 2));

    // Create a person and company first
    final personId = await database.into(database.people).insert(
      PeopleCompanion.insert(name: 'Test Developer'),
    );
    final companyId = await database.into(database.companies).insert(
      CompaniesCompanion.insert(name: 'Test Publisher'),
    );

    // Create contributors
    final developerContributorId = await database.into(database.contributors).insert(
      ContributorsCompanion.insert(personId: Value(personId)),
    );
    final publisherContributorId = await database.into(database.contributors).insert(
      ContributorsCompanion.insert(companyId: Value(companyId)),
    );

    final updated = original.copyWith(
      media: original.media.copyWith(
        metadata: original.media.metadata.copyWith(title: 'Updated Title'),
        userData: original.media.userData.copyWith(
          status: MediaStatus.completed,
        ),
      ),
      gameMetadata: original.gameMetadata.copyWith(
        developers: [
          domain.Contributor(id: developerContributorId, personId: personId),
        ],
        publishers: [
          domain.Contributor(id: publisherContributorId, companyId: companyId),
        ],
      ),
      gameUserData: original.gameUserData.copyWith(
        playedModes: [GameMode.singlePlayer],
        playedPlatforms: [GamePlatform.pc],
      ),
    );

    final result = await repository.update(updated);

    final updatedMediaRow =
    await database.select(database.media).getSingle();

    expect(result.media.metadata.title, 'Updated Title');
    expect(result.media.userData.status, MediaStatus.completed);
    expect(result.gameMetadata.developers, hasLength(1));
    expect(result.gameMetadata.developers.first.id, developerContributorId);
    expect(result.gameMetadata.publishers, hasLength(1));
    expect(result.gameMetadata.publishers.first.id, publisherContributorId);
    expect(result.gameUserData.playedModes, [GameMode.singlePlayer]);
    expect(result.gameUserData.playedPlatforms, [GamePlatform.pc]);

    expect(updatedMediaRow.createdAt, originalMediaRow.createdAt);
  });

  test('delete removes the complete game aggregate', () async {
    final game = await repository.create(
      metadata: const MediaMetadata(title: 'Test Game'),
      userData: const MediaUserData(status: MediaStatus.planned),
      gameMetadata: const GameMetadata(),
      gameUserData: const GameUserData(
        playedModes: [GameMode.singlePlayer],
        playedPlatforms: [GamePlatform.pc],
      ),
    );

    await repository.delete(game.media.id);

    expect(await database.select(database.media).get(), isEmpty);
    expect(await database.select(database.games).get(), isEmpty);
    expect(await database.select(database.gamePlayedModes).get(), isEmpty);
    expect(
      await database.select(database.gamePlayedPlatforms).get(),
      isEmpty,
    );
  });

  test('delete does nothing when the ID does not exist', () async {
    await repository.delete(999);
    expect(await database.select(database.media).get(), isEmpty);
  });
}