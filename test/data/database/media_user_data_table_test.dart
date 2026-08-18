import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cybershelf/data/database/app_database.dart';
import 'package:cybershelf/domain/date_only.dart';
import 'package:cybershelf/domain/media_status.dart';
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

  group('MediaUserData', () {
    test('can store user data', () async {
      final mediaId = await database.into(database.media).insert(
        MediaCompanion.insert(
          mediaType: MediaType.game,
          createdAt: DateTime(2026, 8, 18),
          updatedAt: DateTime(2026, 8, 18),
        ),
      );

      final startedOn = DateOnly(
        year: 2026,
        month: 8,
        day: 1,
      );

      final finishedOn = DateOnly(
        year: 2026,
        month: 8,
        day: 18,
      );

      await database.into(database.mediaUserData).insert(
        MediaUserDataCompanion.insert(
          mediaId: Value(mediaId),
          status: MediaStatus.completed,
          rating: const Value(85),
          startedOn: Value(startedOn),
          finishedOn: Value(finishedOn),
          review: const Value('Great game.'),
          createdAt: DateTime(2026, 8, 18),
          updatedAt: DateTime(2026, 8, 18),
        ),
      );

      final userData = await (database.select(database.mediaUserData)
        ..where((m) => m.mediaId.equals(mediaId)))
          .getSingle();

      expect(userData.mediaId, mediaId);
      expect(userData.status, MediaStatus.completed);
      expect(userData.rating, 85);
      expect(userData.startedOn, startedOn);
      expect(userData.finishedOn, finishedOn);
      expect(userData.review, 'Great game.');
    });

    test('allows a null rating', () async {
      final mediaId = await database.into(database.media).insert(
        MediaCompanion.insert(
          mediaType: MediaType.game,
          createdAt: DateTime(2026, 8, 18),
          updatedAt: DateTime(2026, 8, 18),
        ),
      );

      await database.into(database.mediaUserData).insert(
        MediaUserDataCompanion.insert(
          mediaId: Value(mediaId),
          status: MediaStatus.planned,
          createdAt: DateTime(2026, 8, 18),
          updatedAt: DateTime(2026, 8, 18),
        ),
      );

      final userData = await (database.select(database.mediaUserData)
        ..where((m) => m.mediaId.equals(mediaId)))
          .getSingle();

      expect(userData.rating, null);
    });

    test('does not allow multiple user data records for one media', () async {
      final mediaId = await database.into(database.media).insert(
        MediaCompanion.insert(
          mediaType: MediaType.game,
          createdAt: DateTime(2026, 8, 18),
          updatedAt: DateTime(2026, 8, 18),
        ),
      );

      await database.into(database.mediaUserData).insert(
        MediaUserDataCompanion.insert(
          mediaId: Value(mediaId),
          status: MediaStatus.planned,
          createdAt: DateTime(2026, 8, 18),
          updatedAt: DateTime(2026, 8, 18),
        ),
      );

      expect(
            () => database.into(database.mediaUserData).insert(
          MediaUserDataCompanion.insert(
            mediaId: Value(mediaId),
            status: MediaStatus.completed,
            createdAt: DateTime(2026, 8, 18),
            updatedAt: DateTime(2026, 8, 18),
          ),
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('rejects a rating below 0', () async {
      final mediaId = await database.into(database.media).insert(
        MediaCompanion.insert(
          mediaType: MediaType.game,
          createdAt: DateTime(2026, 8, 18),
          updatedAt: DateTime(2026, 8, 18),
        ),
      );

      expect(
            () => database.into(database.mediaUserData).insert(
          MediaUserDataCompanion.insert(
            mediaId: Value(mediaId),
            status: MediaStatus.completed,
            rating: const Value(-1),
            createdAt: DateTime(2026, 8, 18),
            updatedAt: DateTime(2026, 8, 18),
          ),
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('rejects a rating above 100', () async {
      final mediaId = await database.into(database.media).insert(
        MediaCompanion.insert(
          mediaType: MediaType.game,
          createdAt: DateTime(2026, 8, 18),
          updatedAt: DateTime(2026, 8, 18),
        ),
      );

      expect(
            () => database.into(database.mediaUserData).insert(
          MediaUserDataCompanion.insert(
            mediaId: Value(mediaId),
            status: MediaStatus.completed,
            rating: const Value(101),
            createdAt: DateTime(2026, 8, 18),
            updatedAt: DateTime(2026, 8, 18),
          ),
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}