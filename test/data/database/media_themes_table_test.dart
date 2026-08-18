import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cybershelf/data/database/app_database.dart';
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

  Future<int> createMedia() {
    return database.into(database.media).insert(
      MediaCompanion.insert(
        mediaType: MediaType.game,
        createdAt: DateTime(2026, 8, 18),
        updatedAt: DateTime(2026, 8, 18),
      ),
    );
  }

  Future<int> createTheme(String name) {
    return database.into(database.themes).insert(
      ThemesCompanion.insert(
        name: name,
      ),
    );
  }

  group('MediaThemes', () {
    test('can associate media with a theme', () async {
      final mediaId = await createMedia();
      final themeId = await createTheme('Fantasy');

      await database.into(database.mediaThemes).insert(
        MediaThemesCompanion.insert(
          mediaId: mediaId,
          themeId: themeId,
        ),
      );

      final association =
      await (database.select(database.mediaThemes)
        ..where((mt) =>
        mt.mediaId.equals(mediaId) &
        mt.themeId.equals(themeId)))
          .getSingle();

      expect(association.mediaId, mediaId);
      expect(association.themeId, themeId);
    });

    test('allows one media item to have multiple themes', () async {
      final mediaId = await createMedia();
      final fantasyId = await createTheme('Fantasy');
      final horrorId = await createTheme('Horror');

      await database.into(database.mediaThemes).insert(
        MediaThemesCompanion.insert(
          mediaId: mediaId,
          themeId: fantasyId,
        ),
      );

      await database.into(database.mediaThemes).insert(
        MediaThemesCompanion.insert(
          mediaId: mediaId,
          themeId: horrorId,
        ),
      );

      final associations =
      await (database.select(database.mediaThemes)
        ..where((mt) => mt.mediaId.equals(mediaId)))
          .get();

      expect(associations.length, 2);
    });

    test('allows one theme to be associated with multiple media items', () async {
      final firstMediaId = await createMedia();
      final secondMediaId = await createMedia();
      final themeId = await createTheme('Fantasy');

      await database.into(database.mediaThemes).insert(
        MediaThemesCompanion.insert(
          mediaId: firstMediaId,
          themeId: themeId,
        ),
      );

      await database.into(database.mediaThemes).insert(
        MediaThemesCompanion.insert(
          mediaId: secondMediaId,
          themeId: themeId,
        ),
      );

      final associations =
      await (database.select(database.mediaThemes)
        ..where((mt) => mt.themeId.equals(themeId)))
          .get();

      expect(associations.length, 2);
    });

    test('does not allow duplicate media-theme associations', () async {
      final mediaId = await createMedia();
      final themeId = await createTheme('Fantasy');

      final association = MediaThemesCompanion.insert(
        mediaId: mediaId,
        themeId: themeId,
      );

      await database.into(database.mediaThemes).insert(association);

      expect(
            () => database.into(database.mediaThemes).insert(association),
        throwsA(isA<Exception>()),
      );
    });

    test('deleting media removes its theme associations', () async {
      final mediaId = await createMedia();
      final themeId = await createTheme('Fantasy');

      await database.into(database.mediaThemes).insert(
        MediaThemesCompanion.insert(
          mediaId: mediaId,
          themeId: themeId,
        ),
      );

      await (database.delete(database.media)
        ..where((m) => m.id.equals(mediaId)))
          .go();

      final associations =
      await (database.select(database.mediaThemes)
        ..where((mt) => mt.mediaId.equals(mediaId)))
          .get();

      expect(associations, isEmpty);
    });
  });
}