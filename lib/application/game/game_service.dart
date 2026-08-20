// lib/application/game/game_service.dart
import 'package:drift/drift.dart';
import 'package:cybershelf/data/database/app_database.dart';
import 'package:cybershelf/domain/game/external_game_source.dart';
import 'package:cybershelf/domain/game/game_item.dart';
import 'package:cybershelf/domain/game/game_metadata.dart';
import 'package:cybershelf/domain/game/game_repository.dart';
import 'package:cybershelf/domain/game/game_user_data.dart';
import 'package:cybershelf/domain/game/game_mode.dart';
import 'package:cybershelf/domain/game/game_platform.dart';
import 'package:cybershelf/domain/media/contributor.dart' as domain;
import 'package:cybershelf/domain/media/genre.dart' as domain;
import 'package:cybershelf/domain/media/series.dart' as domain;
import 'package:cybershelf/domain/media/media_user_data.dart';
import 'package:cybershelf/domain/date_only.dart';
import 'package:cybershelf/domain/media/media_metadata.dart';
import 'package:cybershelf/domain/media/tag.dart' as domain;
import 'package:cybershelf/domain/media/theme.dart' as domain;
import 'package:cybershelf/domain/media_status.dart';

class GameService {
  GameService(
      this._repository,
      this._database,
      );

  final GameRepository _repository;
  final AppDatabase _database;

  Future<GameItem> create({
    required MediaMetadata metadata,
    required MediaUserData userData,
    required GameMetadata gameMetadata,
    required GameUserData gameUserData,
  }) {
    return _repository.create(
      metadata: metadata,
      userData: userData,
      gameMetadata: gameMetadata,
      gameUserData: gameUserData,
    );
  }

  Future<GameItem?> getById(int id) {
    return _repository.getById(id);
  }

  Future<List<GameItem>> getAll() {
    return _repository.getAll();
  }

  Future<GameItem> update(GameItem game) async {
    // Resolve tags before updating
    final resolvedTags = await _resolveTags(game.media.userData.tags);

    // Resolve developers and publishers
    final resolvedGameMetadata = await _resolveDevelopersAndPublishers(
      game.gameMetadata,
    );

    final updatedUserData = game.media.userData.copyWith(
      tags: resolvedTags,
    );

    final updatedMedia = game.media.copyWith(
      userData: updatedUserData,
    );

    final updatedGame = game.copyWith(
      media: updatedMedia,
      gameMetadata: resolvedGameMetadata,
    );

    return _repository.update(updatedGame);
  }

  Future<void> delete(int id) {
    return _repository.delete(id);
  }

  Future<GameItem> importFromExternalSource(ExternalGameResult result) async {
    // Resolve genres
    final genreIds = <int>[];
    for (final genre in result.genres) {
      final existingGenre = await (_database.select(_database.genres)
        ..where((g) => g.name.equals(genre.name)))
          .getSingleOrNull();

      int genreId;
      if (existingGenre != null) {
        genreId = existingGenre.id;
      } else {
        genreId = await _database.into(_database.genres).insert(
          GenresCompanion.insert(
            name: genre.name,
          ),
        );
      }
      genreIds.add(genreId);
    }

    // Resolve themes
    final themeIds = <int>[];
    for (final theme in result.themes) {
      final existingTheme = await (_database.select(_database.themes)
        ..where((t) => t.name.equals(theme.name)))
          .getSingleOrNull();

      int themeId;
      if (existingTheme != null) {
        themeId = existingTheme.id;
      } else {
        themeId = await _database.into(_database.themes).insert(
          ThemesCompanion.insert(
            name: theme.name,
          ),
        );
      }
      themeIds.add(themeId);
    }

    // Resolve series
    final seriesIds = <int>[];
    for (final seriesName in result.series) {
      final existingSeries = await (_database.select(_database.series)
        ..where((s) => s.name.equals(seriesName)))
          .getSingleOrNull();

      int seriesId;
      if (existingSeries != null) {
        seriesId = existingSeries.id;
      } else {
        seriesId = await _database.into(_database.series).insert(
          SeriesCompanion.insert(
            name: seriesName,
          ),
        );
      }
      seriesIds.add(seriesId);
    }

    // Build domain genres with local IDs
    final domainGenres = genreIds.asMap().entries.map((entry) {
      final index = entry.key;
      final id = entry.value;
      return domain.Genre(
        id: id,
        name: result.genres[index].name,
      );
    }).toList();

    // Build domain themes with local IDs
    final domainThemes = themeIds.asMap().entries.map((entry) {
      final index = entry.key;
      final id = entry.value;
      return domain.Theme(
        id: id,
        name: result.themes[index].name,
      );
    }).toList();

    // Build domain series with local IDs
    final domainSeries = seriesIds.asMap().entries.map((entry) {
      final index = entry.key;
      final id = entry.value;
      return domain.Series(
        id: id,
        name: result.series[index],
      );
    }).toList();

    // Build the media metadata
    final metadata = MediaMetadata(
      title: result.title,
      coverUrl: result.coverUrl,
      releaseDate: result.releaseDate,
      genres: domainGenres,
      themes: domainThemes,
      series: domainSeries,
    );

    // Create game metadata and resolve developers and publishers
    final gameMetadata = await _resolveDeveloperAndPublisherNames(
      const GameMetadata(),
      result.developers,
      result.publishers,
    );

    // Default user data
    const userData = MediaUserData(
      status: MediaStatus.planned,
    );

    // Default game user data
    const gameUserData = GameUserData();

    // Create the game
    return create(
      metadata: metadata,
      userData: userData,
      gameMetadata: gameMetadata,
      gameUserData: gameUserData,
    );
  }

