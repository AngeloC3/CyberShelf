import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:cybershelf/data/external/igdb_game_source.dart';
import 'package:cybershelf/domain/date_only.dart';
import 'package:cybershelf/domain/game/game_mode.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('IGDB Game Source', () {
    late MockClient mockClient;
    late IgdbGameSource source;

    setUp(() {
      mockClient = MockClient((request) async {
        // Handle token request
        if (request.url.path == '/oauth2/token') {
          return http.Response(
            jsonEncode({'access_token': 'mock-token'}),
            200,
          );
        }

        // Handle game search
        if (request.url.path == '/v4/games') {
          final body = request.body;

          // Check if it's a search query
          if (body.contains('search "Half-Life"')) {
            return http.Response(
              jsonEncode([
                {
                  'id': 1020,
                  'name': 'Half-Life',
                  'genres': [
                    {'id': 5, 'name': 'Shooter'},
                    {'id': 2, 'name': 'Adventure'},
                  ],
                  'themes': [
                    {'id': 42, 'name': 'Science fiction'},
                  ],
                  'game_modes': [
                    {'name': 'Single Player'},
                    {'name': 'Multiplayer'},
                  ],
                  'involved_companies': [
                    {
                      'company': {'name': 'Valve'},
                      'developer': true,
                      'publisher': true,
                    },
                  ],
                  'first_release_date': 946900800, // 2000-01-03 12:00:00 UTC
                  'cover': {'image_id': 'abc123'},
                  'collections': [
                    {'name': 'Half-Life Series'},
                    {'name': 'Valve Classics'},
                  ],
                },
                {
                  'id': 1021,
                  'name': 'Half-Life 2',
                  'genres': [
                    {'id': 5, 'name': 'Shooter'},
                  ],
                  'themes': [],
                  'game_modes': [
                    {'name': 'Single Player'},
                  ],
                  'involved_companies': [
                    {
                      'company': {'name': 'Valve'},
                      'developer': true,
                      'publisher': true,
                    },
                  ],
                  'first_release_date': 1105790400, // 2005-01-15 12:00:00 UTC
                  'cover': {'image_id': 'def456'},
                  'collections': [
                    {'name': 'Half-Life Series'},
                  ],
                },
                {
                  'id': 1022,
                  'name': 'Portal',
                  'genres': [
                    {'id': 5, 'name': 'Shooter'},
                    {'id': 7, 'name': 'Puzzle'},
                  ],
                  'themes': [
                    {'id': 42, 'name': 'Science fiction'},
                  ],
                  'game_modes': [
                    {'name': 'Single Player'},
                  ],
                  'involved_companies': [
                    {
                      'company': {'name': 'Valve'},
                      'developer': true,
                      'publisher': true,
                    },
                  ],
                  'first_release_date': 1170201600, // 2007-01-30 12:00:00 UTC (fixed)
                  'cover': {'image_id': 'ghi789'},
                  'collections': [
                    {'name': 'Half-Life Series'},
                    {'name': 'Portal Series'},
                  ],
                },
              ]),
              200,
            );
          }

          // Check if it's a game lookup by ID
          if (body.contains('where id = 1020')) {
            return http.Response(
              jsonEncode([
                {
                  'id': 1020,
                  'name': 'Half-Life',
                  'genres': [
                    {'id': 5, 'name': 'Shooter'},
                    {'id': 2, 'name': 'Adventure'},
                  ],
                  'themes': [
                    {'id': 42, 'name': 'Science fiction'},
                  ],
                  'game_modes': [
                    {'name': 'Single Player'},
                    {'name': 'Multiplayer'},
                  ],
                  'involved_companies': [
                    {
                      'company': {'name': 'Valve'},
                      'developer': true,
                      'publisher': true,
                    },
                  ],
                  'first_release_date': 946900800,
                  'cover': {'image_id': 'abc123'},
                  'collections': [
                    {'name': 'Half-Life Series'},
                  ],
                },
              ]),
              200,
            );
          }

          if (body.contains('where id = 999999999')) {
            return http.Response('[]', 200);
          }

          // Default empty response
          return http.Response('[]', 200);
        }

        return http.Response('Not found', 404);
      });

      source = IgdbGameSource(
        clientId: 'mock-client-id',
        clientSecret: 'mock-client-secret',
        httpClient: mockClient,
      );
    });

    test('sourceName returns "IGDB"', () {
      expect(source.sourceName, 'IGDB');
    });

    test('searchGames returns empty list for empty query', () async {
      final results = await source.searchGames('');

      expect(results, isEmpty);
    });

    test('searchGames returns empty list for whitespace-only query', () async {
      final results = await source.searchGames('   ');

      expect(results, isEmpty);
    });

    test('searchGames returns parsed results from IGDB response', () async {
      final results = await source.searchGames('Half-Life');

      expect(results, hasLength(3));

      // First result - Half-Life
      final first = results[0];
      expect(first.title, 'Half-Life');
      expect(first.genres, hasLength(2));
      expect(first.genres[0].name, 'Shooter');
      expect(first.genres[1].name, 'Adventure');
      expect(first.themes, hasLength(1));
      expect(first.themes[0].name, 'Science fiction');
      expect(first.gameModes, containsAll([
        GameMode.singlePlayer,
        GameMode.multiplayer,
      ]));
      expect(first.developers, ['Valve']);
      expect(first.publishers, ['Valve']);
      expect(first.releaseDate, DateOnly(year: 2000, month: 1, day: 3));
      expect(
        first.coverUrl,
        'https://images.igdb.com/igdb/image/upload/t_cover_big/abc123.jpg',
      );
      expect(first.series, ['Half-Life Series', 'Valve Classics']);

      // Second result - Half-Life 2
      final second = results[1];
      expect(second.title, 'Half-Life 2');
      expect(second.genres, hasLength(1));
      expect(second.genres[0].name, 'Shooter');
      expect(second.themes, isEmpty);
      expect(second.gameModes, [GameMode.singlePlayer]);
      expect(second.developers, ['Valve']);
      expect(second.publishers, ['Valve']);
      expect(second.releaseDate, DateOnly(year: 2005, month: 1, day: 15));
      expect(
        second.coverUrl,
        'https://images.igdb.com/igdb/image/upload/t_cover_big/def456.jpg',
      );
      expect(second.series, ['Half-Life Series']);

      // Third result - Portal (has multiple series)
      final third = results[2];
      expect(third.title, 'Portal');
      expect(third.genres, hasLength(2));
      expect(third.genres[0].name, 'Shooter');
      expect(third.genres[1].name, 'Puzzle');
      expect(third.themes, hasLength(1));
      expect(third.themes[0].name, 'Science fiction');
      expect(third.gameModes, [GameMode.singlePlayer]);
      expect(third.developers, ['Valve']);
      expect(third.publishers, ['Valve']);
      expect(third.releaseDate, DateOnly(year: 2007, month: 1, day: 30));
      expect(
        third.coverUrl,
        'https://images.igdb.com/igdb/image/upload/t_cover_big/ghi789.jpg',
      );
      expect(third.series, ['Half-Life Series', 'Portal Series']);
    });

    test('searchGames handles games with missing optional fields', () async {
      // Override mock for this test
      final emptyMockClient = MockClient((request) async {
        if (request.url.path == '/oauth2/token') {
          return http.Response(
            jsonEncode({'access_token': 'mock-token'}),
            200,
          );
        }

        if (request.url.path == '/v4/games') {
          return http.Response(
            jsonEncode([
              {
                'id': 9999,
                'name': 'Minimal Game',
                // No genres, themes, game_modes, involved_companies, collections, etc.
              },
            ]),
            200,
          );
        }

        return http.Response('Not found', 404);
      });

      final minimalSource = IgdbGameSource(
        clientId: 'mock-client-id',
        clientSecret: 'mock-client-secret',
        httpClient: emptyMockClient,
      );

      final results = await minimalSource.searchGames('Minimal');

      expect(results, hasLength(1));
      expect(results[0].title, 'Minimal Game');
      expect(results[0].genres, isEmpty);
      expect(results[0].themes, isEmpty);
      expect(results[0].gameModes, isEmpty);
      expect(results[0].developers, isEmpty);
      expect(results[0].publishers, isEmpty);
      expect(results[0].releaseDate, isNull);
      expect(results[0].coverUrl, isNull);
      expect(results[0].series, isEmpty);
    });

    test('searchGames handles games with no collections', () async {
      // Override mock for this test
      final noCollectionsClient = MockClient((request) async {
        if (request.url.path == '/oauth2/token') {
          return http.Response(
            jsonEncode({'access_token': 'mock-token'}),
            200,
          );
        }

        if (request.url.path == '/v4/games') {
          return http.Response(
            jsonEncode([
              {
                'id': 9999,
                'name': 'No Series Game',
                'genres': [
                  {'id': 5, 'name': 'Shooter'},
                ],
                // No collections field
              },
            ]),
            200,
          );
        }

        return http.Response('Not found', 404);
      });

      final noCollectionsSource = IgdbGameSource(
        clientId: 'mock-client-id',
        clientSecret: 'mock-client-secret',
        httpClient: noCollectionsClient,
      );

      final results = await noCollectionsSource.searchGames('No Series');

      expect(results, hasLength(1));
      expect(results[0].title, 'No Series Game');
      expect(results[0].series, isEmpty);
    });

    test('getGameById returns a game for valid ID', () async {
      final result = await source.getGameById('1020');

      expect(result, isNotNull);
      expect(result!.title, 'Half-Life');
      expect(result.genres, hasLength(2));
      expect(result.genres[0].name, 'Shooter');
      expect(result.themes, hasLength(1));
      expect(result.themes[0].name, 'Science fiction');
      expect(result.gameModes, containsAll([
        GameMode.singlePlayer,
        GameMode.multiplayer,
      ]));
      expect(result.developers, ['Valve']);
      expect(result.publishers, ['Valve']);
      expect(result.releaseDate, DateOnly(year: 2000, month: 1, day: 3));
      expect(
        result.coverUrl,
        'https://images.igdb.com/igdb/image/upload/t_cover_big/abc123.jpg',
      );
      expect(result.series, ['Half-Life Series']);
    });

    test('getGameById returns null for invalid ID', () async {
      final result = await source.getGameById('999999999');

      expect(result, isNull);
    });

    test('searchGames throws exception on authentication failure', () async {
      final authFailClient = MockClient((request) async {
        if (request.url.path == '/oauth2/token') {
          return http.Response(
            jsonEncode({'error': 'invalid_client'}),
            401,
          );
        }
        return http.Response('Not found', 404);
      });

      final authFailSource = IgdbGameSource(
        clientId: 'invalid',
        clientSecret: 'invalid',
        httpClient: authFailClient,
      );

      expect(
            () => authFailSource.searchGames('Half-Life'),
        throwsA(
          isA<Exception>().having(
                (e) => e.toString(),
            'message',
            contains('authentication failed'),
          ),
        ),
      );
    });

    test('searchGames throws exception on HTTP error', () async {
      final errorClient = MockClient((request) async {
        if (request.url.path == '/oauth2/token') {
          return http.Response(
            jsonEncode({'access_token': 'mock-token'}),
            200,
          );
        }

        if (request.url.path == '/v4/games') {
          return http.Response('Service Unavailable', 503);
        }

        return http.Response('Not found', 404);
      });

      final errorSource = IgdbGameSource(
        clientId: 'mock-client-id',
        clientSecret: 'mock-client-secret',
        httpClient: errorClient,
      );

      expect(
            () => errorSource.searchGames('Half-Life'),
        throwsA(
          isA<Exception>().having(
                (e) => e.toString(),
            'message',
            contains('failed: 503'),
          ),
        ),
      );
    });

    test('getGameById throws exception on authentication failure', () async {
      final authFailClient = MockClient((request) async {
        if (request.url.path == '/oauth2/token') {
          return http.Response(
            jsonEncode({'error': 'invalid_client'}),
            401,
          );
        }
        return http.Response('Not found', 404);
      });

      final authFailSource = IgdbGameSource(
        clientId: 'invalid',
        clientSecret: 'invalid',
        httpClient: authFailClient,
      );

      expect(
            () => authFailSource.getGameById('1020'),
        throwsA(
          isA<Exception>().having(
                (e) => e.toString(),
            'message',
            contains('authentication failed'),
          ),
        ),
      );
    });

    test('getGameById throws exception on HTTP error', () async {
      final errorClient = MockClient((request) async {
        if (request.url.path == '/oauth2/token') {
          return http.Response(
            jsonEncode({'access_token': 'mock-token'}),
            200,
          );
        }

        if (request.url.path == '/v4/games') {
          return http.Response('Service Unavailable', 503);
        }

        return http.Response('Not found', 404);
      });

      final errorSource = IgdbGameSource(
        clientId: 'mock-client-id',
        clientSecret: 'mock-client-secret',
        httpClient: errorClient,
      );

      expect(
            () => errorSource.getGameById('1020'),
        throwsA(
          isA<Exception>().having(
                (e) => e.toString(),
            'message',
            contains('failed: 503'),
          ),
        ),
      );
    });

    test('reuses access token for multiple requests', () async {
      var tokenRequestCount = 0;

      final tokenTrackingClient = MockClient((request) async {
        if (request.url.path == '/oauth2/token') {
          tokenRequestCount++;
          return http.Response(
            jsonEncode({'access_token': 'mock-token'}),
            200,
          );
        }

        if (request.url.path == '/v4/games') {
          return http.Response(
            jsonEncode([
              {
                'id': 1020,
                'name': 'Half-Life',
              },
            ]),
            200,
          );
        }

        return http.Response('Not found', 404);
      });

      final trackingSource = IgdbGameSource(
        clientId: 'mock-client-id',
        clientSecret: 'mock-client-secret',
        httpClient: tokenTrackingClient,
      );

      await trackingSource.searchGames('Half-Life');
      await trackingSource.searchGames('Portal');
      await trackingSource.getGameById('1020');

      // Token should only be requested once
      expect(tokenRequestCount, 1);
    });
  });
}