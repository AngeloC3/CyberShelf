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

  group('Series', () {
    test('can insert and read a series', () async {
      final id = await database.into(database.series).insert(
        SeriesCompanion.insert(
          name: 'Half-Life Series',
        ),
      );

      final series = await (database.select(database.series)
        ..where((s) => s.id.equals(id)))
          .getSingle();

      expect(series.id, id);
      expect(series.name, 'Half-Life Series');
    });

    test('does not allow duplicate series names', () async {
      await database.into(database.series).insert(
        SeriesCompanion.insert(
          name: 'Half-Life Series',
        ),
      );

      expect(
            () => database.into(database.series).insert(
          SeriesCompanion.insert(
            name: 'Half-Life Series',
          ),
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('allows series with different names', () async {
      final firstId = await database.into(database.series).insert(
        SeriesCompanion.insert(
          name: 'Half-Life Series',
        ),
      );

      final secondId = await database.into(database.series).insert(
        SeriesCompanion.insert(
          name: 'Portal Series',
        ),
      );

      expect(firstId, isNot(secondId));

      final series = await database.select(database.series).get();
      expect(series, hasLength(2));
      expect(series.map((s) => s.name), containsAll(['Half-Life Series', 'Portal Series']));
    });

    test('auto-increments id', () async {
      final firstId = await database.into(database.series).insert(
        SeriesCompanion.insert(
          name: 'Half-Life Series',
        ),
      );

      final secondId = await database.into(database.series).insert(
        SeriesCompanion.insert(
          name: 'Portal Series',
        ),
      );

      expect(secondId, greaterThan(firstId));
    });
  });
}