import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cybershelf/data/database/app_database.dart';
import 'package:cybershelf/domain/media_type.dart';

import '../../test_database.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = createTestDatabase();
  });

  tearDown(() async {
    await database.close();
  });

  group('Games', () {
    test('can create a game for existing media', () async {
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

      final game = await (database.select(database.games)
        ..where((g) => g.mediaId.equals(mediaId)))
          .getSingle();

      expect(game.mediaId, mediaId);
    });

    test('does not allow the same media to be registered as a game twice',
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

          expect(
                () => database.into(database.games).insert(
              GamesCompanion.insert(
                mediaId: Value(mediaId),
              ),
            ),
            throwsA(isA<Exception>()),
          );
        });

    test('does not allow a game without existing media', () async {
      expect(
            () => database.into(database.games).insert(
          GamesCompanion.insert(
            mediaId: const Value(999),
          ),
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('deleting media deletes its game subtype row', () async {
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

      await (database.delete(database.media)
        ..where((m) => m.id.equals(mediaId)))
          .go();

      final games = await (database.select(database.games)
        ..where((g) => g.mediaId.equals(mediaId)))
          .get();

      expect(games, isEmpty);
    });
  });
}