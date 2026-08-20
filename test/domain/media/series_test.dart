import 'package:flutter_test/flutter_test.dart';
import 'package:cybershelf/domain/media/series.dart';

void main() {
  group('Series', () {
    test('creates with required values', () {
      const series = Series(
        id: 1,
        name: 'Half-Life Series',
      );

      expect(series.id, 1);
      expect(series.name, 'Half-Life Series');
    });

    test('copyWith replaces values', () {
      const series = Series(
        id: 1,
        name: 'Half-Life Series',
      );

      final updated = series.copyWith(
        id: 2,
        name: 'Portal Series',
      );

      expect(updated.id, 2);
      expect(updated.name, 'Portal Series');
    });

    test('copyWith preserves values when omitted', () {
      const series = Series(
        id: 1,
        name: 'Half-Life Series',
      );

      final copied = series.copyWith();

      expect(copied.id, 1);
      expect(copied.name, 'Half-Life Series');
    });

    test('equality - same values are equal', () {
      const series1 = Series(
        id: 1,
        name: 'Half-Life Series',
      );

      const series2 = Series(
        id: 1,
        name: 'Half-Life Series',
      );

      expect(series1, equals(series2));
      expect(series1.hashCode, equals(series2.hashCode));
    });

    test('equality - different ids are not equal', () {
      const series1 = Series(
        id: 1,
        name: 'Half-Life Series',
      );

      const series2 = Series(
        id: 2,
        name: 'Half-Life Series',
      );

      expect(series1, isNot(equals(series2)));
    });

    test('equality - different names are not equal', () {
      const series1 = Series(
        id: 1,
        name: 'Half-Life Series',
      );

      const series2 = Series(
        id: 1,
        name: 'Portal Series',
      );

      expect(series1, isNot(equals(series2)));
    });

    test('toString returns formatted string', () {
      const series = Series(
        id: 1,
        name: 'Half-Life Series',
      );

      expect(series.toString(), 'Series(id: 1, name: Half-Life Series)');
    });
  });
}