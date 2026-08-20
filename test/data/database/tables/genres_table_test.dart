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

  group('Genres', () {
    test('can insert and read a genre', () async {
      final id = await database.into(database.genres).insert(
        GenresCompanion.insert(
          name: 'RPG',
        ),
      );

      final genre = await (database.select(database.genres)
            ..where((g) => g.id.equals(id)))
          .getSingle();

      expect(genre.id, id);
      expect(genre.name, 'RPG');
    });

    test('does not allow duplicate genre names', () async {
      await database.into(database.genres).insert(
        GenresCompanion.insert(
          name: 'RPG',
        ),
      );

      expect(
        () => database.into(database.genres).insert(
          GenresCompanion.insert(
            name: 'RPG',
          ),
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}
