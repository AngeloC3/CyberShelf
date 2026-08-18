import 'package:drift/drift.dart';
import 'package:cybershelf/data/database/converters/date_only_converter.dart';
import 'package:cybershelf/data/database/tables/media_table.dart';

class MediaMetadata extends Table {
  IntColumn get mediaId =>
      integer().references(Media, #id, onDelete: KeyAction.cascade)();

  TextColumn get title => text()();

  TextColumn get description => text().nullable()();

  TextColumn get coverUrl => text().nullable()();

  TextColumn get releaseDate =>
      text().map(const DateOnlyConverter()).nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {mediaId};
}