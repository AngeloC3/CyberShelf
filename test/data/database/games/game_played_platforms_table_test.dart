import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cybershelf/data/database/app_database.dart';
import 'package:cybershelf/domain/media_type.dart';

import '../test_database.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = createTestDatabase();
  });

  tearDown(() async {
    await database.close();
  });

  group('GamePlayedPlatforms', () {
    test('can record a platform played for a game', () async {
      final mediaId = await database.into(database.media).insert(
        MediaCompanion.insert(
          mediaType: MediaType.game,
          createdAt: DateTime(2026, 8, 18),
          updatedAt: DateTime(2026, 8, 18),
        ),
      );

      await database.into(database.games).insert(
        GamesCompanion.insert(
          mediaId: Value(mediaId),
        ),
      );

      await database.into(database.gamePlayedPlatforms).insert(
        GamePlayedPlatformsCompanion.insert(
          mediaId: mediaId,
          platform: 'pc',
        ),
      );

      final platform = await (database.select(database.gamePlayedPlatforms)
        ..where((p) => p.mediaId.equals(mediaId)))
          .getSingle();

      expect(platform.mediaId, mediaId);
      expect(platform.platform, 'pc');
    });

    test('allows multiple played platforms for the same game', () async {
      final mediaId = await database.into(database.media).insert(
        MediaCompanion.insert(
          mediaType: MediaType.game,
          createdAt: DateTime(2026, 8, 18),
          updatedAt: DateTime(2026, 8, 18),
        ),
      );

      await database.into(database.games).insert(
        GamesCompanion.insert(
          mediaId: Value(mediaId),
        ),
      );

      await database.into(database.gamePlayedPlatforms).insert(
        GamePlayedPlatformsCompanion.insert(
          mediaId: mediaId,
          platform: 'pc',
        ),
      );

      await database.into(database.gamePlayedPlatforms).insert(
        GamePlayedPlatformsCompanion.insert(
          mediaId: mediaId,
          platform: 'switch',
        ),
      );

      final platforms = await (database.select(database.gamePlayedPlatforms)
        ..where((p) => p.mediaId.equals(mediaId)))
          .get();

      expect(platforms, hasLength(2));
      expect(
        platforms.map((p) => p.platform),
        containsAll(['pc', 'switch']),
      );
    });

    test('does not allow duplicate played platforms for the same game',
            () async {
          final mediaId = await database.into(database.media).insert(
            MediaCompanion.insert(
              mediaType: MediaType.game,
              createdAt: DateTime(2026, 8, 18),
              updatedAt: DateTime(2026, 8, 18),
            ),
          );

          await database.into(database.games).insert(
            GamesCompanion.insert(
              mediaId: Value(mediaId),
            ),
          );

          await database.into(database.gamePlayedPlatforms).insert(
            GamePlayedPlatformsCompanion.insert(
              mediaId: mediaId,
              platform: 'pc',
            ),
          );

          expect(
                () => database.into(database.gamePlayedPlatforms).insert(
              GamePlayedPlatformsCompanion.insert(
                mediaId: mediaId,
                platform: 'pc',
              ),
            ),
            throwsA(isA<Exception>()),
          );
        });

    test('does not allow a played platform for a nonexistent game',
            () async {
          expect(
                () => database.into(database.gamePlayedPlatforms).insert(
              GamePlayedPlatformsCompanion.insert(
                mediaId: 999,
                platform: 'pc',
              ),
            ),
            throwsA(isA<Exception>()),
          );
        });

    test('deleting a game deletes its played platforms', () async {
      final mediaId = await database.into(database.media).insert(
        MediaCompanion.insert(
          mediaType: MediaType.game,
          createdAt: DateTime(2026, 8, 18),
          updatedAt: DateTime(2026, 8, 18),
        ),
      );

      await database.into(database.games).insert(
        GamesCompanion.insert(
          mediaId: Value(mediaId),
        ),
      );

      await database.into(database.gamePlayedPlatforms).insert(
        GamePlayedPlatformsCompanion.insert(
          mediaId: mediaId,
          platform: 'pc',
        ),
      );

      await (database.delete(database.media)
        ..where((m) => m.id.equals(mediaId)))
          .go();

      final platforms = await (database.select(database.gamePlayedPlatforms)
        ..where((p) => p.mediaId.equals(mediaId)))
          .get();

      expect(platforms, isEmpty);
    });
  });
}