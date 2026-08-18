import 'package:drift/drift.dart';

import 'package:cybershelf/data/database/tables/game/games_table.dart';

class GamePlayedPlatforms extends Table {
  IntColumn get mediaId => integer().references(
    Games,
    #mediaId,
    onDelete: KeyAction.cascade,
  )();

  TextColumn get platform => text()();

  @override
  Set<Column> get primaryKey => {
    mediaId,
    platform,
  };
}