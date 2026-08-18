import 'package:cybershelf/domain/media/genre.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Genre', () {
    test('creates with required values', () {
      const genre = Genre(
        id: 1,
        name: 'RPG',
      );

      expect(genre.id, 1);
      expect(genre.name, 'RPG');
    });

    test('copyWith replaces values', () {
      const genre = Genre(
        id: 1,
        name: 'RPG',
      );

      final updated = genre.copyWith(
        id: 2,
        name: 'Action',
      );

      expect(updated.id, 2);
      expect(updated.name, 'Action');
    });

    test('copyWith preserves values when omitted', () {
      const genre = Genre(
        id: 1,
        name: 'RPG',
      );

      final copied = genre.copyWith();

      expect(copied.id, 1);
      expect(copied.name, 'RPG');
    });
  });
}