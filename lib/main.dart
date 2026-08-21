import 'package:flutter/material.dart';
import 'package:cybershelf/application/credentials/credential_manager.dart';
import 'package:cybershelf/application/game/game_service.dart';
import 'package:cybershelf/data/database/app_database.dart';
import 'package:cybershelf/data/database/database_provider.dart';
import 'package:cybershelf/data/external/igdb_game_source.dart';
import 'package:cybershelf/data/repositories/drift_game_repository.dart';
import 'package:cybershelf/domain/game/external_game_source.dart';
import 'package:cybershelf/presentation/game/games_page.dart';
import 'package:cybershelf/presentation/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = await createDatabase();
  final gameRepository = DriftGameRepository(database);
  final gameService = GameService(gameRepository, database);

  runApp(
    CyberShelfApp(
      database: database,
      gameService: gameService,
    ),
  );
}

class CyberShelfApp extends StatefulWidget {
  const CyberShelfApp({
    super.key,
    required this.database,
    required this.gameService,
  });

  final AppDatabase database;
  final GameService gameService;

  @override
  State<CyberShelfApp> createState() => _CyberShelfAppState();
}

class _CyberShelfAppState extends State<CyberShelfApp> {
  ExternalGameSource? _gameExternalSource;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGameCredentials();
  }

  Future<void> _loadGameCredentials() async {
    setState(() => _isLoading = true);
    final creds = await CredentialManager.instance.getCredentials();
    setState(() {
      _gameExternalSource = creds != null
          ? IgdbGameSource(
        clientId: creds.clientId,
        clientSecret: creds.clientSecret,
      )
          : null;
      _isLoading = false;
    });
  }

  /// Called when game credentials are updated in Settings
  void _onGameCredentialsChanged() {
    _loadGameCredentials();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CyberShelf',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      home: _isLoading
          ? const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      )
          : GamesPage(  // Make sure this matches the import
        gameService: widget.gameService,
        externalSource: _gameExternalSource,
        onGameCredentialsChanged: _onGameCredentialsChanged,
      ),
    );
  }
}