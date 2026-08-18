import 'package:drift/native.dart';
import 'package:cybershelf/data/database/app_database.dart';

AppDatabase createTestDatabase() {
  return AppDatabase(
    NativeDatabase.memory(
      setup: (db) {
        db.execute('PRAGMA foreign_keys = ON');
      },
    ),
  );
}