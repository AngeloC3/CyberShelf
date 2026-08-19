import 'package:drift/drift.dart';

import 'package:cybershelf/data/database/tables/game/games_table.dart';
import 'package:cybershelf/domain/game/game_platform.dart';

class GamePlayedPlatforms extends Table {
  IntColumn get mediaId => integer().references(
    Games,
    #mediaId,
    onDelete: KeyAction.cascade,
  )();

  TextColumn get platform => textEnum<GamePlatform>()();

  @override
  Set<Column> get primaryKey => {
    mediaId,
    platform,
  };
}