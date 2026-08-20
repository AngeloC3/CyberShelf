// lib/presentation/game/external_add_game_page.dart
import 'package:flutter/material.dart';
import 'package:cybershelf/application/game/game_service.dart';
import 'package:cybershelf/domain/game/external_game_source.dart';
import 'package:cybershelf/domain/game/game_mode.dart';
import 'package:cybershelf/presentation/game/game_detail_page.dart';

class ExternalAddGamePage extends StatefulWidget {
  const ExternalAddGamePage({
    super.key,
    required this.gameService,
    required this.externalSource,
    this.onGameAdded,
  });

  final GameService gameService;
  final ExternalGameSource externalSource;
  final VoidCallback? onGameAdded;

  @override
  State<ExternalAddGamePage> createState() => _ExternalAddGamePageState();
}

class _ExternalAddGamePageState extends State<ExternalAddGamePage> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  List<ExternalGameResult> _results = [];
  bool _isLoading = false;
  bool _hasSearched = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
      _hasSearched = true;
    });

    try {
      final results = await widget.externalSource.searchGames(query);
      setState(() {
        _results = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
        _results = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Game'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      hintText: 'Search for a game...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _results = [];
                            _hasSearched = false;
                          });
                        },
                      )
                          : null,
                    ),
                    onSubmitted: (_) => _search(),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _isLoading ? null : _search,
                  child: _isLoading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text('Search'),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Search failed',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _search,
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    if (_results.isEmpty && _hasSearched) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.search_off,
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'No games found',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Try a different search term',
                style: TextStyle(color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
      );
    }

    if (_results.isEmpty && !_hasSearched) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
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
                'Search for a game',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter a title above to get started',
                style: TextStyle(color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final result = _results[index];
        return _GameResultTile(
          result: result,
          onTap: () => _showGamePreview(result),
        );
      },
    );
  }

  void _showGamePreview(ExternalGameResult result) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _GamePreviewSheet(
        result: result,
        gameService: widget.gameService,
        onGameAdded: widget.onGameAdded,
      ),
    );
  }
}

// ==================== Game Result Tile ====================

class _GameResultTile extends StatelessWidget {
  const _GameResultTile({
    required this.result,
    required this.onTap,
  });

  final ExternalGameResult result;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              SizedBox(
                width: 64,
                height: 90,
                child: result.coverUrl == null
                    ? Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.videogame_asset,
                    size: 32,
                    color: Colors.grey,
                  ),
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    result.coverUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) {
                      return Container(
                        color: Colors.grey.shade300,
                        child: const Icon(
                          Icons.broken_image,
                          size: 32,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.title,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (result.releaseDate != null)
                      Text(
                        'Released: ${result.releaseDate}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    const SizedBox(height: 4),
                    if (result.genres.isNotEmpty)
                      Text(
                        result.genres.map((g) => g.name).join(', '),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== Game Preview Sheet ====================

class _GamePreviewSheet extends StatefulWidget {
  const _GamePreviewSheet({
    required this.result,
    required this.gameService,
    this.onGameAdded,
  });

  final ExternalGameResult result;
  final GameService gameService;
  final VoidCallback? onGameAdded;

  @override
  State<_GamePreviewSheet> createState() => _GamePreviewSheetState();
}

class _GamePreviewSheetState extends State<_GamePreviewSheet> {
  bool _isAdding = false;
  String? _error;

  Future<void> _addGame() async {
    setState(() {
      _isAdding = true;
      _error = null;
    });

    try {
      final game = await widget.gameService.importFromExternalSource(
        widget.result,
      );

      if (mounted) {
        widget.onGameAdded?.call();
        Navigator.pop(context); // Close bottom sheet
        Navigator.pop(context); // Go back to games list

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GameDetailPage(
              gameId: game.media.id,
              gameService: widget.gameService,
              onGameChanged: widget.onGameAdded ?? () {},
            ),
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Game added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isAdding = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.result;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Preview Game',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 100,
                height: 140,
                child: result.coverUrl == null
                    ? Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.videogame_asset,
                    size: 48,
                    color: Colors.grey,
                  ),
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    result.coverUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) {
                      return Container(
                        color: Colors.grey.shade300,
                        child: const Icon(
                          Icons.broken_image,
                          size: 48,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (result.releaseDate != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Released: ${result.releaseDate}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                    if (result.genres.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Genres: ${result.genres.map((g) => g.name).join(', ')}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                    if (result.themes.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Themes: ${result.themes.map((t) => t.name).join(', ')}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                    if (result.series.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Series: ${result.series.join(', ')}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                    if (result.developers.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Developers: ${result.developers.join(', ')}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                    if (result.publishers.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Publishers: ${result.publishers.join(', ')}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                    if (result.gameModes.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Modes: ${result.gameModes.map((m) => _gameModeLabel(m)).join(', ')}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red.shade400),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _error!,
                      style: TextStyle(color: Colors.red.shade800),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _isAdding ? null : () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: _isAdding ? null : _addGame,
                  child: _isAdding
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text('Add to Library'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  String _gameModeLabel(GameMode mode) {
    return switch (mode) {
      GameMode.singlePlayer => 'Single Player',
      GameMode.multiplayer => 'Multiplayer',
      GameMode.cooperative => 'Co-op',
      GameMode.competitive => 'Competitive',
      GameMode.localMultiplayer => 'Local MP',
      GameMode.onlineMultiplayer => 'Online MP',
    };
  }
}