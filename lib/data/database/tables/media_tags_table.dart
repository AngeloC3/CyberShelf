import 'package:drift/drift.dart';

import 'media_table.dart';
import 'tags_table.dart';

class MediaTags extends Table {
  IntColumn get mediaId => integer().references(
    Media,
    #id,
    onDelete: KeyAction.cascade,
  )();

  IntColumn get tagId => integer().references(
    Tags,
    #id,
    onDelete: KeyAction.cascade,
  )();

  @override
  Set<Column> get primaryKey => {
    mediaId,
    tagId,
  };
}