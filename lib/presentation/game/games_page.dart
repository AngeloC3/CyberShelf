import 'package:flutter/material.dart';
import 'package:cybershelf/application/game/game_service.dart';
import 'package:cybershelf/domain/game/external_game_source.dart';
import 'package:cybershelf/domain/game/game_item.dart';
import 'package:cybershelf/presentation/game/external_add_game_page.dart';
import 'package:cybershelf/presentation/game/manual_add_game_page.dart';
import 'package:cybershelf/presentation/game/game_detail_page.dart';
import 'package:cybershelf/presentation/settings/settings_page.dart';
import 'package:cybershelf/presentation/shared/rating_utils.dart';
import 'package:cybershelf/presentation/shared/status_utils.dart';
import 'package:cybershelf/presentation/filter/filter_models.dart';
import 'package:cybershelf/presentation/filter/filter_page.dart';
import 'package:cybershelf/presentation/filter/game_filter_config.dart';

enum SortOption {
  titleAsc,
  titleDesc,
  ratingAsc,
  ratingDesc,
}

class GamesPage extends StatefulWidget {
  const GamesPage({
    super.key,
    required this.gameService,
    required this.externalSource,
  });

  final GameService gameService;
  final ExternalGameSource? externalSource;

  @override
  State<GamesPage> createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  List<GameItem> _allGames = [];
  List<GameItem> _displayedGames = [];
  bool _isLoading = true;
  String? _error;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  SortOption _sortOption = SortOption.titleAsc;
  FilterState _filterState = const FilterState();
  final GameFilterEvaluator _filterEvaluator = const GameFilterEvaluator();

  @override
  void initState() {
    super.initState();
    _loadGames();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadGames() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final games = await widget.gameService.getAll();
      setState(() {
        _allGames = games;
        _displayedGames = games;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      _isSearching = query.isNotEmpty;
      _applyFiltersAndSearch();
    });
  }

  void _applyFiltersAndSearch() {
    final query = _searchController.text.toLowerCase().trim();
    var games = _allGames;

    // Apply filters
    if (_filterState.hasActiveFilters) {
      games = games.where((game) {
        for (final group in _filterState.groups) {
          if (group.conditions.isEmpty) continue;

          bool groupMatches = group.isAnd;

          for (final condition in group.conditions) {
            bool conditionMatches = _filterEvaluator.evaluate(game, condition);

            if (group.isAnd) {
              groupMatches = groupMatches && conditionMatches;
            } else {
              groupMatches = groupMatches || conditionMatches;
            }

            if (group.isAnd && !groupMatches) break;
            if (!group.isAnd && groupMatches) break;
          }

          if (groupMatches) return true;
        }
        return false;
      }).toList();
    }

    // Apply search
    if (query.isNotEmpty) {
      games = games.where((game) {
        return game.media.metadata.title.toLowerCase().contains(query);
      }).toList();
    }

    // Apply sort
    games = _getSortedGames(games);

    setState(() {
      _displayedGames = games;
    });
  }

  List<GameItem> _getSortedGames(List<GameItem> games) {
    switch (_sortOption) {
      case SortOption.titleAsc:
        return [...games]..sort((a, b) =>
            a.media.metadata.title.compareTo(b.media.metadata.title));
      case SortOption.titleDesc:
        return [...games]..sort((a, b) =>
            b.media.metadata.title.compareTo(a.media.metadata.title));
      case SortOption.ratingAsc:
        return [...games]..sort((a, b) {
          final aRating = a.media.userData.rating ?? -1;
          final bRating = b.media.userData.rating ?? -1;
          return aRating.compareTo(bRating);
        });
      case SortOption.ratingDesc:
        return [...games]..sort((a, b) {
          final aRating = a.media.userData.rating ?? -1;
          final bRating = b.media.userData.rating ?? -1;
          return bRating.compareTo(aRating);
        });
    }
  }

  Future<void> _refresh() async {
    _searchController.clear();
    setState(() {
      _filterState = const FilterState();
      _isSearching = false;
    });
    await _loadGames();
  }

  void _openFilter() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FilterPage<GameItem>(
          initialFilterState: _filterState,
          availableFields: _filterEvaluator.availableFields,
          getSelectOptions: _filterEvaluator.getSelectOptions,
          onApply: (newFilterState) {
            setState(() {
              _filterState = newFilterState;
              _applyFiltersAndSearch();
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search games...',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Colors.white),
        )
            : const Text('Games'),
        actions: [
          if (_isSearching)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _isSearching = false;
                  _applyFiltersAndSearch();
                });
              },
            )
          else ...[
            // Settings button
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: _navigateToSettings,
              tooltip: 'Settings',
            ),
            IconButton(
              icon: Stack(
                children: [
                  const Icon(Icons.filter_list),
                  if (_filterState.hasActiveFilters)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                ],
              ),
              onPressed: _openFilter,
            ),
            IconButton(
              icon: const Icon(Icons.sort),
              onPressed: _showSortOptions,
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              },
            ),
          ],
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddOptions,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SettingsPage(),
      ),
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
              const Icon(Icons.error_outline, size: 48),
              const SizedBox(height: 16),
              const Text(
                'Failed to load games.',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
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

    final games = _displayedGames;

    if (games.isEmpty && _isSearching) {
      return Center(
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
              'No games match your search',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try a different search term',
              style: TextStyle(
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

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
              title: const Text('Search External Source'),
              subtitle: widget.externalSource != null
                  ? null
                  : Text(
                'Configure in Settings',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
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
    // If no external source, navigate to settings with a message
    if (widget.externalSource == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please configure IGDB credentials in Settings first.'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.orange,
        ),
      );
      _navigateToSettings();
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExternalAddGamePage(
          gameService: widget.gameService,
          externalSource: widget.externalSource!,
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

  void _showSortOptions() {
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
              leading: const Icon(Icons.sort_by_alpha),
              title: const Text('Title A-Z'),
              trailing: _sortOption == SortOption.titleAsc
                  ? const Icon(Icons.check)
                  : null,
              onTap: () {
                setState(() {
                  _sortOption = SortOption.titleAsc;
                  _applyFiltersAndSearch();
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.sort_by_alpha),
              title: const Text('Title Z-A'),
              trailing: _sortOption == SortOption.titleDesc
                  ? const Icon(Icons.check)
                  : null,
              onTap: () {
                setState(() {
                  _sortOption = SortOption.titleDesc;
                  _applyFiltersAndSearch();
                });
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Rating (Low to High)'),
              trailing: _sortOption == SortOption.ratingAsc
                  ? const Icon(Icons.check)
                  : null,
              onTap: () {
                setState(() {
                  _sortOption = SortOption.ratingAsc;
                  _applyFiltersAndSearch();
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Rating (High to Low)'),
              trailing: _sortOption == SortOption.ratingDesc
                  ? const Icon(Icons.check)
                  : null,
              onTap: () {
                setState(() {
                  _sortOption = SortOption.ratingDesc;
                  _applyFiltersAndSearch();
                });
                Navigator.pop(context);
              },
            ),
          ],
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
    final rating = userData.rating;

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
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StatusUtils.buildCompactIndicator(userData.status),
            if (rating != null) ...[
              const SizedBox(height: 4),
              RatingUtils.buildCompactStars(rating, size: 14),
            ],
          ],
        ),
        trailing: RatingUtils.buildCompactRatingCircle(rating, size: 36),
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
}