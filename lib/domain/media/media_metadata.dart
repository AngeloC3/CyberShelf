import 'package:cybershelf/domain/date_only.dart';
import 'package:cybershelf/domain/media/external_id.dart';
import 'package:cybershelf/domain/media/genre.dart';
import 'package:cybershelf/domain/media/theme.dart';

class MediaMetadata {
  const MediaMetadata({
    required this.title,
    this.description,
    this.coverUrl,
    this.releaseDate,
    this.genres = const [],
    this.themes = const [],
    this.externalIds = const [],
  });

  final String title;
  final String? description;
  final String? coverUrl;
  final DateOnly? releaseDate;
  final List<Genre> genres;
  final List<Theme> themes;
  final List<ExternalId> externalIds;

  MediaMetadata copyWith({
    String? title,
    Object? description = _unset,
    Object? coverUrl = _unset,
    Object? releaseDate = _unset,
    List<Genre>? genres,
    List<Theme>? themes,
    List<ExternalId>? externalIds,
  }) {
    return MediaMetadata(
      title: title ?? this.title,
      description: identical(description, _unset)
          ? this.description
          : description as String?,
      coverUrl: identical(coverUrl, _unset)
          ? this.coverUrl
          : coverUrl as String?,
      releaseDate: identical(releaseDate, _unset)
          ? this.releaseDate
          : releaseDate as DateOnly?,
      genres: genres ?? this.genres,
      themes: themes ?? this.themes,
      externalIds: externalIds ?? this.externalIds,
    );
  }
}

const _unset = Object();