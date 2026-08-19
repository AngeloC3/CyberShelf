// test/data/external/external_game_source_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:cybershelf/domain/date_only.dart';
import 'package:cybershelf/domain/game/external_game_source.dart';
import 'package:cybershelf/domain/game/game_mode.dart';
import 'package:cybershelf/domain/media/genre.dart';
import 'package:cybershelf/domain/media/theme.dart';

void main() {
  group('ExternalGameResult', () {
    test('can be created with required and optional values', () {
      const genres = [
        Genre(id: 1, name: 'Action'),
        Genre(id: 2, name: 'RPG'),
      ];
      const themes = [
        Theme(id: 1, name: 'Fantasy'),
      ];
      const gameModes = [GameMode.singlePlayer, GameMode.multiplayer];
      const developers = ['Valve', 'Unknown'];
      const publishers = ['Electronic Arts'];
      const series = ['Half-Life', 'Portal'];

      const result = ExternalGameResult(
        title: 'Test Game',
        genres: genres,
        themes: themes,
        gameModes: gameModes,
        developers: developers,
        publishers: publishers,
        coverUrl: 'https://example.com/cover.jpg',
        series: series,
      );

      expect(result.title, 'Test Game');
      expect(result.genres, genres);
      expect(result.themes, themes);
      expect(result.gameModes, gameModes);
      expect(result.developers, developers);
      expect(result.publishers, publishers);
      expect(result.releaseDate, isNull);
      expect(result.coverUrl, 'https://example.com/cover.jpg');
      expect(result.series, series);
    });

    test('can be created with a release date', () {
      final releaseDate = DateOnly(year: 2024, month: 11, day: 15);

      final result = ExternalGameResult(
        title: 'Test Game',
        releaseDate: releaseDate,
      );

      expect(result.releaseDate, releaseDate);
    });

    test('defaults collections to empty lists', () {
      const result = ExternalGameResult(
        title: 'Test Game',
      );

      expect(result.genres, isEmpty);
      expect(result.themes, isEmpty);
      expect(result.gameModes, isEmpty);
      expect(result.developers, isEmpty);
      expect(result.publishers, isEmpty);
      expect(result.series, isEmpty);
      expect(result.releaseDate, isNull);
      expect(result.coverUrl, isNull);
    });

    test('can be created with all optional fields filled', () {
      final releaseDate = DateOnly(year: 2024, month: 11, day: 15);
      const genres = [Genre(id: 1, name: 'Action')];
      const themes = [Theme(id: 1, name: 'Fantasy')];
      const gameModes = [GameMode.singlePlayer];
      const developers = ['Valve'];
      const publishers = ['EA'];
      const series = ['Half-Life'];

      final result = ExternalGameResult(
        title: 'Test Game',
        genres: genres,
        themes: themes,
        gameModes: gameModes,
        developers: developers,
        publishers: publishers,
        releaseDate: releaseDate,
        coverUrl: 'https://example.com/cover.jpg',
        series: series,
      );

      expect(result.title, 'Test Game');
      expect(result.genres, genres);
      expect(result.themes, themes);
      expect(result.gameModes, gameModes);
      expect(result.developers, developers);
      expect(result.publishers, publishers);
      expect(result.releaseDate, releaseDate);
      expect(result.coverUrl, 'https://example.com/cover.jpg');
      expect(result.series, series);
    });
  });
}