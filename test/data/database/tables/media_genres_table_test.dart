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

  group('MediaGenres', () {
    test('can associate media with a genre', () async {
      final mediaId = await database.into(database.media).insert(
        MediaCompanion.insert(
          mediaType: MediaType.game,
          createdAt: DateTime(2026, 8, 18),
          updatedAt: DateTime(2026, 8, 18),
        ),
      );

      final genreId = await database.into(database.genres).insert(
        GenresCompanion.insert(
          name: 'RPG',
        ),
      );

      await database.into(database.mediaGenres).insert(
        MediaGenresCompanion.insert(
          mediaId: mediaId,
          genreId: genreId,
        ),
      );

      final relationship = await (database.select(database.mediaGenres)
            ..where((mg) =>
                mg.mediaId.equals(mediaId) & mg.genreId.equals(genreId)))
          .getSingle();

      expect(relationship.mediaId, mediaId);
      expect(relationship.genreId, genreId);
    });

    test('does not allow duplicate media-genre relationships', () async {
      final mediaId = await database.into(database.media).insert(
        MediaCompanion.insert(
          mediaType: MediaType.game,
          createdAt: DateTime(2026, 8, 18),
          updatedAt: DateTime(2026, 8, 18),
        ),
      );

      final genreId = await database.into(database.genres).insert(
        GenresCompanion.insert(
          name: 'RPG',
        ),
      );

      final relationship = MediaGenresCompanion.insert(
        mediaId: mediaId,
        genreId: genreId,
      );

      await database.into(database.mediaGenres).insert(relationship);

      expect(
        () => database.into(database.mediaGenres).insert(relationship),
        throwsA(isA<Exception>()),
      );
    });

    test('requires an existing media record', () async {
      final genreId = await database.into(database.genres).insert(
        GenresCompanion.insert(
          name: 'RPG',
        ),
      );

      expect(
        () => database.into(database.mediaGenres).insert(
          MediaGenresCompanion.insert(
            mediaId: 999,
            genreId: genreId,
          ),
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('requires an existing genre record', () async {
      final mediaId = await database.into(database.media).insert(
        MediaCompanion.insert(
          mediaType: MediaType.game,
          createdAt: DateTime(2026, 8, 18),
          updatedAt: DateTime(2026, 8, 18),
        ),
      );

      expect(
        () => database.into(database.mediaGenres).insert(
          MediaGenresCompanion.insert(
            mediaId: mediaId,
            genreId: 999,
          ),
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('deleting media removes its genre relationships', () async {
      final mediaId = await database.into(database.media).insert(
        MediaCompanion.insert(
          mediaType: MediaType.game,
          createdAt: DateTime(2026, 8, 18),
          updatedAt: DateTime(2026, 8, 18),
        ),
      );

      final genreId = await database.into(database.genres).insert(
        GenresCompanion.insert(
          name: 'RPG',
        ),
      );

      await database.into(database.mediaGenres).insert(
        MediaGenresCompanion.insert(
          mediaId: mediaId,
          genreId: genreId,
        ),
      );

      await (database.delete(database.media)
            ..where((m) => m.id.equals(mediaId)))
          .go();

      final relationships = await (database.select(database.mediaGenres)
            ..where((mg) => mg.mediaId.equals(mediaId)))
          .get();

      expect(relationships, isEmpty);

      final genre = await (database.select(database.genres)
            ..where((g) => g.id.equals(genreId)))
          .getSingle();

      expect(genre.name, 'RPG');
    });

    test('deleting genre removes its media relationships', () async {
      final mediaId = await database.into(database.media).insert(
        MediaCompanion.insert(
          mediaType: MediaType.game,
          createdAt: DateTime(2026, 8, 18),
          updatedAt: DateTime(2026, 8, 18),
        ),
      );

      final genreId = await database.into(database.genres).insert(
        GenresCompanion.insert(
          name: 'RPG',
        ),
      );

      await database.into(database.mediaGenres).insert(
        MediaGenresCompanion.insert(
          mediaId: mediaId,
          genreId: genreId,
        ),
      );

      await (database.delete(database.genres)
            ..where((g) => g.id.equals(genreId)))
          .go();

      final relationships = await (database.select(database.mediaGenres)
            ..where((mg) => mg.genreId.equals(genreId)))
          .get();

      expect(relationships, isEmpty);

      final media = await (database.select(database.media)
            ..where((m) => m.id.equals(mediaId)))
          .getSingle();

      expect(media.id, mediaId);
    });
  });
}
