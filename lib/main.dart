import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cybershelf/application/game/game_service.dart';
import 'package:cybershelf/data/database/app_database.dart';
import 'package:cybershelf/data/database/database_provider.dart';
import 'package:cybershelf/data/repositories/drift_game_repository.dart';
import 'package:cybershelf/presentation/game/games_page.dart';
import 'package:cybershelf/presentation/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  final database = await createDatabase();

  final gameRepository = DriftGameRepository(database);
  final gameService = GameService(gameRepository);

  final igdbClientId = dotenv.env['IGDB_CLIENT_ID'] ?? '';
  final igdbClientSecret = dotenv.env['IGDB_CLIENT_SECRET'] ?? '';

  runApp(
    CyberShelfApp(
      database: database,
      gameService: gameService,
      igdbClientId: igdbClientId,
      igdbClientSecret: igdbClientSecret,
    ),
  );
}

class CyberShelfApp extends StatelessWidget {
  const CyberShelfApp({
    super.key,
    required this.database,
    required this.gameService,
    required this.igdbClientId,
    required this.igdbClientSecret,
  });

  final AppDatabase database;
  final GameService gameService;
  final String igdbClientId;
  final String igdbClientSecret;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CyberShelf',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      home: GamesPage(
        gameService: gameService,
        igdbClientId: igdbClientId,
        igdbClientSecret: igdbClientSecret,
      ),
    );
  }
}