  Future<GameItem> createManual({
    required String title,
    String? description,
    String? coverUrl,
    DateOnly? releaseDate,
    List<String> genreNames = const [],
    List<String> themeNames = const [],
    List<String> seriesNames = const [],
    List<String> developerNames = const [],
    List<String> publisherNames = const [],
    List<GameMode> playedModes = const [],
    List<GamePlatform> playedPlatforms = const [],
    MediaStatus status = MediaStatus.planned,
  }) async {
    // Validate title
    if (title.trim().isEmpty) {
      throw Exception('Title cannot be empty');
    }

    // Resolve genres
    final genreIds = <int>[];
    for (final name in genreNames) {
      final existing = await (_database.select(_database.genres)
        ..where((g) => g.name.equals(name))).getSingleOrNull();
      final id = existing != null
          ? existing.id
          : await _database.into(_database.genres).insert(
        GenresCompanion.insert(name: name),
      );
      genreIds.add(id);
    }

    // Resolve themes
    final themeIds = <int>[];
    for (final name in themeNames) {
      final existing = await (_database.select(_database.themes)
        ..where((t) => t.name.equals(name))).getSingleOrNull();
      final id = existing != null
          ? existing.id
          : await _database.into(_database.themes).insert(
        ThemesCompanion.insert(name: name),
      );
      themeIds.add(id);
    }

    // Resolve series
    final seriesIds = <int>[];
    for (final name in seriesNames) {
      final existing = await (_database.select(_database.series)
        ..where((s) => s.name.equals(name))).getSingleOrNull();
      final id = existing != null
          ? existing.id
          : await _database.into(_database.series).insert(
        SeriesCompanion.insert(name: name),
      );
      seriesIds.add(id);
    }

    // Build domain models
    final genres = genreIds.asMap().entries.map((entry) {
      final index = entry.key;
      return domain.Genre(id: entry.value, name: genreNames[index]);
    }).toList();

    final themes = themeIds.asMap().entries.map((entry) {
      final index = entry.key;
      return domain.Theme(id: entry.value, name: themeNames[index]);
    }).toList();

    final series = seriesIds.asMap().entries.map((entry) {
      final index = entry.key;
      return domain.Series(id: entry.value, name: seriesNames[index]);
    }).toList();

    final metadata = MediaMetadata(
      title: title,
      description: description,
      coverUrl: coverUrl,
      releaseDate: releaseDate,
      genres: genres,
      themes: themes,
      series: series,
    );

    final userData = MediaUserData(status: status);

    final gameMetadata = const GameMetadata();

    final gameUserData = GameUserData(
      playedModes: playedModes,
      playedPlatforms: playedPlatforms,
    );

    // Create the game
    final game = await create(
      metadata: metadata,
      userData: userData,
      gameMetadata: gameMetadata,
      gameUserData: gameUserData,
    );

    // Add developers and publishers if any
    if (developerNames.isNotEmpty || publisherNames.isNotEmpty) {
      return await addDevelopersAndPublishers(
        game.media.id,
        developerNames,
        publisherNames,
      );
    }

    return game;
  }

