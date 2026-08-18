import 'package:drift/drift.dart';

import 'media_table.dart';

@TableIndex(
  name: 'external_ids_media_source_idx',
  columns: {#mediaId, #source},
  unique: true,
)
@TableIndex(
  name: 'external_ids_source_external_id_idx',
  columns: {#source, #externalId},
  unique: true,
)
class ExternalIds extends Table {
  IntColumn get mediaId => integer().references(
    Media,
    #id,
    onDelete: KeyAction.cascade,
  )();

  TextColumn get source => text()();

  TextColumn get externalId => text()();

  @override
  Set<Column> get primaryKey => {
    mediaId,
    source,
  };
}