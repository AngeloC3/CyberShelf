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

  group('MediaTags', () {
    test('can assign a tag to media', () async {
      final mediaId = await database.into(database.media).insert(
        MediaCompanion.insert(
          mediaType: MediaType.game,
          createdAt: DateTime(2026, 8, 18),
          updatedAt: DateTime(2026, 8, 18),
        ),
      );

      final tagId = await database.into(database.tags).insert(
        TagsCompanion.insert(
          name: 'Favorite',
        ),
      );

      await database.into(database.mediaTags).insert(
        MediaTagsCompanion.insert(
          mediaId: mediaId,
          tagId: tagId,
        ),
      );

      final mediaTag = await (database.select(database.mediaTags)
        ..where((mt) => mt.mediaId.equals(mediaId)))
          .getSingle();

      expect(mediaTag.mediaId, mediaId);
      expect(mediaTag.tagId, tagId);
    });

    test('does not allow duplicate media-tag assignments', () async {
      final mediaId = await database.into(database.media).insert(
        MediaCompanion.insert(
          mediaType: MediaType.game,
          createdAt: DateTime(2026, 8, 18),
          updatedAt: DateTime(2026, 8, 18),
        ),
      );

      final tagId = await database.into(database.tags).insert(
        TagsCompanion.insert(
          name: 'Favorite',
        ),
      );

      await database.into(database.mediaTags).insert(
        MediaTagsCompanion.insert(
          mediaId: mediaId,
          tagId: tagId,
        ),
      );

      expect(
            () => database.into(database.mediaTags).insert(
          MediaTagsCompanion.insert(
            mediaId: mediaId,
            tagId: tagId,
          ),
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('allows the same tag to be assigned to multiple media items', () async {
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

      final tagId = await database.into(database.tags).insert(
        TagsCompanion.insert(
          name: 'Favorite',
        ),
      );

      await database.into(database.mediaTags).insert(
        MediaTagsCompanion.insert(
          mediaId: firstMediaId,
          tagId: tagId,
        ),
      );

      await database.into(database.mediaTags).insert(
        MediaTagsCompanion.insert(
          mediaId: secondMediaId,
          tagId: tagId,
        ),
      );

      final assignments = await (database.select(database.mediaTags)
        ..where((mt) => mt.tagId.equals(tagId)))
          .get();

      expect(assignments, hasLength(2));
    });

    test('deleting media deletes its tag assignments', () async {
      final mediaId = await database.into(database.media).insert(
        MediaCompanion.insert(
          mediaType: MediaType.game,
          createdAt: DateTime(2026, 8, 18),
          updatedAt: DateTime(2026, 8, 18),
        ),
      );

      final tagId = await database.into(database.tags).insert(
        TagsCompanion.insert(
          name: 'Favorite',
        ),
      );

      await database.into(database.mediaTags).insert(
        MediaTagsCompanion.insert(
          mediaId: mediaId,
          tagId: tagId,
        ),
      );

      await (database.delete(database.media)
        ..where((m) => m.id.equals(mediaId)))
          .go();

      final assignments = await (database.select(database.mediaTags)
        ..where((mt) => mt.mediaId.equals(mediaId)))
          .get();

      expect(assignments, isEmpty);

      final tag = await (database.select(database.tags)
        ..where((t) => t.id.equals(tagId)))
          .getSingle();

      expect(tag.name, 'Favorite');
    });

    test('deleting a tag deletes its media assignments', () async {
      final mediaId = await database.into(database.media).insert(
        MediaCompanion.insert(
          mediaType: MediaType.game,
          createdAt: DateTime(2026, 8, 18),
          updatedAt: DateTime(2026, 8, 18),
        ),
      );

      final tagId = await database.into(database.tags).insert(
        TagsCompanion.insert(
          name: 'Favorite',
        ),
      );

      await database.into(database.mediaTags).insert(
        MediaTagsCompanion.insert(
          mediaId: mediaId,
          tagId: tagId,
        ),
      );

      await (database.delete(database.tags)
        ..where((t) => t.id.equals(tagId)))
          .go();

      final assignments = await (database.select(database.mediaTags)
        ..where((mt) => mt.tagId.equals(tagId)))
          .get();

      expect(assignments, isEmpty);

      final media = await (database.select(database.media)
        ..where((m) => m.id.equals(mediaId)))
          .getSingle();

      expect(media.id, mediaId);
    });

    test('requires an existing media record', () async {
      final tagId = await database.into(database.tags).insert(
        TagsCompanion.insert(
          name: 'Favorite',
        ),
      );

      expect(
            () => database.into(database.mediaTags).insert(
          MediaTagsCompanion.insert(
            mediaId: 999,
            tagId: tagId,
          ),
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('requires an existing tag record', () async {
      final mediaId = await database.into(database.media).insert(
        MediaCompanion.insert(
          mediaType: MediaType.game,
          createdAt: DateTime(2026, 8, 18),
          updatedAt: DateTime(2026, 8, 18),
        ),
      );

      expect(
            () => database.into(database.mediaTags).insert(
          MediaTagsCompanion.insert(
            mediaId: mediaId,
            tagId: 999,
          ),
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}