import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

Future<QueryExecutor> openDatabaseConnection() async {
  final directory = await _getDatabaseDirectory();
  final file = File(p.join(directory.path, 'cybershelf.sqlite'));

  return NativeDatabase.createInBackground(
    file,
    setup: (db) {
      db.execute('PRAGMA foreign_keys = ON');
    },
  );
}

/// Gets the database directory using the same logic as CredentialStorage
Future<Directory> _getDatabaseDirectory() async {
  if (Platform.isWindows) {
    // On Windows, use the executable's directory with a 'data' subfolder
    final exeDir = File(Platform.resolvedExecutable).parent;
    final dataDir = Directory(p.join(exeDir.path, 'data'));

    if (!await dataDir.exists()) {
      await dataDir.create(recursive: true);
    }

    return dataDir;
  } else {
    // On other platforms (Android, macOS, Linux, iOS), use application documents
    return await getApplicationDocumentsDirectory();
  }
}