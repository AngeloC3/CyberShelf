import 'package:drift/drift.dart';
import 'package:cybershelf/data/database/app_database.dart';
import 'package:cybershelf/domain/media/media_item.dart';
import 'package:cybershelf/domain/media/media_metadata.dart';
import 'package:cybershelf/domain/media/media_user_data.dart';
import 'package:cybershelf/domain/media/external_id.dart' as domain;
import 'package:cybershelf/domain/media/genre.dart' as domain;
import 'package:cybershelf/domain/media/tag.dart' as domain;
import 'package:cybershelf/domain/media/theme.dart' as domain;
import 'package:cybershelf/domain/media_repository.dart';
import 'package:cybershelf/domain/media_type.dart';

class DriftMediaRepository implements MediaRepository {
  DriftMediaRepository(this._database);

  final AppDatabase _database;

  @override
  Future<MediaItem> create({
    required MediaType type,
    required MediaMetadata metadata,
    required MediaUserData userData,
  }) async {
    return _database.transaction(() async {
      final now = DateTime.now();

      final mediaId = await _database.into(_database.media).insert(
        MediaCompanion.insert(
          mediaType: type,
          createdAt: now,
          updatedAt: now,
        ),
      );

      await _database.into(_database.mediaMetadata).insert(
        MediaMetadataCompanion.insert(
          mediaId: Value(mediaId),
          title: metadata.title,
          description: Value(metadata.description),
          coverUrl: Value(metadata.coverUrl),
          releaseDate: Value(metadata.releaseDate),
          updatedAt: now,
        ),
      );

      await _database.into(_database.mediaUserData).insert(
        MediaUserDataCompanion.insert(
          mediaId: Value(mediaId),
          status: userData.status,
          rating: Value(userData.rating),
          startedOn: Value(userData.startedOn),
          finishedOn: Value(userData.finishedOn),
          review: Value(userData.review),
          updatedAt: now,
        ),
      );

      for (final genre in metadata.genres) {
        await _database.into(_database.mediaGenres).insert(
          MediaGenresCompanion.insert(
            mediaId: mediaId,
            genreId: genre.id,
          ),
        );
      }

      for (final theme in metadata.themes) {
        await _database.into(_database.mediaThemes).insert(
          MediaThemesCompanion.insert(
            mediaId: mediaId,
            themeId: theme.id,
          ),
        );
      }

      for (final externalId in metadata.externalIds) {
        await _database.into(_database.externalIds).insert(
          ExternalIdsCompanion.insert(
            mediaId: mediaId,
            source: externalId.source,
            externalId: externalId.value,
          ),
        );
      }

      for (final tag in userData.tags) {
        await _database.into(_database.mediaTags).insert(
          MediaTagsCompanion.insert(
            mediaId: mediaId,
            tagId: tag.id,
          ),
        );
      }

      return MediaItem(
        id: mediaId,
        type: type,
        metadata: metadata,
        userData: userData,
      );
    });
  }

