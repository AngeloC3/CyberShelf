import 'package:flutter_test/flutter_test.dart';

import 'package:cybershelf/domain/date_only.dart';

void main() {
  group('DateOnly', () {
    test('creates a valid date', () {
      final date = DateOnly(
        year: 2026,
        month: 8,
        day: 18,
      );

      expect(date.year, 2026);
      expect(date.month, 8);
      expect(date.day, 18);
    });

    test('formats as YYYY-MM-DD', () {
      final date = DateOnly(
        year: 2026,
        month: 8,
        day: 18,
      );

      expect(date.toString(), '2026-08-18');
    });

    test('pads month and day with zeros', () {
      final date = DateOnly(
        year: 2026,
        month: 1,
        day: 5,
      );

      expect(date.toString(), '2026-01-05');
    });

    test('parses a valid string', () {
      final date = DateOnly.fromString('2026-08-18');

      expect(date.year, 2026);
      expect(date.month, 8);
      expect(date.day, 18);
    });

    test('round trips through string representation', () {
      final original = DateOnly(
        year: 2026,
        month: 8,
        day: 18,
      );

      final result = DateOnly.fromString(original.toString());

      expect(result, equals(original));
    });

    test('rejects invalid calendar dates', () {
      expect(
            () => DateOnly(
          year: 2026,
          month: 2,
          day: 30,
        ),
        throwsArgumentError,
      );
    });

    test('rejects invalid string format', () {
      expect(
            () => DateOnly.fromString('2026/08/18'),
        throwsFormatException,
      );
    });

    test('rejects non-numeric string values', () {
      expect(
            () => DateOnly.fromString('2026-XX-18'),
        throwsFormatException,
      );
    });

    test('compares dates', () {
      final earlier = DateOnly(
        year: 2026,
        month: 8,
        day: 17,
      );

      final later = DateOnly(
        year: 2026,
        month: 8,
        day: 18,
      );

      expect(earlier.isBefore(later), isTrue);
      expect(later.isAfter(earlier), isTrue);
      expect(earlier.isSameDay(later), isFalse);
    });

    test('considers identical dates equal', () {
      final first = DateOnly(
        year: 2026,
        month: 8,
        day: 18,
      );

      final second = DateOnly(
        year: 2026,
        month: 8,
        day: 18,
      );

      expect(first, equals(second));
      expect(first.hashCode, equals(second.hashCode));
    });

    test('creates a date from DateTime', () {
      final dateTime = DateTime(2026, 8, 18, 14, 30);

      final date = DateOnly.fromDateTime(dateTime);

      expect(
        date,
        equals(
          DateOnly(
            year: 2026,
            month: 8,
            day: 18,
          ),
        ),
      );
    });

    test('creates today from the current local date', () {
      final today = DateOnly.today();
      final expected = DateOnly.fromDateTime(DateTime.now());

      expect(today, equals(expected));
    });
  });
}