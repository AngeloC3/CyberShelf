import 'package:cybershelf/domain/date_only.dart';

class MediaMetadata {
  const MediaMetadata({
    required this.title,
    this.description,
    this.coverUrl,
    this.releaseDate,
  });

  final String title;
  final String? description;
  final String? coverUrl;
  final DateOnly? releaseDate;

  MediaMetadata copyWith({
    String? title,
    Object? description = _unset,
    Object? coverUrl = _unset,
    Object? releaseDate = _unset,
  }) {
    return MediaMetadata(
      title: title ?? this.title,
      description: identical(description, _unset)
          ? this.description
          : description as String?,
      coverUrl:
      identical(coverUrl, _unset) ? this.coverUrl : coverUrl as String?,
      releaseDate: identical(releaseDate, _unset)
          ? this.releaseDate
          : releaseDate as DateOnly?,
    );
  }
}

const _unset = Object();