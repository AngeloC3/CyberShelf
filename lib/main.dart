import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cybershelf/application/credentials/providers.dart';
import 'package:cybershelf/application/game/game_service.dart';
import 'package:cybershelf/data/database/database_provider.dart';
import 'package:cybershelf/data/repositories/drift_game_repository.dart';
import 'package:cybershelf/presentation/game/games_page.dart';
import 'package:cybershelf/presentation/theme/app_theme.dart';

// Global provider for GameService
final gameServiceProvider = Provider<GameService>((ref) {
  throw UnimplementedError('GameService not initialized. Provide override in main().');
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = await createDatabase();
  final gameRepository = DriftGameRepository(database);
  final gameService = GameService(gameRepository, database);

  runApp(
    ProviderScope(
      overrides: [
        // Override the gameServiceProvider with our instance
        gameServiceProvider.overrideWithValue(gameService),
      ],
      child: const CyberShelfApp(),
    ),
  );
}

class CyberShelfApp extends ConsumerWidget {
  const CyberShelfApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the credential state to trigger initial load and handle states
    final credentialState = ref.watch(credentialStateProvider);
    final isLoading = credentialState.isLoading;
    final hasError = credentialState.hasError;
    final error = credentialState.error;
    final externalSource = credentialState.value;

    return MaterialApp(
      title: 'CyberShelf',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      home: isLoading
          ? const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image(
                image: AssetImage('assets/logo.png'),
                height: 64,
                width: 64,
              ),
              SizedBox(height: 16),
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading credentials...'),
            ],
          ),
        ),
      )
          : hasError
          ? Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Failed to load credentials',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  error?.toString() ?? 'Unknown error',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () {
                    // Retry loading credentials
                    ref.read(credentialStateProvider.notifier).refresh();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      )
          : GamesPage(
        gameService: ref.watch(gameServiceProvider),
        externalSource: externalSource,
      ),
    );
  }
}