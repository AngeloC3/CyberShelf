import 'package:drift/drift.dart';

import '../media_table.dart';

class Games extends Table {
  IntColumn get mediaId => integer().references(
    Media,
    #id,
    onDelete: KeyAction.cascade,
  )();

  @override
  Set<Column> get primaryKey => {
    mediaId,
  };
}