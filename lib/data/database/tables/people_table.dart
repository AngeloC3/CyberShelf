import 'package:drift/drift.dart';

class People extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();
}