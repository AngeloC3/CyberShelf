import 'package:flutter/material.dart';
import 'package:cybershelf/data/database/app_database.dart';
import 'package:cybershelf/data/database/database_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = await createDatabase();

  runApp(CyberShelfApp(database: database));
}

class CyberShelfApp extends StatelessWidget {
  const CyberShelfApp({
    super.key,
    required this.database,
  });

  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CyberShelf',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text('CyberShelf'),
        ),
      ),
    );
  }
}