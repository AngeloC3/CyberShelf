import 'package:drift/drift.dart';
import 'package:cybershelf/data/database/converters/date_only_converter.dart';
import 'package:cybershelf/data/database/tables/media_table.dart';
import 'package:cybershelf/data/database/tables/media_metadata_table.dart';
import 'package:cybershelf/data/database/tables/media_user_data_table.dart';
import 'package:cybershelf/domain/date_only.dart';
import 'package:cybershelf/domain/media_status.dart';
import 'package:cybershelf/domain/media_type.dart';
import 'package:drift/native.dart';
import 'tables/genres_table.dart';
import 'tables/media_genres_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Media,
    MediaMetadata,
    MediaUserData,
    Genres,
    MediaGenres
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