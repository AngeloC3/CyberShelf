import 'package:flutter_test/flutter_test.dart';
import 'package:cybershelf/application/game/game_service.dart';
import 'package:cybershelf/data/database/app_database.dart';
import 'package:cybershelf/domain/date_only.dart';
import 'package:cybershelf/domain/game/external_game_source.dart';
import 'package:cybershelf/domain/game/game_metadata.dart';
import 'package:cybershelf/domain/game/game_mode.dart';
import 'package:cybershelf/domain/game/game_platform.dart';
import 'package:cybershelf/domain/game/game_user_data.dart';
import 'package:cybershelf/domain/media/contributor.dart' as domain;
import 'package:cybershelf/domain/media/genre.dart' as domain;
import 'package:cybershelf/domain/media/media_metadata.dart';
import 'package:cybershelf/domain/media/media_user_data.dart';
import 'package:cybershelf/domain/media/tag.dart' as domain;
import 'package:cybershelf/domain/media/theme.dart' as domain;
import 'package:cybershelf/domain/media_status.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart';

import '../../helpers/fake_game_repository.dart';

void main() {
  // Initialize the binding for tests that need it
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GameService', () {
    test('create creates a game through the repository', () async {
      final repository = FakeGameRepository();
      final service = GameService(repository);

      const metadata = MediaMetadata(title: 'Test Game');
      const userData = MediaUserData(status: MediaStatus.planned);
      const gameMetadata = GameMetadata(
        availableModes: [GameMode.singlePlayer],
      );
      const gameUserData = GameUserData(
        playedModes: [GameMode.singlePlayer],
        playedPlatforms: [GamePlatform.pc],
      );

      final result = await service.create(
        metadata: metadata,
        userData: userData,
        gameMetadata: gameMetadata,
        gameUserData: gameUserData,
      );

      expect(result.media.id, 1);
      expect(result.media.metadata.title, 'Test Game');
      expect(result.media.userData.status, MediaStatus.planned);
      expect(result.gameMetadata.availableModes, [GameMode.singlePlayer]);
      expect(result.gameUserData.playedModes, [GameMode.singlePlayer]);
      expect(result.gameUserData.playedPlatforms, [GamePlatform.pc]);

      expect(repository.createCallCount, 1);
      expect(repository.createdMetadata, metadata);
      expect(repository.createdUserData, userData);
      expect(repository.createdGameMetadata, gameMetadata);
      expect(repository.createdGameUserData, gameUserData);
    });

    test('update updates a game through the repository', () async {
      final repository = FakeGameRepository();

      final original = await repository.create(
        metadata: const MediaMetadata(title: 'Original Title'),
        userData: const MediaUserData(status: MediaStatus.planned),
        gameMetadata: const GameMetadata(
          availableModes: [GameMode.singlePlayer],
        ),
        gameUserData: const GameUserData(),
      );

      final service = GameService(repository);

      final updated = original.copyWith(
        media: original.media.copyWith(
          metadata: original.media.metadata.copyWith(
            title: 'Updated Title',
          ),
          userData: original.media.userData.copyWith(
            status: MediaStatus.completed,
          ),
        ),
        gameMetadata: original.gameMetadata.copyWith(
          availableModes: [GameMode.singlePlayer, GameMode.cooperative],
        ),
        gameUserData: original.gameUserData.copyWith(
          playedModes: [GameMode.cooperative],
          playedPlatforms: [GamePlatform.steamDeck],
        ),
      );

      final result = await service.update(updated);

      // Compare individual properties instead of the whole object
      expect(result.media.id, updated.media.id);
      expect(result.media.metadata.title, updated.media.metadata.title);
      expect(result.media.userData.status, updated.media.userData.status);
      expect(result.gameMetadata.availableModes, updated.gameMetadata.availableModes);
      expect(result.gameUserData.playedModes, updated.gameUserData.playedModes);
      expect(result.gameUserData.playedPlatforms, updated.gameUserData.playedPlatforms);

      expect(repository.updateCallCount, 1);

      final stored = await repository.getById(original.media.id);
      expect(stored, isNot(null));
      expect(stored!.media.metadata.title, 'Updated Title');
      expect(stored.media.userData.status, MediaStatus.completed);
    });

    test('getById gets a game through the repository', () async {
      final repository = FakeGameRepository();

      final created = await repository.create(
        metadata: const MediaMetadata(title: 'Test Game'),
        userData: const MediaUserData(status: MediaStatus.planned),
        gameMetadata: const GameMetadata(),
        gameUserData: const GameUserData(),
      );

      final service = GameService(repository);

      final result = await service.getById(created.media.id);

      expect(result, isNot(null));
      expect(result!.media.id, created.media.id);
      expect(result.media.metadata.title, created.media.metadata.title);
      expect(repository.getByIdCallCount, 1);
      expect(repository.requestedId, created.media.id);
    });

    test('getAll gets all games through the repository', () async {
      final repository = FakeGameRepository();

      final first = await repository.create(
        metadata: const MediaMetadata(title: 'First Game'),
        userData: const MediaUserData(status: MediaStatus.planned),
        gameMetadata: const GameMetadata(),
        gameUserData: const GameUserData(),
      );

      final second = await repository.create(
        metadata: const MediaMetadata(title: 'Second Game'),
        userData: const MediaUserData(status: MediaStatus.completed),
        gameMetadata: const GameMetadata(),
        gameUserData: const GameUserData(),
      );

      final service = GameService(repository);

      final result = await service.getAll();

      expect(result, hasLength(2));
      expect(result[0].media.id, first.media.id);
      expect(result[1].media.id, second.media.id);
      expect(repository.getAllCallCount, 1);
    });

    test('delete deletes a game through the repository', () async {
      final repository = FakeGameRepository();

      final created = await repository.create(
        metadata: const MediaMetadata(title: 'Test Game'),
        userData: const MediaUserData(status: MediaStatus.planned),
        gameMetadata: const GameMetadata(),
        gameUserData: const GameUserData(),
      );

      final service = GameService(repository);

      await service.delete(created.media.id);

      expect(repository.deleteCallCount, 1);
      expect(repository.deletedId, created.media.id);
      expect(await repository.getById(created.media.id), null);
    });

    group('importFromExternalSource', () {
      late AppDatabase database;

      setUp(() {
        // Use an in-memory database for testing
        database = AppDatabase(
          NativeDatabase.memory(
            setup: (db) {
              db.execute('PRAGMA foreign_keys = ON');
            },
          ),
        );
      });

      tearDown(() async {
        await database.close();
      });

      test('imports a game from external source', () async {
        final repository = FakeGameRepository();
        final service = GameService(repository, database: database);

        final releaseDate = DateOnly(year: 2024, month: 11, day: 15);
        final genres = [
          domain.Genre(id: 1, name: 'Action'),
          domain.Genre(id: 2, name: 'RPG'),
        ];
        final themes = [
          domain.Theme(id: 1, name: 'Fantasy'),
        ];
        const gameModes = [GameMode.singlePlayer, GameMode.multiplayer];

        final externalResult = ExternalGameResult(
          title: 'Imported Game',
          genres: genres,
          themes: themes,
          gameModes: gameModes,
          developers: ['Developer 1'],
          publishers: ['Publisher 1'],
          releaseDate: releaseDate,
          coverUrl: 'https://example.com/cover.jpg',
          series: ['Series 1'],
        );

        final result = await service.importFromExternalSource(externalResult);

        expect(result.media.metadata.title, 'Imported Game');
        expect(result.media.metadata.genres, hasLength(2));
        expect(result.media.metadata.genres[0].name, 'Action');
        expect(result.media.metadata.genres[1].name, 'RPG');
        expect(result.media.metadata.themes, hasLength(1));
        expect(result.media.metadata.themes[0].name, 'Fantasy');
        expect(result.media.metadata.releaseDate, releaseDate);
        expect(result.media.metadata.coverUrl, 'https://example.com/cover.jpg');
        expect(result.media.userData.status, MediaStatus.planned);
        expect(result.gameMetadata.availableModes, gameModes);
        expect(result.gameUserData.playedModes, isEmpty);
        expect(result.gameUserData.playedPlatforms, isEmpty);

        expect(repository.createCallCount, 1);
      });

      test('handles empty optional fields', () async {
        final repository = FakeGameRepository();
        final service = GameService(repository, database: database);

        final externalResult = ExternalGameResult(
          title: 'Minimal Game',
        );

        final result = await service.importFromExternalSource(externalResult);

        expect(result.media.metadata.title, 'Minimal Game');
        expect(result.media.metadata.genres, isEmpty);
        expect(result.media.metadata.themes, isEmpty);
        expect(result.media.metadata.releaseDate, null);
        expect(result.media.metadata.coverUrl, null);
        expect(result.media.userData.status, MediaStatus.planned);
        expect(result.gameMetadata.availableModes, isEmpty);
        expect(result.gameUserData.playedModes, isEmpty);
        expect(result.gameUserData.playedPlatforms, isEmpty);

        expect(repository.createCallCount, 1);
      });

      test('reuses existing genres and themes', () async {
        final repository = FakeGameRepository();
        final service = GameService(repository, database: database);

        // Pre-populate a genre and theme
        final existingGenreId = await database.into(database.genres).insert(
          GenresCompanion.insert(name: 'Action'),
        );

        final existingThemeId = await database.into(database.themes).insert(
          ThemesCompanion.insert(name: 'Fantasy'),
        );

        final genres = [
          domain.Genre(id: 1, name: 'Action'),
          domain.Genre(id: 2, name: 'RPG'),
        ];
        final themes = [
          domain.Theme(id: 1, name: 'Fantasy'),
          domain.Theme(id: 2, name: 'Sci-Fi'),
        ];

        final externalResult = ExternalGameResult(
          title: 'Imported Game',
          genres: genres,
          themes: themes,
        );

        final result = await service.importFromExternalSource(externalResult);

        // Action and Fantasy should reuse existing IDs
        expect(result.media.metadata.genres[0].id, existingGenreId);
        expect(result.media.metadata.genres[1].id, isNot(existingGenreId));
        expect(result.media.metadata.themes[0].id, existingThemeId);
        expect(result.media.metadata.themes[1].id, isNot(existingThemeId));

        // Verify the new genre and theme were created
        final allGenres = await database.select(database.genres).get();
        final allThemes = await database.select(database.themes).get();
        expect(allGenres, hasLength(2));
        expect(allThemes, hasLength(2));
      });
    });

    group('update with tag resolution', () {
      late AppDatabase database;
      late FakeGameRepository repository;
      late GameService service;

      setUp(() {
        database = AppDatabase(
          NativeDatabase.memory(
            setup: (db) {
              db.execute('PRAGMA foreign_keys = ON');
            },
          ),
        );
        repository = FakeGameRepository();
        service = GameService(repository, database: database);
      });

      tearDown(() async {
        await database.close();
      });

      test('creates new tags when updating with temporary IDs', () async {
        // Create a game first
        final game = await repository.create(
          metadata: const MediaMetadata(title: 'Test Game'),
          userData: const MediaUserData(status: MediaStatus.planned),
          gameMetadata: const GameMetadata(),
          gameUserData: const GameUserData(),
        );

        // Add tags with temporary IDs (-1)
        final tags = [
          domain.Tag(id: -1, name: 'New Tag 1'),
          domain.Tag(id: -1, name: 'New Tag 2'),
        ];

        final updatedUserData = game.media.userData.copyWith(tags: tags);
        final updatedMedia = game.media.copyWith(userData: updatedUserData);
        final updatedGame = game.copyWith(media: updatedMedia);

        final result = await service.update(updatedGame);

        // Tags should have real IDs now
        expect(result.media.userData.tags, hasLength(2));
        expect(result.media.userData.tags[0].id, isNot(-1));
        expect(result.media.userData.tags[0].name, 'New Tag 1');
        expect(result.media.userData.tags[1].id, isNot(-1));
        expect(result.media.userData.tags[1].name, 'New Tag 2');

        // Verify tags exist in database
        final dbTags = await database.select(database.tags).get();
        expect(dbTags, hasLength(2));
        expect(dbTags.map((t) => t.name), containsAll(['New Tag 1', 'New Tag 2']));
      });

      test('reuses existing tags by name', () async {
        // Pre-create a tag in the database
        final existingTagId = await database.into(database.tags).insert(
          TagsCompanion.insert(name: 'Existing Tag'),
        );

        // Create a game
        final game = await repository.create(
          metadata: const MediaMetadata(title: 'Test Game'),
          userData: const MediaUserData(status: MediaStatus.planned),
          gameMetadata: const GameMetadata(),
          gameUserData: const GameUserData(),
        );

        // Add the existing tag (with name match) and a new tag
        final tags = [
          domain.Tag(id: -1, name: 'Existing Tag'), // Should reuse
          domain.Tag(id: -1, name: 'Another New Tag'), // Should create
        ];

        final updatedUserData = game.media.userData.copyWith(tags: tags);
        final updatedMedia = game.media.copyWith(userData: updatedUserData);
        final updatedGame = game.copyWith(media: updatedMedia);

        final result = await service.update(updatedGame);

        // First tag should reuse existing ID, second should get new ID
        expect(result.media.userData.tags, hasLength(2));
        expect(result.media.userData.tags[0].id, existingTagId);
        expect(result.media.userData.tags[0].name, 'Existing Tag');
        expect(result.media.userData.tags[1].id, isNot(-1));
        expect(result.media.userData.tags[1].id, isNot(existingTagId));
        expect(result.media.userData.tags[1].name, 'Another New Tag');

        // Verify both tags exist in database
        final dbTags = await database.select(database.tags).get();
        expect(dbTags, hasLength(2));
        expect(dbTags.map((t) => t.name), containsAll(['Existing Tag', 'Another New Tag']));
      });

      test('handles empty tag list', () async {
        // Create a game with tags
        final game = await repository.create(
          metadata: const MediaMetadata(title: 'Test Game'),
          userData: MediaUserData(
            status: MediaStatus.planned,
            tags: [
              domain.Tag(id: -1, name: 'Temp Tag'),
            ],
          ),
          gameMetadata: const GameMetadata(),
          gameUserData: const GameUserData(),
        );

        // Update with empty tags
        final updatedUserData = game.media.userData.copyWith(tags: []);
        final updatedMedia = game.media.copyWith(userData: updatedUserData);
        final updatedGame = game.copyWith(media: updatedMedia);

        final result = await service.update(updatedGame);

        expect(result.media.userData.tags, isEmpty);

        // The tag relationship is removed, but the tag record may still exist
        // or be deleted by cascade - we just verify the user data has no tags
        final mediaTags = await database.select(database.mediaTags).get();
        expect(mediaTags, isEmpty);
      });

      test('preserves tags with valid IDs', () async {
        // Create a tag in the database
        final tagId = await database.into(database.tags).insert(
          TagsCompanion.insert(name: 'Persistent Tag'),
        );

        // Create a game with the tag
        final game = await repository.create(
          metadata: const MediaMetadata(title: 'Test Game'),
          userData: MediaUserData(
            status: MediaStatus.planned,
            tags: [
              domain.Tag(id: tagId, name: 'Persistent Tag'),
            ],
          ),
          gameMetadata: const GameMetadata(),
          gameUserData: const GameUserData(),
        );

        // Update with the same tag (valid ID)
        final tags = [
          domain.Tag(id: tagId, name: 'Persistent Tag'),
        ];

        final updatedUserData = game.media.userData.copyWith(tags: tags);
        final updatedMedia = game.media.copyWith(userData: updatedUserData);
        final updatedGame = game.copyWith(media: updatedMedia);

        final result = await service.update(updatedGame);

        expect(result.media.userData.tags, hasLength(1));
        expect(result.media.userData.tags[0].id, tagId);
        expect(result.media.userData.tags[0].name, 'Persistent Tag');

        // Verify only one tag exists in database
        final dbTags = await database.select(database.tags).get();
        expect(dbTags, hasLength(1));
      });
    });

    group('update with developer and publisher resolution', () {
      late AppDatabase database;
      late FakeGameRepository repository;
      late GameService service;

      setUp(() {
        database = AppDatabase(
          NativeDatabase.memory(
            setup: (db) {
              db.execute('PRAGMA foreign_keys = ON');
            },
          ),
        );
        repository = FakeGameRepository();
        service = GameService(repository, database: database);
      });

      tearDown(() async {
        await database.close();
      });

      test('creates new person developer when updating with contributor containing personId', () async {
        // Create a game first
        final game = await repository.create(
          metadata: const MediaMetadata(title: 'Test Game'),
          userData: const MediaUserData(status: MediaStatus.planned),
          gameMetadata: const GameMetadata(),
          gameUserData: const GameUserData(),
        );

        // Create a person first
        final personId = await database.into(database.people).insert(
          PeopleCompanion.insert(name: 'Hideo Kojima'),
        );

        // Create a contributor with personId
        final contributor = domain.Contributor(
          id: -1,
          personId: personId,
          companyId: null,
        );

        final updatedGameMetadata = game.gameMetadata.copyWith(
          developers: [contributor],
        );

        final updatedGame = game.copyWith(
          gameMetadata: updatedGameMetadata,
        );

        final result = await service.update(updatedGame);

        // Should have one developer
        expect(result.gameMetadata.developers, hasLength(1));
        expect(result.gameMetadata.developers[0].personId, personId);
        expect(result.gameMetadata.developers[0].companyId, null);
        expect(result.gameMetadata.developers[0].id, isNot(-1));

        // Verify contributor was created
        final dbContributors = await database.select(database.contributors).get();
        expect(dbContributors, hasLength(1));
        expect(dbContributors[0].personId, personId);
        expect(dbContributors[0].companyId, null);
      });

      test('creates new company publisher when updating with contributor containing companyId', () async {
        // Create a game first
        final game = await repository.create(
          metadata: const MediaMetadata(title: 'Test Game'),
          userData: const MediaUserData(status: MediaStatus.planned),
          gameMetadata: const GameMetadata(),
          gameUserData: const GameUserData(),
        );

        // Create a company first
        final companyId = await database.into(database.companies).insert(
          CompaniesCompanion.insert(name: 'Nintendo'),
        );

        // Create a contributor with companyId
        final contributor = domain.Contributor(
          id: -1,
          personId: null,
          companyId: companyId,
        );

        final updatedGameMetadata = game.gameMetadata.copyWith(
          publishers: [contributor],
        );

        final updatedGame = game.copyWith(
          gameMetadata: updatedGameMetadata,
        );

        final result = await service.update(updatedGame);

        // Should have one publisher
        expect(result.gameMetadata.publishers, hasLength(1));
        expect(result.gameMetadata.publishers[0].companyId, companyId);
        expect(result.gameMetadata.publishers[0].personId, null);
        expect(result.gameMetadata.publishers[0].id, isNot(-1));

        // Verify contributor was created
        final dbContributors = await database.select(database.contributors).get();
        expect(dbContributors, hasLength(1));
        expect(dbContributors[0].companyId, companyId);
        expect(dbContributors[0].personId, null);
      });

      test('reuses existing contributor when updating with valid contributor ID', () async {
        // Create a person
        final personId = await database.into(database.people).insert(
          PeopleCompanion.insert(name: 'Hideo Kojima'),
        );

        // Create a contributor
        final contributorId = await database.into(database.contributors).insert(
          ContributorsCompanion.insert(
            personId: Value(personId),
          ),
        );

        // Create a game with the contributor
        final game = await repository.create(
          metadata: const MediaMetadata(title: 'Test Game'),
          userData: const MediaUserData(status: MediaStatus.planned),
          gameMetadata: GameMetadata(
            developers: [
              domain.Contributor(
                id: contributorId,
                personId: personId,
                companyId: null,
              ),
            ],
          ),
          gameUserData: const GameUserData(),
        );

        // Update with the same contributor (valid ID)
        final updatedGameMetadata = game.gameMetadata.copyWith(
          developers: [
            domain.Contributor(
              id: contributorId,
              personId: personId,
              companyId: null,
            ),
          ],
        );

        final updatedGame = game.copyWith(
          gameMetadata: updatedGameMetadata,
        );

        final result = await service.update(updatedGame);

        // Should have one developer with the same ID
        expect(result.gameMetadata.developers, hasLength(1));
        expect(result.gameMetadata.developers[0].id, contributorId);
        expect(result.gameMetadata.developers[0].personId, personId);

        // Verify only one contributor exists
        final dbContributors = await database.select(database.contributors).get();
        expect(dbContributors, hasLength(1));
      });

      test('handles contributors with only personId (valid)', () async {
        // Create a person
        final personId = await database.into(database.people).insert(
          PeopleCompanion.insert(name: 'Test Person'),
        );

        // Create a game
        final game = await repository.create(
          metadata: const MediaMetadata(title: 'Test Game'),
          userData: const MediaUserData(status: MediaStatus.planned),
          gameMetadata: const GameMetadata(),
          gameUserData: const GameUserData(),
        );

        // Update with a contributor that only has personId
        final contributor = domain.Contributor(
          id: -1,
          personId: personId,
          companyId: null,
        );

        final updatedGameMetadata = game.gameMetadata.copyWith(
          developers: [contributor],
        );

        final updatedGame = game.copyWith(
          gameMetadata: updatedGameMetadata,
        );

        final result = await service.update(updatedGame);

        // Should create a contributor with personId
        expect(result.gameMetadata.developers, hasLength(1));
        expect(result.gameMetadata.developers[0].personId, personId);
        expect(result.gameMetadata.developers[0].companyId, null);

        final contributors = await database.select(database.contributors).get();
        expect(contributors, hasLength(1));
        expect(contributors[0].personId, personId);
        expect(contributors[0].companyId, null);
      });

      test('handles contributors with only companyId (valid)', () async {
        // Create a company
        final companyId = await database.into(database.companies).insert(
          CompaniesCompanion.insert(name: 'Test Company'),
        );

        // Create a game
        final game = await repository.create(
          metadata: const MediaMetadata(title: 'Test Game'),
          userData: const MediaUserData(status: MediaStatus.planned),
          gameMetadata: const GameMetadata(),
          gameUserData: const GameUserData(),
        );

        // Update with a contributor that only has companyId
        final contributor = domain.Contributor(
          id: -1,
          personId: null,
          companyId: companyId,
        );

        final updatedGameMetadata = game.gameMetadata.copyWith(
          publishers: [contributor],
        );

        final updatedGame = game.copyWith(
          gameMetadata: updatedGameMetadata,
        );

        final result = await service.update(updatedGame);

        // Should create a contributor with companyId
        expect(result.gameMetadata.publishers, hasLength(1));
        expect(result.gameMetadata.publishers[0].companyId, companyId);
        expect(result.gameMetadata.publishers[0].personId, null);

        final contributors = await database.select(database.contributors).get();
        expect(contributors, hasLength(1));
        expect(contributors[0].companyId, companyId);
        expect(contributors[0].personId, null);
      });
    });
  });
}