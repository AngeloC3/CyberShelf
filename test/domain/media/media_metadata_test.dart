import 'package:flutter_test/flutter_test.dart';
import 'package:cybershelf/domain/date_only.dart';
import 'package:cybershelf/domain/media/external_id.dart';
import 'package:cybershelf/domain/media/genre.dart';
import 'package:cybershelf/domain/media/media_metadata.dart';
import 'package:cybershelf/domain/media/theme.dart';

void main() {
  group('MediaMetadata', () {
    test('can be created with required and optional values', () {
      final releaseDate = DateOnly(
        year: 2026,
        month: 8,
        day: 18,
      );

      const genres = [
        Genre(
          id: 1,
          name: 'RPG',
        ),
      ];

      const themes = [
        Theme(
          id: 1,
          name: 'Fantasy',
        ),
      ];

      const externalIds = [
        ExternalId(
          source: 'igdb',
          value: '12345',
        ),
      ];

      final metadata = MediaMetadata(
        title: 'Test Game',
        description: 'A description.',
        coverUrl: 'https://example.com/cover.jpg',
        releaseDate: releaseDate,
        genres: genres,
        themes: themes,
        externalIds: externalIds,
      );

      expect(metadata.title, 'Test Game');
      expect(metadata.description, 'A description.');
      expect(metadata.coverUrl, 'https://example.com/cover.jpg');
      expect(metadata.releaseDate, releaseDate);
      expect(metadata.genres, genres);
      expect(metadata.themes, themes);
      expect(metadata.externalIds, externalIds);
    });

    test('defaults collections to empty lists', () {
      const metadata = MediaMetadata(
        title: 'Test Game',
      );

      expect(metadata.genres, isEmpty);
      expect(metadata.themes, isEmpty);
      expect(metadata.externalIds, isEmpty);
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
        genres: const [
          Genre(
            id: 1,
            name: 'RPG',
          ),
        ],
        themes: const [
          Theme(
            id: 1,
            name: 'Fantasy',
          ),
        ],
        externalIds: const [
          ExternalId(
            source: 'igdb',
            value: '12345',
          ),
        ],
      );

      final copy = original.copyWith(
        title: 'Updated Game',
      );

      expect(copy.title, 'Updated Game');
      expect(copy.description, original.description);
      expect(copy.coverUrl, original.coverUrl);
      expect(copy.releaseDate, original.releaseDate);
      expect(copy.genres, original.genres);
      expect(copy.themes, original.themes);
      expect(copy.externalIds, original.externalIds);
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
      expect(copy.description, isNull);
      expect(copy.coverUrl, isNull);
      expect(copy.releaseDate, isNull);
      expect(copy.genres, original.genres);
      expect(copy.themes, original.themes);
      expect(copy.externalIds, original.externalIds);
    });

    test('copyWith can replace genres', () {
      const original = MediaMetadata(
        title: 'Test Game',
        genres: [
          Genre(
            id: 1,
            name: 'RPG',
          ),
        ],
      );

      const replacement = [
        Genre(
          id: 2,
          name: 'Action',
        ),
      ];

      final copy = original.copyWith(
        genres: replacement,
      );

      expect(copy.genres, replacement);
    });

    test('copyWith can replace themes', () {
      const original = MediaMetadata(
        title: 'Test Game',
        themes: [
          Theme(
            id: 1,
            name: 'Fantasy',
          ),
        ],
      );

      const replacement = [
        Theme(
          id: 2,
          name: 'Sci-Fi',
        ),
      ];

      final copy = original.copyWith(
        themes: replacement,
      );

      expect(copy.themes, replacement);
    });

    test('copyWith can replace external IDs', () {
      const original = MediaMetadata(
        title: 'Test Game',
        externalIds: [
          ExternalId(
            source: 'igdb',
            value: '12345',
          ),
        ],
      );

      const replacement = [
        ExternalId(
          source: 'tmdb',
          value: '67890',
        ),
      ];

      final copy = original.copyWith(
        externalIds: replacement,
      );

      expect(copy.externalIds, replacement);
    });
  });
}