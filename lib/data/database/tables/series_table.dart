// lib/data/database/tables/series_table.dart
import 'package:drift/drift.dart';

class Series extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().unique()();
}