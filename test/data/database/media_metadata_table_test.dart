import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cybershelf/data/database/app_database.dart';
import 'package:cybershelf/domain/date_only.dart';
import 'package:cybershelf/domain/media_type.dart';

import 'test_database.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = createTestDatabase();
  });

  tearDown(() async {
    await database.close();
  });

  group('MediaMetadata', () {
    test('can be associated with media', () async {
      final mediaId = await database.into(database.media).insert(
        MediaCompanion.insert(
          mediaType: MediaType.game,
          createdAt: DateTime(2026, 8, 18),
          updatedAt: DateTime(2026, 8, 18),
        ),
      );

      final releaseDate = DateOnly(
        year: 2026,
        month: 8,
        day: 18,
      );

      await database.into(database.mediaMetadata).insert(
        MediaMetadataCompanion.insert(
          mediaId: Value(mediaId),
          title: 'Test Game',
          releaseDate: Value(releaseDate),
          updatedAt: DateTime(2026, 8, 18),
        ),
      );

      final metadata = await (database.select(database.mediaMetadata)
        ..where((m) => m.mediaId.equals(mediaId)))
          .getSingle();

      expect(metadata.mediaId, mediaId);
      expect(metadata.title, 'Test Game');
      expect(metadata.releaseDate, releaseDate);
    });

    test('does not allow multiple metadata records for one media', () async {
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
          title: 'First Title',
          updatedAt: DateTime(2026, 8, 18),
        ),
      );

      expect(
            () => database.into(database.mediaMetadata).insert(
          MediaMetadataCompanion.insert(
            mediaId: Value(mediaId),
            title: 'Second Title',
            updatedAt: DateTime(2026, 8, 18),
          ),
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}