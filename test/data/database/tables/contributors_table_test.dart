import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cybershelf/data/database/app_database.dart';

import '../test_database.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = createTestDatabase();
  });

  tearDown(() async {
    await database.close();
  });

  group('Contributors', () {
    test('can create a person contributor', () async {
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

      final contributor = await (database.select(database.contributors)
        ..where((c) => c.id.equals(contributorId)))
          .getSingle();

      expect(contributor.personId, personId);
      expect(contributor.companyId, null);
    });

    test('can create a company contributor', () async {
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

      final contributor = await (database.select(database.contributors)
        ..where((c) => c.id.equals(contributorId)))
          .getSingle();

      expect(contributor.personId, null);
      expect(contributor.companyId, companyId);
    });

    test('does not allow a contributor with both person and company',
            () async {
          final personId = await database.into(database.people).insert(
            PeopleCompanion.insert(
              name: 'Hideo Kojima',
            ),
          );

          final companyId = await database.into(database.companies).insert(
            CompaniesCompanion.insert(
              name: 'Valve',
            ),
          );

          expect(
                () => database.into(database.contributors).insert(
              ContributorsCompanion.insert(
                personId: Value(personId),
                companyId: Value(companyId),
              ),
            ),
            throwsA(isA<Exception>()),
          );
        });

    test('does not allow a contributor with neither person nor company',
            () async {
          expect(
                () => database.into(database.contributors).insert(
              ContributorsCompanion.insert(),
            ),
            throwsA(isA<Exception>()),
          );
        });

    test('does not allow a contributor referencing a nonexistent person',
            () async {
          expect(
                () => database.into(database.contributors).insert(
              ContributorsCompanion.insert(
                personId: const Value(999),
              ),
            ),
            throwsA(isA<Exception>()),
          );
        });

    test('does not allow a contributor referencing a nonexistent company',
            () async {
          expect(
                () => database.into(database.contributors).insert(
              ContributorsCompanion.insert(
                companyId: const Value(999),
              ),
            ),
            throwsA(isA<Exception>()),
          );
        });

    test('deleting a person deletes their contributor', () async {
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

      await (database.delete(database.people)
        ..where((p) => p.id.equals(personId)))
          .go();

      final contributors = await (database.select(database.contributors)
        ..where((c) => c.id.equals(contributorId)))
          .get();

      expect(contributors, isEmpty);
    });

    test('deleting a company deletes its contributor', () async {
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

      await (database.delete(database.companies)
        ..where((c) => c.id.equals(companyId)))
          .go();

      final contributors = await (database.select(database.contributors)
        ..where((c) => c.id.equals(contributorId)))
          .get();

      expect(contributors, isEmpty);
    });
  });
}