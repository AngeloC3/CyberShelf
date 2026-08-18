import 'package:drift/drift.dart';
import 'package:cybershelf/domain/media_type.dart';

@TableIndex(name: 'media_type_idx', columns: {#mediaType})
class Media extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get mediaType => textEnum<MediaType>()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();
}