  @override
  Future<MediaItem?> getById(int id) async {
    final query = _database.select(_database.media).join([
      innerJoin(
        _database.mediaMetadata,
        _database.mediaMetadata.mediaId.equalsExp(_database.media.id),
      ),
      innerJoin(
        _database.mediaUserData,
        _database.mediaUserData.mediaId.equalsExp(_database.media.id),
      ),
    ])
      ..where(_database.media.id.equals(id));

    final row = await query.getSingleOrNull();

    if (row == null) {
      return null;
    }

    final media = row.readTable(_database.media);
    final metadata = row.readTable(_database.mediaMetadata);
    final userData = row.readTable(_database.mediaUserData);

    final genresQuery = _database.select(_database.mediaGenres).join([
      innerJoin(
        _database.genres,
        _database.genres.id.equalsExp(_database.mediaGenres.genreId),
      ),
    ])
      ..where(_database.mediaGenres.mediaId.equals(media.id));

    final genreRows = await genresQuery.get();

    final genres = genreRows.map((row) {
      final genre = row.readTable(_database.genres);

      return domain.Genre(
        id: genre.id,
        name: genre.name,
      );
    }).toList();

    final themesQuery = _database.select(_database.mediaThemes).join([
      innerJoin(
        _database.themes,
        _database.themes.id.equalsExp(_database.mediaThemes.themeId),
      ),
    ])
      ..where(_database.mediaThemes.mediaId.equals(media.id));

    final themeRows = await themesQuery.get();

    final themes = themeRows.map((row) {
      final theme = row.readTable(_database.themes);

      return domain.Theme(
        id: theme.id,
        name: theme.name,
      );
    }).toList();

    final externalIdRows = await (_database.select(_database.externalIds)
      ..where((table) => table.mediaId.equals(media.id)))
        .get();

    final externalIds = externalIdRows.map((row) {
      return domain.ExternalId(
        source: row.source,
        value: row.externalId,
      );
    }).toList();

    final tagQuery = _database.select(_database.mediaTags).join([
      innerJoin(
        _database.tags,
        _database.tags.id.equalsExp(_database.mediaTags.tagId),
      ),
    ])
      ..where(_database.mediaTags.mediaId.equals(media.id));

    final tagRows = await tagQuery.get();

    final tags = tagRows.map((row) {
      final tag = row.readTable(_database.tags);

      return domain.Tag(
        id: tag.id,
        name: tag.name,
      );
    }).toList();

    return MediaItem(
      id: media.id,
      type: media.mediaType,
      metadata: MediaMetadata(
        title: metadata.title,
        description: metadata.description,
        coverUrl: metadata.coverUrl,
        releaseDate: metadata.releaseDate,
        genres: genres,
        themes: themes,
        externalIds: externalIds,
      ),
      userData: MediaUserData(
        status: userData.status,
        rating: userData.rating,
        startedOn: userData.startedOn,
        finishedOn: userData.finishedOn,
        review: userData.review,
        tags: tags,
      ),
    );
  }

  @override
  Future<List<MediaItem>> getAll() async {
    final query = _database.select(_database.media).join([
      innerJoin(
        _database.mediaMetadata,
        _database.mediaMetadata.mediaId.equalsExp(_database.media.id),
      ),
      innerJoin(
        _database.mediaUserData,
        _database.mediaUserData.mediaId.equalsExp(_database.media.id),
      ),
    ])
      ..orderBy([
        OrderingTerm(
          expression: _database.media.createdAt,
          mode: OrderingMode.desc,
        ),
        OrderingTerm(
          expression: _database.media.id,
          mode: OrderingMode.desc,
        ),
      ]);

    final rows = await query.get();

    final result = <MediaItem>[];

    for (final row in rows) {
      final media = row.readTable(_database.media);
      final metadata = row.readTable(_database.mediaMetadata);
      final userData = row.readTable(_database.mediaUserData);

      final genresQuery = _database.select(_database.mediaGenres).join([
        innerJoin(
          _database.genres,
          _database.genres.id.equalsExp(_database.mediaGenres.genreId),
        ),
      ])
        ..where(_database.mediaGenres.mediaId.equals(media.id));

      final genreRows = await genresQuery.get();

      final genres = genreRows.map((row) {
        final genre = row.readTable(_database.genres);

        return domain.Genre(
          id: genre.id,
          name: genre.name,
        );
      }).toList();

      final themesQuery = _database.select(_database.mediaThemes).join([
        innerJoin(
          _database.themes,
          _database.themes.id.equalsExp(_database.mediaThemes.themeId),
        ),
      ])
        ..where(_database.mediaThemes.mediaId.equals(media.id));

      final themeRows = await themesQuery.get();

      final themes = themeRows.map((row) {
        final theme = row.readTable(_database.themes);

        return domain.Theme(
          id: theme.id,
          name: theme.name,
        );
      }).toList();

      final externalIdRows = await (_database.select(_database.externalIds)
        ..where((table) => table.mediaId.equals(media.id)))
          .get();

      final externalIds = externalIdRows.map((row) {
        return domain.ExternalId(
          source: row.source,
          value: row.externalId,
        );
      }).toList();

      final tagQuery = _database.select(_database.mediaTags).join([
        innerJoin(
          _database.tags,
          _database.tags.id.equalsExp(_database.mediaTags.tagId),
        ),
      ])
        ..where(_database.mediaTags.mediaId.equals(media.id));

      final tagRows = await tagQuery.get();

      final tags = tagRows.map((row) {
        final tag = row.readTable(_database.tags);

        return domain.Tag(
          id: tag.id,
          name: tag.name,
        );
      }).toList();

      result.add(
        MediaItem(
          id: media.id,
          type: media.mediaType,
          metadata: MediaMetadata(
            title: metadata.title,
            description: metadata.description,
            coverUrl: metadata.coverUrl,
            releaseDate: metadata.releaseDate,
            genres: genres,
            themes: themes,
            externalIds: externalIds,
          ),
          userData: MediaUserData(
            status: userData.status,
            rating: userData.rating,
            startedOn: userData.startedOn,
            finishedOn: userData.finishedOn,
            review: userData.review,
            tags: tags,
          ),
        ),
      );
    }

    return result;
  }

