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

  group('ExternalIds', () {
    test('can insert and read an external ID', () async {
      final mediaId = await database.into(database.media).insert(
        MediaCompanion.insert(
          mediaType: MediaType.game,
          createdAt: DateTime(2026, 8, 18),
          updatedAt: DateTime(2026, 8, 18),
        ),
      );

      await database.into(database.externalIds).insert(
        ExternalIdsCompanion.insert(
          mediaId: mediaId,
          source: 'igdb',
          externalId: '123456',
        ),
      );

      final externalId = await (database.select(database.externalIds)
        ..where((e) => e.mediaId.equals(mediaId)))
          .getSingle();

      expect(externalId.mediaId, mediaId);
      expect(externalId.source, 'igdb');
      expect(externalId.externalId, '123456');
    });

    test('does not allow two external IDs for the same media and source',
            () async {
          final mediaId = await database.into(database.media).insert(
            MediaCompanion.insert(
              mediaType: MediaType.game,
              createdAt: DateTime(2026, 8, 18),
              updatedAt: DateTime(2026, 8, 18),
            ),
          );

          await database.into(database.externalIds).insert(
            ExternalIdsCompanion.insert(
              mediaId: mediaId,
              source: 'igdb',
              externalId: '123456',
            ),
          );

          expect(
                () => database.into(database.externalIds).insert(
              ExternalIdsCompanion.insert(
                mediaId: mediaId,
                source: 'igdb',
                externalId: '999999',
              ),
            ),
            throwsA(isA<Exception>()),
          );
        });

    test('does not allow the same external ID for the same source on two media items',
            () async {
          final firstMediaId = await database.into(database.media).insert(
            MediaCompanion.insert(
              mediaType: MediaType.game,
              createdAt: DateTime(2026, 8, 18),
              updatedAt: DateTime(2026, 8, 18),
            ),
          );

          final secondMediaId = await database.into(database.media).insert(
            MediaCompanion.insert(
              mediaType: MediaType.game,
              createdAt: DateTime(2026, 8, 18),
              updatedAt: DateTime(2026, 8, 18),
            ),
          );

          await database.into(database.externalIds).insert(
            ExternalIdsCompanion.insert(
              mediaId: firstMediaId,
              source: 'igdb',
              externalId: '123456',
            ),
          );

          expect(
                () => database.into(database.externalIds).insert(
              ExternalIdsCompanion.insert(
                mediaId: secondMediaId,
                source: 'igdb',
                externalId: '123456',
              ),
            ),
            throwsA(isA<Exception>()),
          );
        });

    test('allows the same external ID from different sources', () async {
      final mediaId = await database.into(database.media).insert(
        MediaCompanion.insert(
          mediaType: MediaType.game,
          createdAt: DateTime(2026, 8, 18),
          updatedAt: DateTime(2026, 8, 18),
        ),
      );

      await database.into(database.externalIds).insert(
        ExternalIdsCompanion.insert(
          mediaId: mediaId,
          source: 'igdb',
          externalId: '123456',
        ),
      );

      await database.into(database.externalIds).insert(
        ExternalIdsCompanion.insert(
          mediaId: mediaId,
          source: 'tmdb',
          externalId: '123456',
        ),
      );

      final externalIds = await (database.select(database.externalIds)
        ..where((e) => e.mediaId.equals(mediaId)))
          .get();

      expect(externalIds, hasLength(2));
    });

    test('deleting media deletes its external IDs', () async {
      final mediaId = await database.into(database.media).insert(
        MediaCompanion.insert(
          mediaType: MediaType.game,
          createdAt: DateTime(2026, 8, 18),
          updatedAt: DateTime(2026, 8, 18),
        ),
      );

      await database.into(database.externalIds).insert(
        ExternalIdsCompanion.insert(
          mediaId: mediaId,
          source: 'igdb',
          externalId: '123456',
        ),
      );

      await (database.delete(database.media)
        ..where((m) => m.id.equals(mediaId)))
          .go();

      final externalIds = await (database.select(database.externalIds)
        ..where((e) => e.mediaId.equals(mediaId)))
          .get();

      expect(externalIds, isEmpty);
    });

    test('requires an existing media record', () async {
      expect(
            () => database.into(database.externalIds).insert(
          ExternalIdsCompanion.insert(
            mediaId: 999,
            source: 'igdb',
            externalId: '123456',
          ),
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}