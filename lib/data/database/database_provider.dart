import 'package:cybershelf/data/database/app_database.dart';
import 'package:cybershelf/data/database/connection.dart';

Future<AppDatabase> createDatabase() async {
  final executor = await openDatabaseConnection();
  return AppDatabase(executor);
}