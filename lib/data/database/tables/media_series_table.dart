// lib/data/database/tables/media_series_table.dart
import 'package:drift/drift.dart';

import 'media_table.dart';
import 'series_table.dart';

class MediaSeries extends Table {
  IntColumn get mediaId => integer().references(
    Media,
    #id,
    onDelete: KeyAction.cascade,
  )();

  IntColumn get seriesId => integer().references(
    Series,
    #id,
    onDelete: KeyAction.cascade,
  )();

  @override
  Set<Column> get primaryKey => {
    mediaId,
    seriesId,
  };
}