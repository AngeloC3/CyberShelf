import 'package:flutter_test/flutter_test.dart';
import 'package:cybershelf/data/database/app_database.dart';
import 'package:cybershelf/data/repositories/drift_media_repository.dart';
import 'package:cybershelf/domain/date_only.dart';
import 'package:cybershelf/domain/media/media_metadata.dart';
import 'package:cybershelf/domain/media/media_user_data.dart';
import 'package:cybershelf/domain/media/external_id.dart' as domain;
import 'package:cybershelf/domain/media/genre.dart' as domain;
import 'package:cybershelf/domain/media/tag.dart' as domain;
import 'package:cybershelf/domain/media/theme.dart' as domain;
import 'package:cybershelf/domain/media_status.dart';
import 'package:cybershelf/domain/media_type.dart';

void main() {
  late AppDatabase database;
  late DriftMediaRepository repository;

  setUp(() {
    database = AppDatabase.forTesting();
    repository = DriftMediaRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('create inserts the complete media aggregate', () async {
    final media = await repository.create(
      type: MediaType.game,
      metadata: const MediaMetadata(
        title: 'Test Game',
        description: 'A test description.',
        coverUrl: 'cover.jpg',
      ),
      userData: const MediaUserData(
        status: MediaStatus.planned,
      ),
    );

    expect(media.id, 1);
    expect(media.type, MediaType.game);
    expect(media.metadata.title, 'Test Game');
    expect(media.metadata.description, 'A test description.');
    expect(media.metadata.coverUrl, 'cover.jpg');
    expect(media.userData.status, MediaStatus.planned);

    final storedMedia = await database.select(database.media).get();
    final storedMetadata =
    await database.select(database.mediaMetadata).get();
    final storedUserData =
    await database.select(database.mediaUserData).get();

    expect(storedMedia, hasLength(1));
    expect(storedMetadata, hasLength(1));
    expect(storedUserData, hasLength(1));

    expect(storedMedia.single.id, media.id);
    expect(storedMetadata.single.mediaId, media.id);
    expect(storedUserData.single.mediaId, media.id);
  });

  test('create preserves metadata and user data values', () async {
    final releaseDate = DateOnly(
      year: 2025,
      month: 11,
      day: 11,
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

    final media = await repository.create(
      type: MediaType.game,
      metadata: MediaMetadata(
        title: 'Test Game',
        description: 'A description.',
        coverUrl: 'cover.jpg',
        releaseDate: releaseDate,
      ),
      userData: MediaUserData(
        status: MediaStatus.completed,
        rating: 92,
        startedOn: startedOn,
        finishedOn: finishedOn,
        review: 'Really enjoyed it.',
      ),
    );

    expect(media.metadata.releaseDate, releaseDate);
    expect(media.userData.rating, 92);
    expect(media.userData.startedOn, startedOn);
    expect(media.userData.finishedOn, finishedOn);
    expect(media.userData.review, 'Really enjoyed it.');

    final storedMetadata =
    await database.select(database.mediaMetadata).getSingle();
    final storedUserData =
    await database.select(database.mediaUserData).getSingle();

    expect(storedMetadata.releaseDate, releaseDate);
    expect(storedUserData.rating, 92);
    expect(storedUserData.startedOn, startedOn);
    expect(storedUserData.finishedOn, finishedOn);
    expect(storedUserData.review, 'Really enjoyed it.');
  });

  test('create stores and returns genres and themes', () async {
    await database.into(database.genres).insert(
      GenresCompanion.insert(
        name: 'RPG',
      ),
    );

    await database.into(database.genres).insert(
      GenresCompanion.insert(
        name: 'Action',
      ),
    );

    await database.into(database.themes).insert(
      ThemesCompanion.insert(
        name: 'Fantasy',
      ),
    );

    await database.into(database.themes).insert(
      ThemesCompanion.insert(
        name: 'Dark',
      ),
    );

    final media = await repository.create(
      type: MediaType.game,
      metadata: const MediaMetadata(
        title: 'Test Game',
        genres: [
          domain.Genre(
            id: 1,
            name: 'RPG',
          ),
          domain.Genre(
            id: 2,
            name: 'Action',
          ),
        ],
        themes: [
          domain.Theme(
            id: 1,
            name: 'Fantasy',
          ),
          domain.Theme(
            id: 2,
            name: 'Dark',
          ),
        ],
      ),
      userData: const MediaUserData(
        status: MediaStatus.planned,
      ),
    );

    expect(media.metadata.genres, hasLength(2));
    expect(media.metadata.genres[0].name, 'RPG');
    expect(media.metadata.genres[1].name, 'Action');

    expect(media.metadata.themes, hasLength(2));
    expect(media.metadata.themes[0].name, 'Fantasy');
    expect(media.metadata.themes[1].name, 'Dark');

    final storedGenres =
    await database.select(database.mediaGenres).get();
    final storedThemes =
    await database.select(database.mediaThemes).get();

    expect(storedGenres, hasLength(2));
    expect(storedThemes, hasLength(2));
  });

  test('create stores and returns external IDs and tags', () async {
    await database.into(database.tags).insert(
      TagsCompanion.insert(
        name: 'Backlog',
      ),
    );

    await database.into(database.tags).insert(
      TagsCompanion.insert(
        name: 'Favorite',
      ),
    );

    final media = await repository.create(
      type: MediaType.game,
      metadata: const MediaMetadata(
        title: 'Test Game',
        externalIds: [
          domain.ExternalId(
            source: 'igdb',
            value: '12345',
          ),
          domain.ExternalId(
            source: 'steam',
            value: '98765',
          ),
        ],
      ),
      userData: const MediaUserData(
        status: MediaStatus.planned,
        tags: [
          domain.Tag(
            id: 1,
            name: 'Backlog',
          ),
          domain.Tag(
            id: 2,
            name: 'Favorite',
          ),
        ],
      ),
    );

    expect(media.metadata.externalIds, hasLength(2));
    expect(media.metadata.externalIds[0].source, 'igdb');
    expect(media.metadata.externalIds[0].value, '12345');
    expect(media.metadata.externalIds[1].source, 'steam');
    expect(media.metadata.externalIds[1].value, '98765');

    expect(media.userData.tags, hasLength(2));
    expect(media.userData.tags[0].name, 'Backlog');
    expect(media.userData.tags[1].name, 'Favorite');

    final storedExternalIds =
    await database.select(database.externalIds).get();
    final storedTags =
    await database.select(database.mediaTags).get();

    expect(storedExternalIds, hasLength(2));
    expect(storedTags, hasLength(2));

    expect(storedExternalIds[0].mediaId, media.id);
    expect(storedExternalIds[0].source, 'igdb');
    expect(storedExternalIds[0].externalId, '12345');

    expect(storedTags[0].mediaId, media.id);
    expect(storedTags[0].tagId, 1);
  });

  test('getById returns the complete media item', () async {
    final releaseDate = DateOnly(
      year: 2025,
      month: 11,
      day: 11,
    );

    final media = await repository.create(
      type: MediaType.game,
      metadata: MediaMetadata(
        title: 'Test Game',
        description: 'A description.',
        coverUrl: 'cover.jpg',
        releaseDate: releaseDate,
      ),
      userData: MediaUserData(
        status: MediaStatus.completed,
        rating: 92,
        startedOn: DateOnly(
          year: 2026,
          month: 8,
          day: 1,
        ),
        finishedOn: DateOnly(
          year: 2026,
          month: 8,
          day: 18,
        ),
        review: 'Really enjoyed it.',
      ),
    );

    final result = await repository.getById(media.id);

    expect(result, isNotNull);
    expect(result!.id, media.id);
    expect(result.type, MediaType.game);
    expect(result.metadata.title, 'Test Game');
    expect(result.metadata.description, 'A description.');
    expect(result.metadata.coverUrl, 'cover.jpg');
    expect(result.metadata.releaseDate, releaseDate);
    expect(result.userData.status, MediaStatus.completed);
    expect(result.userData.rating, 92);
    expect(
      result.userData.startedOn,
      DateOnly(year: 2026, month: 8, day: 1),
    );
    expect(
      result.userData.finishedOn,
      DateOnly(year: 2026, month: 8, day: 18),
    );
    expect(result.userData.review, 'Really enjoyed it.');
  });

  test('getById returns genres and themes', () async {
    await database.into(database.genres).insert(
      GenresCompanion.insert(
        name: 'RPG',
      ),
    );

    await database.into(database.themes).insert(
      ThemesCompanion.insert(
        name: 'Fantasy',
      ),
    );

    final media = await repository.create(
      type: MediaType.game,
      metadata: const MediaMetadata(
        title: 'Test Game',
        genres: [
          domain.Genre(
            id: 1,
            name: 'RPG',
          ),
        ],
        themes: [
          domain.Theme(
            id: 1,
            name: 'Fantasy',
          ),
        ],
      ),
      userData: const MediaUserData(
        status: MediaStatus.planned,
      ),
    );

    final result = await repository.getById(media.id);

    expect(result, isNotNull);

    expect(result!.metadata.genres, hasLength(1));
    expect(result.metadata.genres.first.id, 1);
    expect(result.metadata.genres.first.name, 'RPG');

    expect(result.metadata.themes, hasLength(1));
    expect(result.metadata.themes.first.id, 1);
    expect(result.metadata.themes.first.name, 'Fantasy');
  });

  test('getById returns external IDs and tags', () async {
    await database.into(database.tags).insert(
      TagsCompanion.insert(
        name: 'Backlog',
      ),
    );

    await database.into(database.tags).insert(
      TagsCompanion.insert(
        name: 'Favorite',
      ),
    );

    final media = await repository.create(
      type: MediaType.game,
      metadata: const MediaMetadata(
        title: 'Test Game',
        externalIds: [
          domain.ExternalId(
            source: 'igdb',
            value: '12345',
          ),
          domain.ExternalId(
            source: 'steam',
            value: '98765',
          ),
        ],
      ),
      userData: const MediaUserData(
        status: MediaStatus.planned,
        tags: [
          domain.Tag(
            id: 1,
            name: 'Backlog',
          ),
          domain.Tag(
            id: 2,
            name: 'Favorite',
          ),
        ],
      ),
    );

    final result = await repository.getById(media.id);

    expect(result, isNotNull);

    expect(result!.metadata.externalIds, hasLength(2));
    expect(result.metadata.externalIds[0].source, 'igdb');
    expect(result.metadata.externalIds[0].value, '12345');
    expect(result.metadata.externalIds[1].source, 'steam');
    expect(result.metadata.externalIds[1].value, '98765');

    expect(result.userData.tags, hasLength(2));
    expect(result.userData.tags[0].id, 1);
    expect(result.userData.tags[0].name, 'Backlog');
    expect(result.userData.tags[1].id, 2);
    expect(result.userData.tags[1].name, 'Favorite');
  });

  test('getById returns null for an unknown ID', () async {
    final result = await repository.getById(999);

    expect(result, isNull);
  });

  test('getAll returns an empty list when there is no media', () async {
    final result = await repository.getAll();

    expect(result, isEmpty);
  });

  test('getAll returns all media newest first', () async {
    final first = await repository.create(
      type: MediaType.game,
      metadata: const MediaMetadata(
        title: 'First Game',
      ),
      userData: const MediaUserData(
        status: MediaStatus.planned,
      ),
    );

    final second = await repository.create(
      type: MediaType.game,
      metadata: const MediaMetadata(
        title: 'Second Game',
      ),
      userData: const MediaUserData(
        status: MediaStatus.planned,
      ),
    );

    final result = await repository.getAll();

    expect(result, hasLength(2));
    expect(result[0].id, second.id);
    expect(result[1].id, first.id);

    expect(result[0].metadata.title, 'Second Game');
    expect(result[1].metadata.title, 'First Game');
  });

  test('getAll returns genres and themes', () async {
    await database.into(database.genres).insert(
      GenresCompanion.insert(
        name: 'RPG',
      ),
    );

    await database.into(database.themes).insert(
      ThemesCompanion.insert(
        name: 'Fantasy',
      ),
    );

    await repository.create(
      type: MediaType.game,
      metadata: const MediaMetadata(
        title: 'Test Game',
        genres: [
          domain.Genre(
            id: 1,
            name: 'RPG',
          ),
        ],
        themes: [
          domain.Theme(
            id: 1,
            name: 'Fantasy',
          ),
        ],
      ),
      userData: const MediaUserData(
        status: MediaStatus.planned,
      ),
    );

    final result = await repository.getAll();

    expect(result, hasLength(1));
    expect(result.first.metadata.genres, hasLength(1));
    expect(result.first.metadata.genres.first.name, 'RPG');
    expect(result.first.metadata.themes, hasLength(1));
    expect(result.first.metadata.themes.first.name, 'Fantasy');
  });

  test('getAll returns external IDs and tags', () async {
    await database.into(database.tags).insert(
      TagsCompanion.insert(
        name: 'Backlog',
      ),
    );

    final media = await repository.create(
      type: MediaType.game,
      metadata: const MediaMetadata(
        title: 'Test Game',
        externalIds: [
          domain.ExternalId(
            source: 'igdb',
            value: '12345',
          ),
        ],
      ),
      userData: const MediaUserData(
        status: MediaStatus.planned,
        tags: [
          domain.Tag(
            id: 1,
            name: 'Backlog',
          ),
        ],
      ),
    );

    final result = await repository.getAll();

    expect(result, hasLength(1));

    expect(result.first.id, media.id);

    expect(result.first.metadata.externalIds, hasLength(1));
    expect(result.first.metadata.externalIds.first.source, 'igdb');
    expect(result.first.metadata.externalIds.first.value, '12345');

    expect(result.first.userData.tags, hasLength(1));
    expect(result.first.userData.tags.first.id, 1);
    expect(result.first.userData.tags.first.name, 'Backlog');
  });

  test('update changes values while preserving createdAt', () async {
    final original = await repository.create(
      type: MediaType.game,
      metadata: const MediaMetadata(
        title: 'Original Title',
        description: 'Original description.',
      ),
      userData: const MediaUserData(
        status: MediaStatus.planned,
        review: 'Original review.',
      ),
    );

    final originalMediaRow =
    await database.select(database.media).getSingle();

    await Future<void>.delayed(const Duration(milliseconds: 2));

    final updated = original.copyWith(
      metadata: original.metadata.copyWith(
        title: 'Updated Title',
        description: 'Updated description.',
      ),
      userData: original.userData.copyWith(
        status: MediaStatus.completed,
        review: 'Updated review.',
      ),
    );

    final result = await repository.update(updated);

    final updatedMediaRow =
    await database.select(database.media).getSingle();

    expect(result.id, original.id);
    expect(result.metadata.title, 'Updated Title');
    expect(result.metadata.description, 'Updated description.');
    expect(result.userData.status, MediaStatus.completed);
    expect(result.userData.review, 'Updated review.');

    expect(updatedMediaRow.id, originalMediaRow.id);
    expect(updatedMediaRow.createdAt, originalMediaRow.createdAt);
    expect(
      updatedMediaRow.updatedAt.compareTo(originalMediaRow.updatedAt),
      greaterThanOrEqualTo(0),
    );
  });

  test('update replaces genres, themes, external IDs, and tags', () async {
    await database.into(database.genres).insert(
      GenresCompanion.insert(
        name: 'RPG',
      ),
    );

    await database.into(database.genres).insert(
      GenresCompanion.insert(
        name: 'Action',
      ),
    );

    await database.into(database.themes).insert(
      ThemesCompanion.insert(
        name: 'Fantasy',
      ),
    );

    await database.into(database.themes).insert(
      ThemesCompanion.insert(
        name: 'Sci-Fi',
      ),
    );

    await database.into(database.tags).insert(
      TagsCompanion.insert(
        name: 'Backlog',
      ),
    );

    await database.into(database.tags).insert(
      TagsCompanion.insert(
        name: 'Favorite',
      ),
    );

    final original = await repository.create(
      type: MediaType.game,
      metadata: const MediaMetadata(
        title: 'Test Game',
        genres: [
          domain.Genre(
            id: 1,
            name: 'RPG',
          ),
        ],
        themes: [
          domain.Theme(
            id: 1,
            name: 'Fantasy',
          ),
        ],
        externalIds: [
          domain.ExternalId(
            source: 'igdb',
            value: 'old-id',
          ),
        ],
      ),
      userData: const MediaUserData(
        status: MediaStatus.planned,
        tags: [
          domain.Tag(
            id: 1,
            name: 'Backlog',
          ),
        ],
      ),
    );

    final updated = original.copyWith(
      metadata: original.metadata.copyWith(
        genres: const [
          domain.Genre(
            id: 2,
            name: 'Action',
          ),
        ],
        themes: const [
          domain.Theme(
            id: 2,
            name: 'Sci-Fi',
          ),
        ],
        externalIds: const [
          domain.ExternalId(
            source: 'steam',
            value: 'new-id',
          ),
        ],
      ),
      userData: original.userData.copyWith(
        tags: const [
          domain.Tag(
            id: 2,
            name: 'Favorite',
          ),
        ],
      ),
    );

    await repository.update(updated);

    final result = await repository.getById(original.id);

    expect(result, isNotNull);

    expect(result!.metadata.genres, hasLength(1));
    expect(result.metadata.genres.first.id, 2);
    expect(result.metadata.genres.first.name, 'Action');

    expect(result.metadata.themes, hasLength(1));
    expect(result.metadata.themes.first.id, 2);
    expect(result.metadata.themes.first.name, 'Sci-Fi');

    expect(result.metadata.externalIds, hasLength(1));
    expect(result.metadata.externalIds.first.source, 'steam');
    expect(result.metadata.externalIds.first.value, 'new-id');

    expect(result.userData.tags, hasLength(1));
    expect(result.userData.tags.first.id, 2);
    expect(result.userData.tags.first.name, 'Favorite');

    expect(
      await database.select(database.mediaGenres).get(),
      hasLength(1),
    );

    expect(
      await database.select(database.mediaThemes).get(),
      hasLength(1),
    );

    expect(
      await database.select(database.externalIds).get(),
      hasLength(1),
    );

    expect(
      await database.select(database.mediaTags).get(),
      hasLength(1),
    );
  });

  test('delete removes the complete media aggregate', () async {
    await database.into(database.genres).insert(
      GenresCompanion.insert(
        name: 'RPG',
      ),
    );

    await database.into(database.themes).insert(
      ThemesCompanion.insert(
        name: 'Fantasy',
      ),
    );

    await database.into(database.tags).insert(
      TagsCompanion.insert(
        name: 'Backlog',
      ),
    );

    final media = await repository.create(
      type: MediaType.game,
      metadata: const MediaMetadata(
        title: 'Test Game',
        genres: [
          domain.Genre(
            id: 1,
            name: 'RPG',
          ),
        ],
        themes: [
          domain.Theme(
            id: 1,
            name: 'Fantasy',
          ),
        ],
        externalIds: [
          domain.ExternalId(
            source: 'igdb',
            value: '12345',
          ),
        ],
      ),
      userData: const MediaUserData(
        status: MediaStatus.planned,
        tags: [
          domain.Tag(
            id: 1,
            name: 'Backlog',
          ),
        ],
      ),
    );

    await repository.delete(media.id);

    expect(await database.select(database.media).get(), isEmpty);
    expect(await database.select(database.mediaMetadata).get(), isEmpty);
    expect(await database.select(database.mediaUserData).get(), isEmpty);
    expect(await database.select(database.mediaGenres).get(), isEmpty);
    expect(await database.select(database.mediaThemes).get(), isEmpty);
    expect(await database.select(database.externalIds).get(), isEmpty);
    expect(await database.select(database.mediaTags).get(), isEmpty);

    expect(await database.select(database.genres).get(), hasLength(1));
    expect(await database.select(database.themes).get(), hasLength(1));
    expect(await database.select(database.tags).get(), hasLength(1));
  });

  test('delete does nothing when the ID does not exist', () async {
    await repository.delete(999);

    expect(await database.select(database.media).get(), isEmpty);
  });
}