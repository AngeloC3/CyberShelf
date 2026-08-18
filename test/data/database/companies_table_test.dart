import 'package:flutter_test/flutter_test.dart';
import 'package:cybershelf/data/database/app_database.dart';

import 'test_database.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = createTestDatabase();
  });

  tearDown(() async {
    await database.close();
  });

  group('Companies', () {
    test('can insert and read a company', () async {
      final id = await database.into(database.companies).insert(
        CompaniesCompanion.insert(
          name: 'Valve',
        ),
      );

      final company = await (database.select(database.companies)
        ..where((c) => c.id.equals(id)))
          .getSingle();

      expect(company.id, id);
      expect(company.name, 'Valve');
    });

    test('allows companies with the same name', () async {
      final firstId = await database.into(database.companies).insert(
        CompaniesCompanion.insert(
          name: 'Acme',
        ),
      );

      final secondId = await database.into(database.companies).insert(
        CompaniesCompanion.insert(
          name: 'Acme',
        ),
      );

      expect(firstId, isNot(secondId));

      final companies = await (database.select(database.companies)
        ..where((c) => c.name.equals('Acme')))
          .get();

      expect(companies, hasLength(2));
    });
  });
}