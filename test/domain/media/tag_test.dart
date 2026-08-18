import 'package:cybershelf/domain/media/tag.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Tag', () {
    test('creates with required values', () {
      const tag = Tag(
        id: 1,
        name: 'Backlog',
      );

      expect(tag.id, 1);
      expect(tag.name, 'Backlog');
    });

    test('copyWith replaces values', () {
      const tag = Tag(
        id: 1,
        name: 'Backlog',
      );

      final updated = tag.copyWith(
        id: 2,
        name: 'Favorites',
      );

      expect(updated.id, 2);
      expect(updated.name, 'Favorites');
    });

    test('copyWith preserves values when omitted', () {
      const tag = Tag(
        id: 1,
        name: 'Backlog',
      );

      final copied = tag.copyWith();

      expect(copied.id, 1);
      expect(copied.name, 'Backlog');
    });
  });
}