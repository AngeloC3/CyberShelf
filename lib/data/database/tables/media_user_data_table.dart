import 'package:drift/drift.dart';
import 'package:cybershelf/data/database/converters/date_only_converter.dart';
import 'package:cybershelf/data/database/tables/media_table.dart';
import 'package:cybershelf/domain/media_status.dart';

class MediaUserData extends Table {
  IntColumn get mediaId =>
      integer().references(Media, #id, onDelete: KeyAction.cascade)();

  TextColumn get status => textEnum<MediaStatus>()();

  late final IntColumn rating = integer()
      .nullable()
      .check(rating.isBetweenValues(0, 100))();

  TextColumn get startedOn =>
      text().map(const DateOnlyConverter()).nullable()();

  TextColumn get finishedOn =>
      text().map(const DateOnlyConverter()).nullable()();

  TextColumn get review => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {mediaId};
}