  // ============================================================
  // Private Helpers
  // ============================================================

  Future<List<domain.Tag>> _resolveTags(List<domain.Tag> tags) async {
    if (tags.isEmpty) return [];

    final resolvedTags = <domain.Tag>[];

    for (final tag in tags) {
      if (tag.id > 0) {
        final existingTag = await (_database.select(_database.tags)
          ..where((t) => t.id.equals(tag.id)))
            .getSingleOrNull();

        if (existingTag != null) {
          resolvedTags.add(domain.Tag(
            id: existingTag.id,
            name: existingTag.name,
          ));
          continue;
        }
      }

      final existingTag = await (_database.select(_database.tags)
        ..where((t) => t.name.equals(tag.name)))
          .getSingleOrNull();

      if (existingTag != null) {
        resolvedTags.add(domain.Tag(
          id: existingTag.id,
          name: existingTag.name,
        ));
      } else {
        final newId = await _database.into(_database.tags).insert(
          TagsCompanion.insert(
            name: tag.name,
          ),
        );
        resolvedTags.add(domain.Tag(
          id: newId,
          name: tag.name,
        ));
      }
    }

    return resolvedTags;
  }

  Future<GameMetadata> _resolveDevelopersAndPublishers(
      GameMetadata gameMetadata,
      ) async {
    // Resolve developers
    final resolvedDevelopers = <domain.Contributor>[];
    for (final contributor in gameMetadata.developers) {
      final resolved = await _resolveContributor(contributor);
      if (resolved != null) {
        resolvedDevelopers.add(resolved);
      }
    }

    // Resolve publishers
    final resolvedPublishers = <domain.Contributor>[];
    for (final contributor in gameMetadata.publishers) {
      final resolved = await _resolveContributor(contributor);
      if (resolved != null) {
        resolvedPublishers.add(resolved);
      }
    }

    return gameMetadata.copyWith(
      developers: resolvedDevelopers,
      publishers: resolvedPublishers,
    );
  }

  Future<domain.Contributor?> _resolveContributor(
      domain.Contributor contributor,
      ) async {
    // If it has a valid ID, try to find it
    if (contributor.id > 0) {
      final existing = await (_database.select(_database.contributors)
        ..where((c) => c.id.equals(contributor.id)))
          .getSingleOrNull();

      if (existing != null) {
        return domain.Contributor(
          id: existing.id,
          personId: existing.personId,
          companyId: existing.companyId,
        );
      }
    }

    // If it has a personId, try to find or create
    if (contributor.personId != null && contributor.personId! > 0) {
      final existingPerson = await (_database.select(_database.people)
        ..where((p) => p.id.equals(contributor.personId!)))
          .getSingleOrNull();

      if (existingPerson != null) {
        // Check if contributor already exists for this person
        final existingContributor = await (_database.select(_database.contributors)
          ..where((c) => c.personId.equals(existingPerson.id)))
            .getSingleOrNull();

        if (existingContributor != null) {
          return domain.Contributor(
            id: existingContributor.id,
            personId: existingContributor.personId,
            companyId: existingContributor.companyId,
          );
        }

        // Create new contributor
        final newId = await _database.into(_database.contributors).insert(
          ContributorsCompanion.insert(
            personId: Value(existingPerson.id),
          ),
        );
        return domain.Contributor(
          id: newId,
          personId: existingPerson.id,
          companyId: null,
        );
      }
    }

    // If it has a companyId, try to find or create
    if (contributor.companyId != null && contributor.companyId! > 0) {
      final existingCompany = await (_database.select(_database.companies)
        ..where((c) => c.id.equals(contributor.companyId!)))
          .getSingleOrNull();

      if (existingCompany != null) {
        final existingContributor = await (_database.select(_database.contributors)
          ..where((c) => c.companyId.equals(existingCompany.id)))
            .getSingleOrNull();

        if (existingContributor != null) {
          return domain.Contributor(
            id: existingContributor.id,
            personId: existingContributor.personId,
            companyId: existingContributor.companyId,
          );
        }

        final newId = await _database.into(_database.contributors).insert(
          ContributorsCompanion.insert(
            companyId: Value(existingCompany.id),
          ),
        );
        return domain.Contributor(
          id: newId,
          personId: null,
          companyId: existingCompany.id,
        );
      }
    }

    return null;
  }

