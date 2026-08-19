import 'package:flutter/material.dart';
import 'package:cybershelf/application/game/game_service.dart';
import 'package:cybershelf/data/external/igdb_game_source.dart';
import 'package:cybershelf/domain/game/game_item.dart';
import 'package:cybershelf/domain/media_status.dart';
import 'package:cybershelf/presentation/game/external_add_game_page.dart';
import 'package:cybershelf/presentation/game/manual_add_game_page.dart';
import 'package:cybershelf/presentation/game/game_detail_page.dart';

class GamesPage extends StatefulWidget {
  const GamesPage({
    super.key,
    required this.gameService,
    required this.igdbClientId,
    required this.igdbClientSecret,
  });

  final GameService gameService;
  final String igdbClientId;
  final String igdbClientSecret;

  @override
  State<GamesPage> createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  late Future<List<GameItem>> _gamesFuture;

  @override
  void initState() {
    super.initState();
    _loadGames();
  }

  void _loadGames() {
    _gamesFuture = widget.gameService.getAll();
  }

  Future<void> _refresh() async {
    setState(() {
      _loadGames();
    });
    await _gamesFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Games'),
      ),
      body: FutureBuilder<List<GameItem>>(
        key: ValueKey(_gamesFuture),
        future: _gamesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48),
                    const SizedBox(height: 16),
                    const Text(
                      'Failed to load games.',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _refresh,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final games = snapshot.data ?? [];

          if (games.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.videogame_asset,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No games yet.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the + button to add one',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: games.length,
              itemBuilder: (context, index) {
                return _GameListTile(
                  game: games[index],
                  gameService: widget.gameService,
                  onGameChanged: _refresh,
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddOptions,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Search IGDB'),
              onTap: () {
                Navigator.pop(context);
                _navigateToAddGame();
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Enter Manually'),
              onTap: () {
                Navigator.pop(context);
                _navigateToManualAdd();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAddGame() {
    if (widget.igdbClientId.isEmpty || widget.igdbClientSecret.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'IGDB credentials not configured. '
                'Set IGDB_CLIENT_ID and IGDB_CLIENT_SECRET environment variables.',
          ),
          duration: Duration(seconds: 5),
        ),
      );
      return;
    }

    final externalSource = IgdbGameSource(
      clientId: widget.igdbClientId,
      clientSecret: widget.igdbClientSecret,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExternalAddGamePage(
          gameService: widget.gameService,
          externalSource: externalSource,
          onGameAdded: _refresh,
        ),
      ),
    );
  }

  void _navigateToManualAdd() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ManualAddGamePage(
          gameService: widget.gameService,
          onGameAdded: _refresh,
        ),
      ),
    );
  }
}

class _GameListTile extends StatelessWidget {
  const _GameListTile({
    required this.game,
    required this.gameService,
    required this.onGameChanged,
  });

  final GameItem game;
  final GameService gameService;
  final VoidCallback onGameChanged;

  @override
  Widget build(BuildContext context) {
    final metadata = game.media.metadata;
    final userData = game.media.userData;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: SizedBox(
          width: 56,
          height: 80,
          child: metadata.coverUrl == null
              ? Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.videogame_asset, size: 32),
          )
              : ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.network(
              metadata.coverUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) {
                return Container(
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.broken_image),
                );
              },
            ),
          ),
        ),
        title: Text(
          metadata.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(_statusLabel(userData.status)),
        ),
        onTap: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (context) => GameDetailPage(
                gameId: game.media.id,
                gameService: gameService,
                onGameChanged: onGameChanged,
              ),
            ),
          );

          if (result == true) {
            onGameChanged();
          }
        },
      ),
    );
  }

  String _statusLabel(MediaStatus status) {
    return switch (status) {
      MediaStatus.planned => 'Planned',
      MediaStatus.inProgress => 'In Progress',
      MediaStatus.completed => 'Completed',
      MediaStatus.dropped => 'Dropped',
    };
  }
}