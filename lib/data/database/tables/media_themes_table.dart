import 'package:drift/drift.dart';

import 'media_table.dart';
import 'themes_table.dart';

class MediaThemes extends Table {
  IntColumn get mediaId => integer().references(
    Media,
    #id,
    onDelete: KeyAction.cascade,
  )();

  IntColumn get themeId => integer().references(
    Themes,
    #id,
    onDelete: KeyAction.cascade,
  )();

  @override
  Set<Column> get primaryKey => {
    mediaId,
    themeId,
  };
}