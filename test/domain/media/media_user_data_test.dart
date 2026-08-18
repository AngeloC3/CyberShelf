import 'package:flutter_test/flutter_test.dart';
import 'package:cybershelf/domain/date_only.dart';
import 'package:cybershelf/domain/media/media_user_data.dart';
import 'package:cybershelf/domain/media_status.dart';

void main() {
  group('MediaUserData', () {
    test('can be created with required and optional values', () {
      final startedOn = DateOnly(
        year: 2026,
        month: 8,
        day: 1,
      );

      final userData = MediaUserData(
        status: MediaStatus.completed,
        rating: 85,
        startedOn: startedOn,
        finishedOn: null,
        review: 'Great game.',
      );

      expect(userData.status, MediaStatus.completed);
      expect(userData.rating, 85);
      expect(userData.startedOn, startedOn);
      expect(userData.finishedOn, null);
      expect(userData.review, 'Great game.');
    });

    test('copyWith leaves unspecified values unchanged', () {
      final original = MediaUserData(
        status: MediaStatus.completed,
        rating: 85,
        startedOn: DateOnly(
          year: 2026,
          month: 8,
          day: 1,
        ),
        finishedOn: DateOnly(
          year: 2026,
          month: 8,
          day: 18,
        ),
        review: 'Great game.',
      );

      final copy = original.copyWith(
        rating: 90,
      );

      expect(copy.status, original.status);
      expect(copy.rating, 90);
      expect(copy.startedOn, original.startedOn);
      expect(copy.finishedOn, original.finishedOn);
      expect(copy.review, original.review);
    });

    test('copyWith can explicitly set nullable values to null', () {
      final original = MediaUserData(
        status: MediaStatus.completed,
        rating: 85,
        startedOn: DateOnly(
          year: 2026,
          month: 8,
          day: 18,
        ),
        finishedOn: DateOnly(
          year: 2026,
          month: 8,
          day: 18,
        ),
        review: 'Great game.',
      );

      final copy = original.copyWith(
        rating: null,
        startedOn: null,
        finishedOn: null,
        review: null,
      );

      expect(copy.status, original.status);
      expect(copy.rating, null);
      expect(copy.startedOn, null);
      expect(copy.finishedOn, null);
      expect(copy.review, null);
    });
  });
}