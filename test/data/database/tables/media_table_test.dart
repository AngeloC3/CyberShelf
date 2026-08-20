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

  group('Media', () {
    test('can insert and read a media record', () async {
      final id = await database.into(database.media).insert(
        MediaCompanion.insert(
          mediaType: MediaType.game,
          createdAt: DateTime(2026, 8, 18),
          updatedAt: DateTime(2026, 8, 18),
        ),
      );

      final media = await (database.select(database.media)
        ..where((m) => m.id.equals(id)))
          .getSingle();

      expect(media.id, id);
      expect(media.mediaType, MediaType.game);
      expect(media.createdAt, DateTime(2026, 8, 18));
      expect(media.updatedAt, DateTime(2026, 8, 18));
    });
  });
}