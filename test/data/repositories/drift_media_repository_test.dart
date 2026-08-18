import 'package:flutter_test/flutter_test.dart';
import 'package:cybershelf/data/database/app_database.dart';
import 'package:cybershelf/data/repositories/drift_media_repository.dart';
import 'package:cybershelf/domain/date_only.dart';
import 'package:cybershelf/domain/media/media_metadata.dart';
import 'package:cybershelf/domain/media/media_user_data.dart';
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

  test('delete removes the complete media aggregate', () async {
    final media = await repository.create(
      type: MediaType.game,
      metadata: const MediaMetadata(
        title: 'Test Game',
      ),
      userData: const MediaUserData(
        status: MediaStatus.planned,
      ),
    );

    await repository.delete(media.id);

    expect(await database.select(database.media).get(), isEmpty);
    expect(await database.select(database.mediaMetadata).get(), isEmpty);
    expect(await database.select(database.mediaUserData).get(), isEmpty);
  });

  test('delete does nothing when the ID does not exist', () async {
    await repository.delete(999);

    expect(await database.select(database.media).get(), isEmpty);
  });
}