import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cybershelf/data/database/app_database.dart';
import 'package:cybershelf/domain/media_type.dart';

import '../../test_database.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = createTestDatabase();
  });

  tearDown(() async {
    await database.close();
  });

  group('GameDevelopers', () {
    test('can assign a contributor as a game developer', () async {
      final mediaId = await database.into(database.media).insert(
        MediaCompanion.insert(
          mediaType: MediaType.game,
          createdAt: DateTime(2026, 8, 18),
          updatedAt: DateTime(2026, 8, 18),
        ),
      );

      await database.into(database.games).insert(
        GamesCompanion.insert(
          mediaId: Value(mediaId),
        ),
      );

      final personId = await database.into(database.people).insert(
        PeopleCompanion.insert(
          name: 'Hideo Kojima',
        ),
      );

      final contributorId = await database.into(database.contributors).insert(
        ContributorsCompanion.insert(
          personId: Value(personId),
        ),
      );

      await database.into(database.gameDevelopers).insert(
        GameDevelopersCompanion.insert(
          mediaId: mediaId,
          contributorId: contributorId,
        ),
      );

      final developer = await (database.select(database.gameDevelopers)
        ..where((d) => d.mediaId.equals(mediaId)))
          .getSingle();

      expect(developer.mediaId, mediaId);
      expect(developer.contributorId, contributorId);
    });

    test('allows multiple developers for the same game', () async {
      final mediaId = await database.into(database.media).insert(
        MediaCompanion.insert(
          mediaType: MediaType.game,
          createdAt: DateTime(2026, 8, 18),
          updatedAt: DateTime(2026, 8, 18),
        ),
      );

      await database.into(database.games).insert(
        GamesCompanion.insert(
          mediaId: Value(mediaId),
        ),
      );

      final personId = await database.into(database.people).insert(
        PeopleCompanion.insert(
          name: 'Hideo Kojima',
        ),
      );

      final companyId = await database.into(database.companies).insert(
        CompaniesCompanion.insert(
          name: 'Konami',
        ),
      );

      final personContributorId =
      await database.into(database.contributors).insert(
        ContributorsCompanion.insert(
          personId: Value(personId),
        ),
      );

      final companyContributorId =
      await database.into(database.contributors).insert(
        ContributorsCompanion.insert(
          companyId: Value(companyId),
        ),
      );

      await database.into(database.gameDevelopers).insert(
        GameDevelopersCompanion.insert(
          mediaId: mediaId,
          contributorId: personContributorId,
        ),
      );

      await database.into(database.gameDevelopers).insert(
        GameDevelopersCompanion.insert(
          mediaId: mediaId,
          contributorId: companyContributorId,
        ),
      );

      final developers = await (database.select(database.gameDevelopers)
        ..where((d) => d.mediaId.equals(mediaId)))
          .get();

      expect(developers, hasLength(2));
      expect(
        developers.map((d) => d.contributorId),
        containsAll([
          personContributorId,
          companyContributorId,
        ]),
      );
    });

    test('allows the same contributor to develop multiple games', () async {
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

      await database.into(database.games).insert(
        GamesCompanion.insert(
          mediaId: Value(firstMediaId),
        ),
      );

      await database.into(database.games).insert(
        GamesCompanion.insert(
          mediaId: Value(secondMediaId),
        ),
      );

      final companyId = await database.into(database.companies).insert(
        CompaniesCompanion.insert(
          name: 'Valve',
        ),
      );

      final contributorId = await database.into(database.contributors).insert(
        ContributorsCompanion.insert(
          companyId: Value(companyId),
        ),
      );

      await database.into(database.gameDevelopers).insert(
        GameDevelopersCompanion.insert(
          mediaId: firstMediaId,
          contributorId: contributorId,
        ),
      );

      await database.into(database.gameDevelopers).insert(
        GameDevelopersCompanion.insert(
          mediaId: secondMediaId,
          contributorId: contributorId,
        ),
      );

      final relationships = await (database.select(database.gameDevelopers)
        ..where((d) => d.contributorId.equals(contributorId)))
          .get();

      expect(relationships, hasLength(2));
    });

    test('does not allow duplicate developer relationships', () async {
      final mediaId = await database.into(database.media).insert(
        MediaCompanion.insert(
          mediaType: MediaType.game,
          createdAt: DateTime(2026, 8, 18),
          updatedAt: DateTime(2026, 8, 18),
        ),
      );

      await database.into(database.games).insert(
        GamesCompanion.insert(
          mediaId: Value(mediaId),
        ),
      );

      final companyId = await database.into(database.companies).insert(
        CompaniesCompanion.insert(
          name: 'Valve',
        ),
      );

      final contributorId = await database.into(database.contributors).insert(
        ContributorsCompanion.insert(
          companyId: Value(companyId),
        ),
      );

      await database.into(database.gameDevelopers).insert(
        GameDevelopersCompanion.insert(
          mediaId: mediaId,
          contributorId: contributorId,
        ),
      );

      expect(
            () => database.into(database.gameDevelopers).insert(
          GameDevelopersCompanion.insert(
            mediaId: mediaId,
            contributorId: contributorId,
          ),
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('does not allow a developer relationship for a nonexistent game',
            () async {
          final companyId = await database.into(database.companies).insert(
            CompaniesCompanion.insert(
              name: 'Valve',
            ),
          );

          final contributorId = await database.into(database.contributors).insert(
            ContributorsCompanion.insert(
              companyId: Value(companyId),
            ),
          );

          expect(
                () => database.into(database.gameDevelopers).insert(
              GameDevelopersCompanion.insert(
                mediaId: 999,
                contributorId: contributorId,
              ),
            ),
            throwsA(isA<Exception>()),
          );
        });

    test(
        'does not allow a developer relationship for a nonexistent contributor',
            () async {
          final mediaId = await database.into(database.media).insert(
            MediaCompanion.insert(
              mediaType: MediaType.game,
              createdAt: DateTime(2026, 8, 18),
              updatedAt: DateTime(2026, 8, 18),
            ),
          );

          await database.into(database.games).insert(
            GamesCompanion.insert(
              mediaId: Value(mediaId),
            ),
          );

          expect(
                () => database.into(database.gameDevelopers).insert(
              GameDevelopersCompanion.insert(
                mediaId: mediaId,
                contributorId: 999,
              ),
            ),
            throwsA(isA<Exception>()),
          );
        });

    test('deleting a game removes its developer relationships', () async {
      final mediaId = await database.into(database.media).insert(
        MediaCompanion.insert(
          mediaType: MediaType.game,
          createdAt: DateTime(2026, 8, 18),
          updatedAt: DateTime(2026, 8, 18),
        ),
      );

      await database.into(database.games).insert(
        GamesCompanion.insert(
          mediaId: Value(mediaId),
        ),
      );

      final companyId = await database.into(database.companies).insert(
        CompaniesCompanion.insert(
          name: 'Valve',
        ),
      );

      final contributorId = await database.into(database.contributors).insert(
        ContributorsCompanion.insert(
          companyId: Value(companyId),
        ),
      );

      await database.into(database.gameDevelopers).insert(
        GameDevelopersCompanion.insert(
          mediaId: mediaId,
          contributorId: contributorId,
        ),
      );

      await (database.delete(database.media)
        ..where((m) => m.id.equals(mediaId)))
          .go();

      final relationships = await (database.select(database.gameDevelopers)
        ..where((d) => d.mediaId.equals(mediaId)))
          .get();

      expect(relationships, isEmpty);
    });

    test('deleting a contributor removes its developer relationships',
            () async {
          final mediaId = await database.into(database.media).insert(
            MediaCompanion.insert(
              mediaType: MediaType.game,
              createdAt: DateTime(2026, 8, 18),
              updatedAt: DateTime(2026, 8, 18),
            ),
          );

          await database.into(database.games).insert(
            GamesCompanion.insert(
              mediaId: Value(mediaId),
            ),
          );

          final companyId = await database.into(database.companies).insert(
            CompaniesCompanion.insert(
              name: 'Valve',
            ),
          );

          final contributorId = await database.into(database.contributors).insert(
            ContributorsCompanion.insert(
              companyId: Value(companyId),
            ),
          );

          await database.into(database.gameDevelopers).insert(
            GameDevelopersCompanion.insert(
              mediaId: mediaId,
              contributorId: contributorId,
            ),
          );

          await (database.delete(database.contributors)
            ..where((c) => c.id.equals(contributorId)))
              .go();

          final relationships = await (database.select(database.gameDevelopers)
            ..where((d) => d.contributorId.equals(contributorId)))
              .get();

          expect(relationships, isEmpty);
        });
  });
}