import 'package:drift/drift.dart';
import 'package:cybershelf/data/database/converters/date_only_converter.dart';
import 'package:cybershelf/data/database/tables/media_table.dart';
import 'package:cybershelf/data/database/tables/media_metadata_table.dart';
import 'package:cybershelf/data/database/tables/media_user_data_table.dart';
import 'package:cybershelf/domain/date_only.dart';
import 'package:cybershelf/domain/media_status.dart';
import 'package:cybershelf/domain/media_type.dart';
import 'package:cybershelf/domain/game/game_mode.dart';
import 'package:cybershelf/domain/game/game_platform.dart';
import 'package:cybershelf/data/database/tables/genres_table.dart';
import 'package:cybershelf/data/database/tables/media_genres_table.dart';
import 'package:cybershelf/data/database/tables/external_ids_table.dart';
import 'package:cybershelf/data/database/tables/tags_table.dart';
import 'package:cybershelf/data/database/tables/media_tags_table.dart';
import 'package:cybershelf/data/database/tables/game/games_table.dart';
import 'package:cybershelf/data/database/tables/game/game_available_modes_table.dart';
import 'package:cybershelf/data/database/tables/game/game_played_modes_table.dart';
import 'package:cybershelf/data/database/tables/game/game_played_platforms_table.dart';
import 'package:cybershelf/data/database/tables/people_table.dart';
import 'package:cybershelf/data/database/tables/companies_table.dart';
import 'package:cybershelf/data/database/tables/contributors_table.dart';
import 'package:cybershelf/data/database/tables/game/game_developers_table.dart';
import 'package:cybershelf/data/database/tables/game/game_publishers_table.dart';
import 'package:cybershelf/data/database/tables/themes_table.dart';
import 'package:cybershelf/data/database/tables/media_themes_table.dart';

import 'package:drift/native.dart';
part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Media,
    MediaMetadata,
    MediaUserData,
    Genres,
    MediaGenres,
    ExternalIds,
    Tags,
    MediaTags,
    Games,
    GameAvailableModes,
    GamePlayedModes,
    GamePlayedPlatforms,
    People,
    Companies,
    Contributors,
    GameDevelopers,
    GamePublishers,
    Themes,
    MediaThemes
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  AppDatabase.forTesting()
      : super(
    NativeDatabase.memory(
      setup: (db) {
        db.execute('PRAGMA foreign_keys = ON');
      },
    ),
  );

  @override
  int get schemaVersion => 1;
}