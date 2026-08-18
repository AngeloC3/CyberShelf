import 'package:cybershelf/domain/media/theme.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Theme', () {
    test('creates with required values', () {
      const theme = Theme(
        id: 1,
        name: 'Fantasy',
      );

      expect(theme.id, 1);
      expect(theme.name, 'Fantasy');
    });

    test('copyWith replaces values', () {
      const theme = Theme(
        id: 1,
        name: 'Fantasy',
      );

      final updated = theme.copyWith(
        id: 2,
        name: 'Sci-Fi',
      );

      expect(updated.id, 2);
      expect(updated.name, 'Sci-Fi');
    });

    test('copyWith preserves values when omitted', () {
      const theme = Theme(
        id: 1,
        name: 'Fantasy',
      );

      final copied = theme.copyWith();

      expect(copied.id, 1);
      expect(copied.name, 'Fantasy');
    });
  });
}