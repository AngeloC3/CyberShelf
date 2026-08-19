import 'package:drift/drift.dart';

import 'package:cybershelf/data/database/tables/game/games_table.dart';
import 'package:cybershelf/domain/game/game_mode.dart';

class GamePlayedModes extends Table {
  IntColumn get mediaId => integer().references(
    Games,
    #mediaId,
    onDelete: KeyAction.cascade,
  )();

  TextColumn get mode => textEnum<GameMode>()();

  @override
  Set<Column> get primaryKey => {
    mediaId,
    mode,
  };
}