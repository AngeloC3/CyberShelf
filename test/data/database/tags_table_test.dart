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

  group('Tags', () {
    test('can insert and read a tag', () async {
      final id = await database.into(database.tags).insert(
        TagsCompanion.insert(
          name: 'Favorite',
        ),
      );

      final tag = await (database.select(database.tags)
        ..where((t) => t.id.equals(id)))
          .getSingle();

      expect(tag.id, id);
      expect(tag.name, 'Favorite');
    });

    test('does not allow duplicate tag names', () async {
      await database.into(database.tags).insert(
        TagsCompanion.insert(
          name: 'Favorite',
        ),
      );

      expect(
            () => database.into(database.tags).insert(
          TagsCompanion.insert(
            name: 'Favorite',
          ),
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}