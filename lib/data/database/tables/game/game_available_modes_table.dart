import 'package:drift/drift.dart';

import 'package:cybershelf/data/database/tables/game/games_table.dart';

class GameAvailableModes extends Table {
  IntColumn get mediaId => integer().references(
    Games,
    #mediaId,
    onDelete: KeyAction.cascade,
  )();

  TextColumn get mode => text()();

  @override
  Set<Column> get primaryKey => {
    mediaId,
    mode,
  };
}