  @override
  Future<MediaItem> update(MediaItem media) async {
    return _database.transaction(() async {
      final now = DateTime.now();

      await (_database.update(_database.media)
        ..where((table) => table.id.equals(media.id)))
          .write(
        MediaCompanion(
          mediaType: Value(media.type),
          updatedAt: Value(now),
        ),
      );

      await (_database.update(_database.mediaMetadata)
        ..where((table) => table.mediaId.equals(media.id)))
          .write(
        MediaMetadataCompanion(
          title: Value(media.metadata.title),
          description: Value(media.metadata.description),
          coverUrl: Value(media.metadata.coverUrl),
          releaseDate: Value(media.metadata.releaseDate),
          updatedAt: Value(now),
        ),
      );

      await (_database.update(_database.mediaUserData)
        ..where((table) => table.mediaId.equals(media.id)))
          .write(
        MediaUserDataCompanion(
          status: Value(media.userData.status),
          rating: Value(media.userData.rating),
          startedOn: Value(media.userData.startedOn),
          finishedOn: Value(media.userData.finishedOn),
          review: Value(media.userData.review),
          updatedAt: Value(now),
        ),
      );

      await (_database.delete(_database.mediaGenres)
        ..where((table) => table.mediaId.equals(media.id)))
          .go();

      for (final genre in media.metadata.genres) {
        await _database.into(_database.mediaGenres).insert(
          MediaGenresCompanion.insert(
            mediaId: media.id,
            genreId: genre.id,
          ),
        );
      }

      await (_database.delete(_database.mediaThemes)
        ..where((table) => table.mediaId.equals(media.id)))
          .go();

      for (final theme in media.metadata.themes) {
        await _database.into(_database.mediaThemes).insert(
          MediaThemesCompanion.insert(
            mediaId: media.id,
            themeId: theme.id,
          ),
        );
      }

      await (_database.delete(_database.externalIds)
        ..where((table) => table.mediaId.equals(media.id)))
          .go();

      for (final externalId in media.metadata.externalIds) {
        await _database.into(_database.externalIds).insert(
          ExternalIdsCompanion.insert(
            mediaId: media.id,
            source: externalId.source,
            externalId: externalId.value,
          ),
        );
      }

      await (_database.delete(_database.mediaTags)
        ..where((table) => table.mediaId.equals(media.id)))
          .go();

      for (final tag in media.userData.tags) {
        await _database.into(_database.mediaTags).insert(
          MediaTagsCompanion.insert(
            mediaId: media.id,
            tagId: tag.id,
          ),
        );
      }

      return media;
    });
  }

  @override
  Future<void> delete(int id) async {
    await (_database.delete(_database.media)
      ..where((table) => table.id.equals(id)))
        .go();
  }
}