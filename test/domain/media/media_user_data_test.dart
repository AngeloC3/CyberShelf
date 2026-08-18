import 'package:flutter_test/flutter_test.dart';
import 'package:cybershelf/domain/date_only.dart';
import 'package:cybershelf/domain/media/media_user_data.dart';
import 'package:cybershelf/domain/media/tag.dart';
import 'package:cybershelf/domain/media_status.dart';

void main() {
  group('MediaUserData', () {
    test('can be created with required and optional values', () {
      final startedOn = DateOnly(
        year: 2026,
        month: 8,
        day: 1,
      );

      final finishedOn = DateOnly(
        year: 2026,
        month: 8,
        day: 18,
      );

      const tags = [
        Tag(
          id: 1,
          name: 'Backlog',
        ),
      ];

      final userData = MediaUserData(
        status: MediaStatus.completed,
        rating: 85,
        startedOn: startedOn,
        finishedOn: finishedOn,
        review: 'Great game.',
        tags: tags,
      );

      expect(userData.status, MediaStatus.completed);
      expect(userData.rating, 85);
      expect(userData.startedOn, startedOn);
      expect(userData.finishedOn, finishedOn);
      expect(userData.review, 'Great game.');
      expect(userData.tags, tags);
    });

    test('defaults tags to an empty list', () {
      const userData = MediaUserData(
        status: MediaStatus.completed,
      );

      expect(userData.tags, isEmpty);
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
        tags: const [
          Tag(
            id: 1,
            name: 'Backlog',
          ),
        ],
      );

      final copy = original.copyWith(
        rating: 90,
      );

      expect(copy.status, original.status);
      expect(copy.rating, 90);
      expect(copy.startedOn, original.startedOn);
      expect(copy.finishedOn, original.finishedOn);
      expect(copy.review, original.review);
      expect(copy.tags, original.tags);
    });

    test('copyWith can explicitly set nullable values to null', () {
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
        rating: null,
        startedOn: null,
        finishedOn: null,
        review: null,
      );

      expect(copy.status, original.status);
      expect(copy.rating, isNull);
      expect(copy.startedOn, isNull);
      expect(copy.finishedOn, isNull);
      expect(copy.review, isNull);
    });

    test('copyWith can replace tags', () {
      const original = MediaUserData(
        status: MediaStatus.completed,
        tags: [
          Tag(
            id: 1,
            name: 'Backlog',
          ),
        ],
      );

      const replacement = [
        Tag(
          id: 2,
          name: 'Favorites',
        ),
      ];

      final copy = original.copyWith(
        tags: replacement,
      );

      expect(copy.tags, replacement);
    });
  });
}