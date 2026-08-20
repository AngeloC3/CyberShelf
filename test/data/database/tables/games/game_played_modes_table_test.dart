import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cybershelf/data/database/app_database.dart';
import 'package:cybershelf/domain/game/game_mode.dart';
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

  group('GamePlayedModes', () {
    test('can record a mode played for a game', () async {
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

      await database.into(database.gamePlayedModes).insert(
        GamePlayedModesCompanion.insert(
          mediaId: mediaId,
          mode: GameMode.singlePlayer,
        ),
      );

      final playedMode = await (database.select(database.gamePlayedModes)
        ..where((m) => m.mediaId.equals(mediaId)))
          .getSingle();

      expect(playedMode.mediaId, mediaId);
      expect(playedMode.mode, GameMode.singlePlayer);
    });

    test('allows multiple played modes for the same game', () async {
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

      await database.into(database.gamePlayedModes).insert(
        GamePlayedModesCompanion.insert(
          mediaId: mediaId,
          mode: GameMode.singlePlayer,
        ),
      );

      await database.into(database.gamePlayedModes).insert(
        GamePlayedModesCompanion.insert(
          mediaId: mediaId,
          mode: GameMode.multiplayer,
        ),
      );

      final modes = await (database.select(database.gamePlayedModes)
        ..where((m) => m.mediaId.equals(mediaId)))
          .get();

      expect(modes, hasLength(2));
      expect(
        modes.map((m) => m.mode),
        containsAll([GameMode.singlePlayer, GameMode.multiplayer]),
      );
    });

    test('does not allow duplicate played modes for the same game',
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

          await database.into(database.gamePlayedModes).insert(
            GamePlayedModesCompanion.insert(
              mediaId: mediaId,
              mode: GameMode.multiplayer,
            ),
          );

          expect(
                () => database.into(database.gamePlayedModes).insert(
              GamePlayedModesCompanion.insert(
                mediaId: mediaId,
                mode: GameMode.multiplayer,
              ),
            ),
            throwsA(isA<Exception>()),
          );
        });

    test('does not allow a played mode for a nonexistent game', () async {
      expect(
            () => database.into(database.gamePlayedModes).insert(
          GamePlayedModesCompanion.insert(
            mediaId: 999,
            mode: GameMode.singlePlayer,
          ),
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('deleting a game deletes its played modes', () async {
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

      await database.into(database.gamePlayedModes).insert(
        GamePlayedModesCompanion.insert(
          mediaId: mediaId,
          mode: GameMode.singlePlayer,
        ),
      );

      await (database.delete(database.media)
        ..where((m) => m.id.equals(mediaId)))
          .go();

      final modes = await (database.select(database.gamePlayedModes)
        ..where((m) => m.mediaId.equals(mediaId)))
          .get();

      expect(modes, isEmpty);
    });
  });
}