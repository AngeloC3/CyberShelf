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

  group('Themes', () {
    test('can insert and read a theme', () async {
      final id = await database.into(database.themes).insert(
        ThemesCompanion.insert(
          name: 'Fantasy',
        ),
      );

      final theme = await (database.select(database.themes)
        ..where((t) => t.id.equals(id)))
          .getSingle();

      expect(theme.id, id);
      expect(theme.name, 'Fantasy');
    });

    test('does not allow duplicate theme names', () async {
      await database.into(database.themes).insert(
        ThemesCompanion.insert(
          name: 'Fantasy',
        ),
      );

      expect(
            () => database.into(database.themes).insert(
          ThemesCompanion.insert(
            name: 'Fantasy',
          ),
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}