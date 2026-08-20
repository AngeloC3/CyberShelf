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

  group('People', () {
    test('can insert and read a person', () async {
      final id = await database.into(database.people).insert(
        PeopleCompanion.insert(
          name: 'Hideo Kojima',
        ),
      );

      final person = await (database.select(database.people)
        ..where((p) => p.id.equals(id)))
          .getSingle();

      expect(person.id, id);
      expect(person.name, 'Hideo Kojima');
    });

    test('allows people with the same name', () async {
      final firstId = await database.into(database.people).insert(
        PeopleCompanion.insert(
          name: 'John Smith',
        ),
      );

      final secondId = await database.into(database.people).insert(
        PeopleCompanion.insert(
          name: 'John Smith',
        ),
      );

      expect(firstId, isNot(secondId));

      final people = await (database.select(database.people)
        ..where((p) => p.name.equals('John Smith')))
          .get();

      expect(people, hasLength(2));
    });
  });
}