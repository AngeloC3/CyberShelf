import 'package:flutter_test/flutter_test.dart';
import 'package:cybershelf/domain/date_only.dart';
import 'package:cybershelf/domain/media/media_metadata.dart';

void main() {
  group('MediaMetadata', () {
    test('can be created with required and optional values', () {
      final releaseDate = DateOnly(
        year: 2026,
        month: 8,
        day: 18,
      );

      const metadata = MediaMetadata(
        title: 'Test Game',
        description: 'A description.',
        coverUrl: 'https://example.com/cover.jpg',
        releaseDate: null,
      );

      final withReleaseDate = metadata.copyWith(
        releaseDate: releaseDate,
      );

      expect(metadata.title, 'Test Game');
      expect(metadata.description, 'A description.');
      expect(metadata.coverUrl, 'https://example.com/cover.jpg');
      expect(metadata.releaseDate, isNull);
      expect(withReleaseDate.releaseDate, releaseDate);
    });

    test('copyWith leaves unspecified values unchanged', () {
      final original = MediaMetadata(
        title: 'Test Game',
        description: 'Description',
        coverUrl: 'cover.jpg',
        releaseDate: DateOnly(
          year: 2026,
          month: 8,
          day: 18,
        ),
      );

      final copy = original.copyWith(
        title: 'Updated Game',
      );

      expect(copy.title, 'Updated Game');
      expect(copy.description, original.description);
      expect(copy.coverUrl, original.coverUrl);
      expect(copy.releaseDate, original.releaseDate);
    });

    test('copyWith can explicitly set nullable values to null', () {
      final original = MediaMetadata(
        title: 'Test Game',
        description: 'Description',
        coverUrl: 'cover.jpg',
        releaseDate: DateOnly(
          year: 2026,
          month: 8,
          day: 18,
        ),
      );

      final copy = original.copyWith(
        description: null,
        coverUrl: null,
        releaseDate: null,
      );

      expect(copy.title, original.title);
      expect(copy.description, null);
      expect(copy.coverUrl, null);
      expect(copy.releaseDate, null);
    });
  });
}