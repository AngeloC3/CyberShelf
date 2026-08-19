// lib/application/game/game_service.dart
import 'package:drift/drift.dart'; // Add this import for Value
import 'package:cybershelf/data/database/app_database.dart';
import 'package:cybershelf/data/database/database_provider.dart';
import 'package:cybershelf/domain/game/external_game_source.dart';
import 'package:cybershelf/domain/game/game_item.dart';
import 'package:cybershelf/domain/game/game_metadata.dart';
import 'package:cybershelf/domain/game/game_repository.dart';
import 'package:cybershelf/domain/game/game_user_data.dart';
import 'package:cybershelf/domain/media/contributor.dart' as domain;
import 'package:cybershelf/domain/media/genre.dart' as domain;
import 'package:cybershelf/domain/media/media_metadata.dart';
import 'package:cybershelf/domain/media/media_user_data.dart';
import 'package:cybershelf/domain/media/tag.dart' as domain;
import 'package:cybershelf/domain/media/theme.dart' as domain;
import 'package:cybershelf/domain/media_status.dart';

class GameService {
  GameService(
      this._repository, {
        this._database,
      });

  final GameRepository _repository;
  final AppDatabase? _database;

  Future<AppDatabase> _getDatabase() async {
    if (_database != null) return _database;
    return await createDatabase();
  }

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
    final database = await _getDatabase();

    // Resolve genres
    final genreIds = <int>[];
    for (final genre in result.genres) {
      final existingGenre = await (database.select(database.genres)
        ..where((g) => g.name.equals(genre.name)))
          .getSingleOrNull();

      int genreId;
      if (existingGenre != null) {
        genreId = existingGenre.id;
      } else {
        genreId = await database.into(database.genres).insert(
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
      final existingTheme = await (database.select(database.themes)
        ..where((t) => t.name.equals(theme.name)))
          .getSingleOrNull();

      int themeId;
      if (existingTheme != null) {
        themeId = existingTheme.id;
      } else {
        themeId = await database.into(database.themes).insert(
          ThemesCompanion.insert(
            name: theme.name,
          ),
        );
      }
      themeIds.add(themeId);
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

    // Build the media metadata
    final metadata = MediaMetadata(
      title: result.title,
      coverUrl: result.coverUrl,
      releaseDate: result.releaseDate,
      genres: domainGenres,
      themes: domainThemes,
    );

    // Resolve developers and publishers from the external result
    final gameMetadata = await _resolveDeveloperAndPublisherNames(
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

  // ============================================================
  // Private Helpers
  // ============================================================

  Future<List<domain.Tag>> _resolveTags(List<domain.Tag> tags) async {
    if (tags.isEmpty) return [];

    final database = await _getDatabase();
    final resolvedTags = <domain.Tag>[];

    for (final tag in tags) {
      if (tag.id > 0) {
        final existingTag = await (database.select(database.tags)
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

      final existingTag = await (database.select(database.tags)
        ..where((t) => t.name.equals(tag.name)))
          .getSingleOrNull();

      if (existingTag != null) {
        resolvedTags.add(domain.Tag(
          id: existingTag.id,
          name: existingTag.name,
        ));
      } else {
        final newId = await database.into(database.tags).insert(
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
    final database = await _getDatabase();

    // Resolve developers
    final resolvedDevelopers = <domain.Contributor>[];
    for (final contributor in gameMetadata.developers) {
      final resolved = await _resolveContributor(database, contributor);
      if (resolved != null) {
        resolvedDevelopers.add(resolved);
      }
    }

    // Resolve publishers
    final resolvedPublishers = <domain.Contributor>[];
    for (final contributor in gameMetadata.publishers) {
      final resolved = await _resolveContributor(database, contributor);
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
      AppDatabase database,
      domain.Contributor contributor,
      ) async {
    // If it has a valid ID, try to find it
    if (contributor.id > 0) {
      final existing = await (database.select(database.contributors)
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
      final existingPerson = await (database.select(database.people)
        ..where((p) => p.id.equals(contributor.personId!)))
          .getSingleOrNull();

      if (existingPerson != null) {
        // Check if contributor already exists for this person
        final existingContributor = await (database.select(database.contributors)
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
        final newId = await database.into(database.contributors).insert(
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
      final existingCompany = await (database.select(database.companies)
        ..where((c) => c.id.equals(contributor.companyId!)))
          .getSingleOrNull();

      if (existingCompany != null) {
        final existingContributor = await (database.select(database.contributors)
          ..where((c) => c.companyId.equals(existingCompany.id)))
            .getSingleOrNull();

        if (existingContributor != null) {
          return domain.Contributor(
            id: existingContributor.id,
            personId: existingContributor.personId,
            companyId: existingContributor.companyId,
          );
        }

        final newId = await database.into(database.contributors).insert(
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
      List<String> developerNames,
      List<String> publisherNames,
      ) async {
    final database = await _getDatabase();

    // Resolve developers from names
    final developers = <domain.Contributor>[];
    for (final name in developerNames) {
      final contributor = await _resolveContributorByName(database, name, isPerson: true);
      if (contributor != null) {
        developers.add(contributor);
      }
    }

    // Resolve publishers from names
    final publishers = <domain.Contributor>[];
    for (final name in publisherNames) {
      final contributor = await _resolveContributorByName(database, name, isPerson: false);
      if (contributor != null) {
        publishers.add(contributor);
      }
    }

    return GameMetadata(
      availableModes: const [],
      developers: developers,
      publishers: publishers,
    );
  }

  Future<domain.Contributor?> _resolveContributorByName(
      AppDatabase database,
      String name, {
        required bool isPerson,
      }) async {
    if (name.trim().isEmpty) return null;

    if (isPerson) {
      // Try to find existing person
      final existingPerson = await (database.select(database.people)
        ..where((p) => p.name.equals(name)))
          .getSingleOrNull();

      int personId;
      if (existingPerson != null) {
        personId = existingPerson.id;
      } else {
        personId = await database.into(database.people).insert(
          PeopleCompanion.insert(name: name),
        );
      }

      // Check if contributor already exists for this person
      final existingContributor = await (database.select(database.contributors)
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
      final contributorId = await database.into(database.contributors).insert(
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
      final existingCompany = await (database.select(database.companies)
        ..where((c) => c.name.equals(name)))
          .getSingleOrNull();

      int companyId;
      if (existingCompany != null) {
        companyId = existingCompany.id;
      } else {
        companyId = await database.into(database.companies).insert(
          CompaniesCompanion.insert(name: name),
        );
      }

      // Check if contributor already exists for this company
      final existingContributor = await (database.select(database.contributors)
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
      final contributorId = await database.into(database.contributors).insert(
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
}