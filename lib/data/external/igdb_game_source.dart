// lib/data/external/igdb_game_source.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cybershelf/domain/date_only.dart';
import 'package:cybershelf/domain/game/external_game_source.dart';
import 'package:cybershelf/domain/game/game_mode.dart';
import 'package:cybershelf/domain/media/genre.dart';
import 'package:cybershelf/domain/media/theme.dart';

class IgdbGameSource implements ExternalGameSource {
  IgdbGameSource({
    required this.clientId,
    required this.clientSecret,
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  final String clientId;
  final String clientSecret;
  final http.Client _httpClient;
  String? _accessToken;

  @override
  String get sourceName => 'IGDB';

  @override
  Future<List<ExternalGameResult>> searchGames(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }

    final token = await _getAccessToken();
    if (token == null) {
      throw Exception('IGDB authentication failed. Check your Client ID/Secret.');
    }

    final response = await _httpClient.post(
      Uri.parse('https://api.igdb.com/v4/games'),
      headers: {
        'Client-ID': clientId,
        'Authorization': 'Bearer $token',
        'Content-Type': 'text/plain',
      },
      body: '''
        search "$query";
        fields
          name,
          genres.name,
          themes.name,
          game_modes.name,
          involved_companies.company.name,
          involved_companies.developer,
          involved_companies.publisher,
          first_release_date,
          cover.image_id,
          collections.name;
        limit 10;
      ''',
    );

    if (response.statusCode != 200) {
      throw Exception('IGDB search failed: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as List;
    return data.map((game) => _mapToResult(game)).toList();
  }

  @override
  Future<ExternalGameResult?> getGameById(String id) async {
    final token = await _getAccessToken();
    if (token == null) {
      throw Exception('IGDB authentication failed. Check your Client ID/Secret.');
    }

    final response = await _httpClient.post(
      Uri.parse('https://api.igdb.com/v4/games'),
      headers: {
        'Client-ID': clientId,
        'Authorization': 'Bearer $token',
        'Content-Type': 'text/plain',
      },
      body: '''
        where id = $id;
        fields
          name,
          genres.name,
          themes.name,
          game_modes.name,
          involved_companies.company.name,
          involved_companies.developer,
          involved_companies.publisher,
          first_release_date,
          cover.image_id,
          collections.name;
      ''',
    );

    if (response.statusCode != 200) {
      throw Exception('IGDB lookup failed: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as List;
    if (data.isEmpty) return null;
    return _mapToResult(data.first);
  }

  // ============================================================
  // Private Helpers
  // ============================================================

  Future<String?> _getAccessToken() async {
    // Reuse token if we have one (IGDB tokens last ~60 days)
    if (_accessToken != null) return _accessToken;

    final response = await _httpClient.post(
      Uri.parse(
        'https://id.twitch.tv/oauth2/token'
            '?client_id=$clientId'
            '&client_secret=$clientSecret'
            '&grant_type=client_credentials',
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _accessToken = data['access_token'];
      return _accessToken;
    }

    return null;
  }

  ExternalGameResult _mapToResult(Map<String, dynamic> game) {
    // Genres
    final genres = (game['genres'] as List?)
        ?.map((g) => Genre(
      id: g['id'] ?? 0,
      name: g['name'] ?? '',
    ))
        .toList() ??
        const [];

    // Themes
    final themes = (game['themes'] as List?)
        ?.map((t) => Theme(
      id: t['id'] ?? 0,
      name: t['name'] ?? '',
    ))
        .toList() ??
        const [];

    // Game Modes
    final gameModes = (game['game_modes'] as List?)
        ?.map((m) => m['name'] as String)
        .whereType<String>()
        .map(_gameModeFromString)
        .whereType<GameMode>()
        .toList() ??
        const [];

    // Developers & Publishers
    final developers = <String>[];
    final publishers = <String>[];
    if (game['involved_companies'] != null) {
      final companies = game['involved_companies'] as List;
      for (final company in companies) {
        final name = company['company']?['name'] as String?;
        if (name != null) {
          if (company['developer'] == true) {
            developers.add(name);
          }
          if (company['publisher'] == true) {
            publishers.add(name);
          }
        }
      }
    }

    // Release Date
    DateOnly? releaseDate;
    if (game['first_release_date'] != null) {
      final date = DateTime.fromMillisecondsSinceEpoch(
        (game['first_release_date'] as int) * 1000,
      );
      releaseDate = DateOnly.fromDateTime(date);
    }

    // Cover URL
    String? coverUrl;
    if (game['cover'] != null && game['cover']['image_id'] != null) {
      coverUrl =
      'https://images.igdb.com/igdb/image/upload/t_cover_big/${game['cover']['image_id']}.jpg';
    }

    // Series/Collections
    final series = (game['collections'] as List?)
        ?.map((c) => c['name'] as String)
        .whereType<String>()
        .toList() ??
        const [];

    return ExternalGameResult(
      title: game['name'] ?? '',
      genres: genres,
      themes: themes,
      gameModes: gameModes,
      developers: developers,
      publishers: publishers,
      releaseDate: releaseDate,
      coverUrl: coverUrl,
      series: series,
    );
  }

  GameMode? _gameModeFromString(String name) {
    final lower = name.toLowerCase();
    switch (lower) {
      case 'single player':
        return GameMode.singlePlayer;
      case 'multiplayer':
        return GameMode.multiplayer;
      case 'co-operative':
        return GameMode.cooperative;
      case 'competitive':
        return GameMode.competitive;
      case 'local multiplayer':
        return GameMode.localMultiplayer;
      case 'online multiplayer':
        return GameMode.onlineMultiplayer;
      default:
        return null;
    }
  }
}