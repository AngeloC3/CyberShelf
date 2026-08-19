import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cybershelf/data/database/app_database.dart';
import 'package:cybershelf/domain/game/game_mode.dart';
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

  group('GameAvailableModes', () {
    test('can add an available mode to a game', () async {
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

      await database.into(database.gameAvailableModes).insert(
        GameAvailableModesCompanion.insert(
          mediaId: mediaId,
          mode: GameMode.singlePlayer,
        ),
      );

      final mode = await (database.select(database.gameAvailableModes)
        ..where((m) => m.mediaId.equals(mediaId)))
          .getSingle();

      expect(mode.mediaId, mediaId);
      expect(mode.mode, GameMode.singlePlayer);
    });

    test('allows multiple available modes for the same game', () async {
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

      await database.into(database.gameAvailableModes).insert(
        GameAvailableModesCompanion.insert(
          mediaId: mediaId,
          mode: GameMode.singlePlayer,
        ),
      );

      await database.into(database.gameAvailableModes).insert(
        GameAvailableModesCompanion.insert(
          mediaId: mediaId,
          mode: GameMode.multiplayer,
        ),
      );

      final modes = await (database.select(database.gameAvailableModes)
        ..where((m) => m.mediaId.equals(mediaId)))
          .get();

      expect(modes, hasLength(2));
      expect(
        modes.map((m) => m.mode),
        containsAll([GameMode.singlePlayer, GameMode.multiplayer]),
      );
    });

    test('does not allow duplicate available modes for the same game',
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

          await database.into(database.gameAvailableModes).insert(
            GameAvailableModesCompanion.insert(
              mediaId: mediaId,
              mode: GameMode.multiplayer,
            ),
          );

          expect(
                () => database.into(database.gameAvailableModes).insert(
              GameAvailableModesCompanion.insert(
                mediaId: mediaId,
                mode: GameMode.multiplayer,
              ),
            ),
            throwsA(isA<Exception>()),
          );
        });

    test('does not allow an available mode for a nonexistent game',
            () async {
          expect(
                () => database.into(database.gameAvailableModes).insert(
              GameAvailableModesCompanion.insert(
                mediaId: 999,
                mode: GameMode.singlePlayer,
              ),
            ),
            throwsA(isA<Exception>()),
          );
        });

    test('deleting a game deletes its available modes', () async {
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

      await database.into(database.gameAvailableModes).insert(
        GameAvailableModesCompanion.insert(
          mediaId: mediaId,
          mode: GameMode.singlePlayer,
        ),
      );

      await (database.delete(database.media)
        ..where((m) => m.id.equals(mediaId)))
          .go();

      final modes = await (database.select(database.gameAvailableModes)
        ..where((m) => m.mediaId.equals(mediaId)))
          .get();

      expect(modes, isEmpty);
    });
  });
}