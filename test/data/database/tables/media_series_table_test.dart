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

  Future<int> createMedia() {
    return database.into(database.media).insert(
      MediaCompanion.insert(
        mediaType: MediaType.game,
        createdAt: DateTime(2026, 8, 18),
        updatedAt: DateTime(2026, 8, 18),
      ),
    );
  }

  Future<int> createSeries(String name) {
    return database.into(database.series).insert(
      SeriesCompanion.insert(
        name: name,
      ),
    );
  }

  group('MediaSeries', () {
    test('can associate media with a series', () async {
      final mediaId = await createMedia();
      final seriesId = await createSeries('Half-Life Series');

      await database.into(database.mediaSeries).insert(
        MediaSeriesCompanion.insert(
          mediaId: mediaId,
          seriesId: seriesId,
        ),
      );

      final association = await (database.select(database.mediaSeries)
        ..where((ms) => ms.mediaId.equals(mediaId) & ms.seriesId.equals(seriesId)))
          .getSingle();

      expect(association.mediaId, mediaId);
      expect(association.seriesId, seriesId);
    });

    test('allows one media item to have multiple series', () async {
      final mediaId = await createMedia();
      final series1Id = await createSeries('Half-Life Series');
      final series2Id = await createSeries('Portal Series');

      await database.into(database.mediaSeries).insert(
        MediaSeriesCompanion.insert(
          mediaId: mediaId,
          seriesId: series1Id,
        ),
      );

      await database.into(database.mediaSeries).insert(
        MediaSeriesCompanion.insert(
          mediaId: mediaId,
          seriesId: series2Id,
        ),
      );

      final associations = await (database.select(database.mediaSeries)
        ..where((ms) => ms.mediaId.equals(mediaId)))
          .get();

      expect(associations, hasLength(2));
      expect(associations.map((ms) => ms.seriesId), containsAll([series1Id, series2Id]));
    });

    test('allows one series to be associated with multiple media items', () async {
      final firstMediaId = await createMedia();
      final secondMediaId = await createMedia();
      final seriesId = await createSeries('Half-Life Series');

      await database.into(database.mediaSeries).insert(
        MediaSeriesCompanion.insert(
          mediaId: firstMediaId,
          seriesId: seriesId,
        ),
      );

      await database.into(database.mediaSeries).insert(
        MediaSeriesCompanion.insert(
          mediaId: secondMediaId,
          seriesId: seriesId,
        ),
      );

      final associations = await (database.select(database.mediaSeries)
        ..where((ms) => ms.seriesId.equals(seriesId)))
          .get();

      expect(associations, hasLength(2));
      expect(associations.map((ms) => ms.mediaId), containsAll([firstMediaId, secondMediaId]));
    });

    test('does not allow duplicate media-series associations', () async {
      final mediaId = await createMedia();
      final seriesId = await createSeries('Half-Life Series');

      final association = MediaSeriesCompanion.insert(
        mediaId: mediaId,
        seriesId: seriesId,
      );

      await database.into(database.mediaSeries).insert(association);

      expect(
            () => database.into(database.mediaSeries).insert(association),
        throwsA(isA<Exception>()),
      );
    });

    test('requires an existing media record', () async {
      final seriesId = await createSeries('Half-Life Series');

      expect(
            () => database.into(database.mediaSeries).insert(
          MediaSeriesCompanion.insert(
            mediaId: 999,
            seriesId: seriesId,
          ),
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('requires an existing series record', () async {
      final mediaId = await createMedia();

      expect(
            () => database.into(database.mediaSeries).insert(
          MediaSeriesCompanion.insert(
            mediaId: mediaId,
            seriesId: 999,
          ),
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('deleting media removes its series associations', () async {
      final mediaId = await createMedia();
      final seriesId = await createSeries('Half-Life Series');

      await database.into(database.mediaSeries).insert(
        MediaSeriesCompanion.insert(
          mediaId: mediaId,
          seriesId: seriesId,
        ),
      );

      await (database.delete(database.media)
        ..where((m) => m.id.equals(mediaId)))
          .go();

      final associations = await (database.select(database.mediaSeries)
        ..where((ms) => ms.mediaId.equals(mediaId)))
          .get();

      expect(associations, isEmpty);

      // Series record should still exist
      final series = await (database.select(database.series)
        ..where((s) => s.id.equals(seriesId)))
          .getSingle();

      expect(series.name, 'Half-Life Series');
    });

    test('deleting series removes its media associations', () async {
      final mediaId = await createMedia();
      final seriesId = await createSeries('Half-Life Series');

      await database.into(database.mediaSeries).insert(
        MediaSeriesCompanion.insert(
          mediaId: mediaId,
          seriesId: seriesId,
        ),
      );

      await (database.delete(database.series)
        ..where((s) => s.id.equals(seriesId)))
          .go();

      final associations = await (database.select(database.mediaSeries)
        ..where((ms) => ms.seriesId.equals(seriesId)))
          .get();

      expect(associations, isEmpty);

      // Media record should still exist
      final media = await (database.select(database.media)
        ..where((m) => m.id.equals(mediaId)))
          .getSingle();

      expect(media.id, mediaId);
    });
  });
}