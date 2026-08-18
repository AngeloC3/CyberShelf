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

  group('GamePublishers', () {
    test('can assign a contributor as a game publisher', () async {
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

      await database.into(database.gamePublishers).insert(
        GamePublishersCompanion.insert(
          mediaId: mediaId,
          contributorId: contributorId,
        ),
      );

      final publisher = await (database.select(database.gamePublishers)
        ..where((p) => p.mediaId.equals(mediaId)))
          .getSingle();

      expect(publisher.mediaId, mediaId);
      expect(publisher.contributorId, contributorId);
    });

    test('allows multiple publishers for the same game', () async {
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

      final firstCompanyId = await database.into(database.companies).insert(
        CompaniesCompanion.insert(
          name: 'Valve',
        ),
      );

      final secondCompanyId = await database.into(database.companies).insert(
        CompaniesCompanion.insert(
          name: 'Nintendo',
        ),
      );

      final firstContributorId =
      await database.into(database.contributors).insert(
        ContributorsCompanion.insert(
          companyId: Value(firstCompanyId),
        ),
      );

      final secondContributorId =
      await database.into(database.contributors).insert(
        ContributorsCompanion.insert(
          companyId: Value(secondCompanyId),
        ),
      );

      await database.into(database.gamePublishers).insert(
        GamePublishersCompanion.insert(
          mediaId: mediaId,
          contributorId: firstContributorId,
        ),
      );

      await database.into(database.gamePublishers).insert(
        GamePublishersCompanion.insert(
          mediaId: mediaId,
          contributorId: secondContributorId,
        ),
      );

      final publishers = await (database.select(database.gamePublishers)
        ..where((p) => p.mediaId.equals(mediaId)))
          .get();

      expect(publishers, hasLength(2));
      expect(
        publishers.map((p) => p.contributorId),
        containsAll([
          firstContributorId,
          secondContributorId,
        ]),
      );
    });

    test('allows the same contributor to publish multiple games', () async {
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
          name: 'Nintendo',
        ),
      );

      final contributorId = await database.into(database.contributors).insert(
        ContributorsCompanion.insert(
          companyId: Value(companyId),
        ),
      );

      await database.into(database.gamePublishers).insert(
        GamePublishersCompanion.insert(
          mediaId: firstMediaId,
          contributorId: contributorId,
        ),
      );

      await database.into(database.gamePublishers).insert(
        GamePublishersCompanion.insert(
          mediaId: secondMediaId,
          contributorId: contributorId,
        ),
      );

      final relationships = await (database.select(database.gamePublishers)
        ..where((p) => p.contributorId.equals(contributorId)))
          .get();

      expect(relationships, hasLength(2));
    });

    test('does not allow duplicate publisher relationships', () async {
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

      await database.into(database.gamePublishers).insert(
        GamePublishersCompanion.insert(
          mediaId: mediaId,
          contributorId: contributorId,
        ),
      );

      expect(
            () => database.into(database.gamePublishers).insert(
          GamePublishersCompanion.insert(
            mediaId: mediaId,
            contributorId: contributorId,
          ),
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('does not allow a publisher relationship for a nonexistent game',
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
                () => database.into(database.gamePublishers).insert(
              GamePublishersCompanion.insert(
                mediaId: 999,
                contributorId: contributorId,
              ),
            ),
            throwsA(isA<Exception>()),
          );
        });

    test(
        'does not allow a publisher relationship for a nonexistent contributor',
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
                () => database.into(database.gamePublishers).insert(
              GamePublishersCompanion.insert(
                mediaId: mediaId,
                contributorId: 999,
              ),
            ),
            throwsA(isA<Exception>()),
          );
        });

    test('deleting a game removes its publisher relationships', () async {
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

      await database.into(database.gamePublishers).insert(
        GamePublishersCompanion.insert(
          mediaId: mediaId,
          contributorId: contributorId,
        ),
      );

      await (database.delete(database.media)
        ..where((m) => m.id.equals(mediaId)))
          .go();

      final relationships = await (database.select(database.gamePublishers)
        ..where((p) => p.mediaId.equals(mediaId)))
          .get();

      expect(relationships, isEmpty);
    });

    test('deleting a contributor removes its publisher relationships',
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

          await database.into(database.gamePublishers).insert(
            GamePublishersCompanion.insert(
              mediaId: mediaId,
              contributorId: contributorId,
            ),
          );

          await (database.delete(database.contributors)
            ..where((c) => c.id.equals(contributorId)))
              .go();

          final relationships = await (database.select(database.gamePublishers)
            ..where((p) => p.contributorId.equals(contributorId)))
              .get();

          expect(relationships, isEmpty);
        });
  });
}