  Future<GameMetadata> _resolveDeveloperAndPublisherNames(
      GameMetadata gameMetadata,
      List<String> developerNames,
      List<String> publisherNames,
      ) async {
    final developers = <domain.Contributor>[];
    for (final name in developerNames) {
      final contributor = await _resolveContributorByName(name, isPerson: true);
      if (contributor != null) developers.add(contributor);
    }

    final publishers = <domain.Contributor>[];
    for (final name in publisherNames) {
      final contributor = await _resolveContributorByName(name, isPerson: false);
      if (contributor != null) publishers.add(contributor);
    }

    return gameMetadata.copyWith(
      developers: developers,
      publishers: publishers,
    );
  }

  Future<domain.Contributor?> _resolveContributorByName(
      String name, {
        required bool isPerson,
      }) async {
    if (name.trim().isEmpty) return null;

    if (isPerson) {
      // Try to find existing person
      final existingPerson = await (_database.select(_database.people)
        ..where((p) => p.name.equals(name)))
          .getSingleOrNull();

      int personId;
      if (existingPerson != null) {
        personId = existingPerson.id;
      } else {
        personId = await _database.into(_database.people).insert(
          PeopleCompanion.insert(name: name),
        );
      }

      // Check if contributor already exists for this person
      final existingContributor = await (_database.select(_database.contributors)
        ..where((c) => c.personId.equals(personId)))
          .getSingleOrNull();

      if (existingContributor != null) {
        return domain.Contributor(
          id: existingContributor.id,
          personId: existingContributor.personId,
          companyId: existingContributor.companyId,
        );
      }

      // Create new contributor
      final contributorId = await _database.into(_database.contributors).insert(
        ContributorsCompanion.insert(
          personId: Value(personId),
        ),
      );

      return domain.Contributor(
        id: contributorId,
        personId: personId,
        companyId: null,
      );
    } else {
      // Try to find existing company
      final existingCompany = await (_database.select(_database.companies)
        ..where((c) => c.name.equals(name)))
          .getSingleOrNull();

      int companyId;
      if (existingCompany != null) {
        companyId = existingCompany.id;
      } else {
        companyId = await _database.into(_database.companies).insert(
          CompaniesCompanion.insert(name: name),
        );
      }

      // Check if contributor already exists for this company
      final existingContributor = await (_database.select(_database.contributors)
        ..where((c) => c.companyId.equals(companyId)))
          .getSingleOrNull();

      if (existingContributor != null) {
        return domain.Contributor(
          id: existingContributor.id,
          personId: existingContributor.personId,
          companyId: existingContributor.companyId,
        );
      }

      // Create new contributor
      final contributorId = await _database.into(_database.contributors).insert(
        ContributorsCompanion.insert(
          companyId: Value(companyId),
        ),
      );

      return domain.Contributor(
        id: contributorId,
        personId: null,
        companyId: companyId,
      );
    }
  }

  Future<String> getContributorName(domain.Contributor contributor) async {
    if (contributor.isPerson) {
      final person = await (_database.select(_database.people)
        ..where((p) => p.id.equals(contributor.personId!)))
          .getSingleOrNull();
      return person?.name ?? 'Unknown Person';
    } else {
      final company = await (_database.select(_database.companies)
        ..where((c) => c.id.equals(contributor.companyId!)))
          .getSingleOrNull();
      return company?.name ?? 'Unknown Company';
    }
  }

  Future<GameItem> addDevelopersAndPublishers(
      int gameId,
      List<String> developerNames,
      List<String> publisherNames,
      ) async {
    final game = await getById(gameId);
    if (game == null) {
      throw StateError('Game with ID $gameId not found');
    }

    // Resolve developers and publishers from names
    final resolvedMetadata = await _resolveDeveloperAndPublisherNames(
      game.gameMetadata,
      developerNames,
      publisherNames,
    );

    final updatedGame = game.copyWith(
      gameMetadata: resolvedMetadata,
    );

    return update(updatedGame);
  }

}