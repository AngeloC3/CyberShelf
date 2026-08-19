import 'package:cybershelf/domain/date_only.dart';
import 'package:cybershelf/domain/game/game_mode.dart';
import 'package:cybershelf/domain/media/genre.dart';
import 'package:cybershelf/domain/media/theme.dart';

/// Represents a game lookup result from an external game source.
class ExternalGameResult {
  const ExternalGameResult({
    required this.title,
    this.genres = const [],
    this.themes = const [],
    this.gameModes = const [],
    this.developers = const [],
    this.publishers = const [],
    this.releaseDate,
    this.coverUrl,
    this.series = const [],
  });

  final String title;
  final List<Genre> genres;
  final List<Theme> themes;
  final List<GameMode> gameModes;
  final List<String> developers;
  final List<String> publishers;
  final DateOnly? releaseDate;
  final String? coverUrl;
  final List<String> series;
}

/// Contract for external game data sources (IGDB, Steam, GameDB, etc.)
abstract interface class ExternalGameSource {
  /// Search for games by title.
  /// Returns a list of search results with basic info.
  Future<List<ExternalGameResult>> searchGames(String query);

  /// Get a specific game by its external ID.
  Future<ExternalGameResult?> getGameById(String id);

  /// Get the name of this source (e.g., "IGDB", "Steam", etc.)
  String get sourceName;
}