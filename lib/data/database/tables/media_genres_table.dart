import 'package:drift/drift.dart';

import 'media_table.dart';
import 'genres_table.dart';

class MediaGenres extends Table {
  IntColumn get mediaId => integer().references(
    Media,
    #id,
    onDelete: KeyAction.cascade,
  )();

  IntColumn get genreId => integer().references(
    Genres,
    #id,
    onDelete: KeyAction.cascade,
  )();

  @override
  Set<Column> get primaryKey => {
    mediaId,
    genreId,
  };
}