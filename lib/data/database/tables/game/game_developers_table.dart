import 'package:drift/drift.dart';

import 'package:cybershelf/data/database/tables/game/games_table.dart';
import 'package:cybershelf/data/database/tables/contributors_table.dart';

class GameDevelopers extends Table {
  IntColumn get mediaId => integer().references(
    Games,
    #mediaId,
    onDelete: KeyAction.cascade,
  )();

  IntColumn get contributorId => integer().references(
    Contributors,
    #id,
    onDelete: KeyAction.cascade,
  )();

  @override
  Set<Column> get primaryKey => {
    mediaId,
    contributorId,
  };
}