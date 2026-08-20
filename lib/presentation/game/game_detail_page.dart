// lib/presentation/game/game_detail_page.dart
import 'package:flutter/material.dart';
import 'package:cybershelf/application/game/game_service.dart';
import 'package:cybershelf/domain/date_only.dart';
import 'package:cybershelf/domain/game/game_item.dart';
import 'package:cybershelf/domain/game/game_mode.dart';
import 'package:cybershelf/domain/game/game_platform.dart';
import 'package:cybershelf/domain/media/tag.dart';
import 'package:cybershelf/domain/media_status.dart';
import 'package:cybershelf/domain/media/contributor.dart' as domain;
import 'package:cybershelf/domain/media/media_metadata.dart';
import 'package:cybershelf/domain/media/genre.dart' as domain_genre;
import 'package:cybershelf/domain/media/theme.dart' as domain_theme;
import 'package:cybershelf/domain/media/series.dart' as domain_series;
import 'package:cybershelf/presentation/shared/rating_utils.dart';
import 'package:cybershelf/presentation/shared/status_utils.dart';

class GameDetailPage extends StatefulWidget {
  const GameDetailPage({
    super.key,
    required this.gameId,
    required this.gameService,
    required this.onGameChanged,
  });

  final int gameId;
  final GameService gameService;
  final VoidCallback onGameChanged;

  @override
  State<GameDetailPage> createState() => _GameDetailPageState();
}

class _GameDetailPageState extends State<GameDetailPage> {
  late Future<GameItem> _gameFuture;
  int _refreshKey = 0;

  @override
  void initState() {
    super.initState();
    _loadGame();
  }

  void _loadGame() {
    setState(() {
      _refreshKey++;
      _gameFuture = widget.gameService.getById(widget.gameId).then(
            (game) => game!,
      );
    });
  }

  void _onDataChanged() {
    _loadGame();
    widget.onGameChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _confirmDelete,
          ),
        ],
      ),
      body: FutureBuilder<GameItem>(
        key: ValueKey(_refreshKey),
        future: _gameFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
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
                      'Failed to load game.',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(snapshot.error.toString()),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _loadGame,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final game = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(game),
                const SizedBox(height: 16),
                _buildRatingSection(game),
                const SizedBox(height: 16),
                _buildReviewSection(game),
                const SizedBox(height: 24),
                _buildMetadataSection(game),
                const SizedBox(height: 24),
                _buildUserDataSection(game),
                const SizedBox(height: 24),
                _buildGameMetadataSection(game),
                const SizedBox(height: 24),
                _buildGameUserDataSection(game),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(GameItem game) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          height: 170,
          child: game.media.metadata.coverUrl == null
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
              game.media.metadata.coverUrl!,
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
                game.media.metadata.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              if (game.media.metadata.releaseDate != null) ...[
                const SizedBox(height: 4),
                Text(
                  'Released: ${game.media.metadata.releaseDate}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
              const SizedBox(height: 8),
              StatusUtils.buildChip(game.media.userData.status),
              if (game.media.metadata.description != null) ...[
                const SizedBox(height: 8),
                Text(
                  game.media.metadata.description!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRatingSection(GameItem game) {
    final rating = game.media.userData.rating;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: RatingUtils.buildRatingDisplay(
                rating: rating,
                context: context,
                circleSize: 80,
                starSize: 20,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: () => _showEditRatingDialog(game),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewSection(GameItem game) {
    final review = game.media.userData.review;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Review',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () => _showEditReviewDialog(game),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (review != null && review.isNotEmpty)
              Text(
                review,
                style: Theme.of(context).textTheme.bodyMedium,
              )
            else
              Text(
                'No review yet. Tap edit to write one.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataSection(GameItem game) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Media Metadata',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () => _showEditMediaMetadataDialog(game),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // COVER URL REMOVED - this line is gone
            if (game.media.metadata.releaseDate != null)
              _buildInfoRow('Release Date', game.media.metadata.releaseDate.toString()),
            if (game.media.metadata.genres.isNotEmpty)
              _buildInfoRow(
                'Genres',
                game.media.metadata.genres.map((g) => g.name).join(', '),
              ),
            if (game.media.metadata.themes.isNotEmpty)
              _buildInfoRow(
                'Themes',
                game.media.metadata.themes.map((t) => t.name).join(', '),
              ),
            if (game.media.metadata.series.isNotEmpty)
              _buildInfoRow(
                'Series',
                game.media.metadata.series.map((s) => s.name).join(', '),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserDataSection(GameItem game) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Your Data',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () => _showEditUserDataDialog(game),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Status', StatusUtils.getLabel(game.media.userData.status)),
            if (game.media.userData.startedOn != null)
              _buildInfoRow('Started', game.media.userData.startedOn.toString()),
            if (game.media.userData.finishedOn != null)
              _buildInfoRow('Finished', game.media.userData.finishedOn.toString()),
            if (game.media.userData.tags.isNotEmpty)
              _buildInfoRow(
                'Tags',
                game.media.userData.tags.map((t) => t.name).join(', '),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameMetadataSection(GameItem game) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Game Metadata',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () => _showEditGameMetadataDialog(game),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (game.gameMetadata.developers.isNotEmpty)
              _buildContributorsRow('Developers', game.gameMetadata.developers),
            if (game.gameMetadata.publishers.isNotEmpty)
              _buildContributorsRow('Publishers', game.gameMetadata.publishers),
            if (game.gameMetadata.developers.isEmpty &&
                game.gameMetadata.publishers.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'No game metadata recorded yet.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContributorsRow(String label, List<domain.Contributor> contributors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<String>>(
              future: Future.wait(
                contributors.map((c) => widget.gameService.getContributorName(c)),
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Loading...', style: TextStyle(color: Colors.grey));
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red));
                }
                final names = snapshot.data ?? [];
                return Text(
                  names.join(', '),
                  style: Theme.of(context).textTheme.bodyMedium,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameUserDataSection(GameItem game) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Your Game Data',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () => _showEditGameUserDataDialog(game),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (game.gameUserData.playedModes.isNotEmpty)
              _buildInfoRow(
                'Played Modes',
                game.gameUserData.playedModes
                    .map((m) => _gameModeLabel(m))
                    .join(', '),
              ),
            if (game.gameUserData.playedPlatforms.isNotEmpty)
              _buildInfoRow(
                'Played On',
                game.gameUserData.playedPlatforms
                    .map((p) => _gamePlatformLabel(p))
                    .join(', '),
              ),
            if (game.gameUserData.playedModes.isEmpty &&
                game.gameUserData.playedPlatforms.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'No game data recorded yet.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
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

  String _gamePlatformLabel(GamePlatform platform) {
    return switch (platform) {
      GamePlatform.pc => 'PC',
      GamePlatform.playStation4 => 'PS4',
      GamePlatform.playStation5 => 'PS5',
      GamePlatform.xbox360 => 'Xbox 360',
      GamePlatform.xboxOne => 'Xbox One',
      GamePlatform.nintendoWii => 'Wii',
      GamePlatform.nintendoSwitch => 'Switch',
      GamePlatform.nintendoSwitch2 => 'Switch 2',
      GamePlatform.steamDeck => 'Steam Deck',
      GamePlatform.mobile => 'Mobile',
    };
  }

  // ============================================================
  // Dialog Methods
  // ============================================================

  void _showEditRatingDialog(GameItem game) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _EditRatingSheet(
        game: game,
        gameService: widget.gameService,
        onSaved: _onDataChanged,
      ),
    );
  }

  void _showEditReviewDialog(GameItem game) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _EditReviewSheet(
        game: game,
        gameService: widget.gameService,
        onSaved: _onDataChanged,
      ),
    );
  }

  void _showEditUserDataDialog(GameItem game) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _EditUserDataSheet(
        game: game,
        gameService: widget.gameService,
        onSaved: _onDataChanged,
      ),
    );
  }

  void _showEditMediaMetadataDialog(GameItem game) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _EditMediaMetadataSheet(
        game: game,
        gameService: widget.gameService,
        onSaved: _onDataChanged,
      ),
    );
  }

  void _showEditGameMetadataDialog(GameItem game) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _EditGameMetadataSheet(
        game: game,
        gameService: widget.gameService,
        onSaved: _onDataChanged,
      ),
    );
  }

  void _showEditGameUserDataDialog(GameItem game) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _EditGameUserDataSheet(
        game: game,
        gameService: widget.gameService,
        onSaved: _onDataChanged,
      ),
    );
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Game?'),
        content: const Text(
          'This will permanently delete this game and all associated data.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await widget.gameService.delete(widget.gameId);
      if (mounted) {
        widget.onGameChanged();
        Navigator.pop(context, true);
      }
    }
  }
}

// ============================================================
// Edit Rating Sheet
// ============================================================

class _EditRatingSheet extends StatefulWidget {
  const _EditRatingSheet({
    required this.game,
    required this.gameService,
    required this.onSaved,
  });

  final GameItem game;
  final GameService gameService;
  final VoidCallback onSaved;

  @override
  State<_EditRatingSheet> createState() => _EditRatingSheetState();
}

class _EditRatingSheetState extends State<_EditRatingSheet> {
  late int? _rating;
  late bool _isLoading;
  final _ratingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _rating = widget.game.media.userData.rating;
    _isLoading = false;
    _ratingController.text = _rating?.toString() ?? '';
  }

  @override
  void dispose() {
    _ratingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
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
              'Edit Rating',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _ratingController,
              decoration: const InputDecoration(
                labelText: 'Rating (0-100)',
                border: OutlineInputBorder(),
                helperText: 'Leave empty for no rating',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _rating = value.isEmpty ? null : int.tryParse(value);
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _isLoading ? null : _save,
                    child: _isLoading
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : const Text('Save'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    setState(() => _isLoading = true);

    try {
      final updatedUserData = widget.game.media.userData.copyWith(
        rating: _rating,
      );

      final updatedMedia = widget.game.media.copyWith(
        userData: updatedUserData,
      );

      final updatedGame = widget.game.copyWith(
        media: updatedMedia,
      );

      await widget.gameService.update(updatedGame);

      if (mounted) {
        widget.onSaved();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rating updated!')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}

// ============================================================
// Edit Review Sheet
// ============================================================

class _EditReviewSheet extends StatefulWidget {
  const _EditReviewSheet({
    required this.game,
    required this.gameService,
    required this.onSaved,
  });

  final GameItem game;
  final GameService gameService;
  final VoidCallback onSaved;

  @override
  State<_EditReviewSheet> createState() => _EditReviewSheetState();
}

class _EditReviewSheetState extends State<_EditReviewSheet> {
  late String? _review;
  late bool _isLoading;
  final _reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _review = widget.game.media.userData.review;
    _isLoading = false;
    _reviewController.text = _review ?? '';
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
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
              'Edit Review',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _reviewController,
              decoration: const InputDecoration(
                labelText: 'Review',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 6,
              onChanged: (value) {
                setState(() {
                  _review = value.isEmpty ? null : value;
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _isLoading ? null : _save,
                    child: _isLoading
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : const Text('Save'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    setState(() => _isLoading = true);

    try {
      final updatedUserData = widget.game.media.userData.copyWith(
        review: _review,
      );

      final updatedMedia = widget.game.media.copyWith(
        userData: updatedUserData,
      );

      final updatedGame = widget.game.copyWith(
        media: updatedMedia,
      );

      await widget.gameService.update(updatedGame);

      if (mounted) {
        widget.onSaved();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Review updated!')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}

// ============================================================
// Edit User Data Sheet (Status, Dates, Tags - NO Rating/Review)
// ============================================================

class _EditUserDataSheet extends StatefulWidget {
  const _EditUserDataSheet({
    required this.game,
    required this.gameService,
    required this.onSaved,
  });

  final GameItem game;
  final GameService gameService;
  final VoidCallback onSaved;

  @override
  State<_EditUserDataSheet> createState() => _EditUserDataSheetState();
}

class _EditUserDataSheetState extends State<_EditUserDataSheet> {
  late MediaStatus _status;
  late DateOnly? _startedOn;
  late DateOnly? _finishedOn;
  late List<Tag> _tags;
  late bool _isLoading;
  final _tagController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _status = widget.game.media.userData.status;
    _startedOn = widget.game.media.userData.startedOn;
    _finishedOn = widget.game.media.userData.finishedOn;
    _tags = List.from(widget.game.media.userData.tags);
    _isLoading = false;
  }

  @override
  void dispose() {
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
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
              'Edit Your Data',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<MediaStatus>(
              initialValue: _status,
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              items: MediaStatus.values.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(StatusUtils.getLabel(status)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) setState(() => _status = value);
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(
                      initialDate: _startedOn,
                      onSelected: (date) => setState(() => _startedOn = date),
                    ),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Started On',
                        border: OutlineInputBorder(),
                      ),
                      child: Text(_startedOn?.toString() ?? 'Not set'),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                if (_startedOn != null)
                  IconButton(
                    onPressed: () => setState(() => _startedOn = null),
                    icon: const Icon(Icons.clear, size: 20),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(
                      initialDate: _finishedOn,
                      onSelected: (date) => setState(() => _finishedOn = date),
                    ),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Finished On',
                        border: OutlineInputBorder(),
                      ),
                      child: Text(_finishedOn?.toString() ?? 'Not set'),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                if (_finishedOn != null)
                  IconButton(
                    onPressed: () => setState(() => _finishedOn = null),
                    icon: const Icon(Icons.clear, size: 20),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _tagController,
              decoration: InputDecoration(
                labelText: 'Add Tag',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addTag,
                ),
              ),
              onFieldSubmitted: (_) => _addTag(),
            ),
            if (_tags.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _tags.map((tag) {
                  return Chip(
                    label: Text(tag.name),
                    onDeleted: () {
                      setState(() {
                        _tags.remove(tag);
                      });
                    },
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _isLoading ? null : _save,
                    child: _isLoading
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : const Text('Save'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _addTag() {
    final name = _tagController.text.trim();
    if (name.isNotEmpty) {
      setState(() {
        _tags.add(Tag(id: -1, name: name));
        _tagController.clear();
      });
    }
  }

  Future<void> _selectDate({
    required DateOnly? initialDate,
    required void Function(DateOnly) onSelected,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate != null
          ? DateTime(initialDate.year, initialDate.month, initialDate.day)
          : DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && mounted) {
      onSelected(DateOnly.fromDateTime(picked));
    }
  }

  Future<void> _save() async {
    setState(() => _isLoading = true);

    try {
      final updatedUserData = widget.game.media.userData.copyWith(
        status: _status,
        startedOn: _startedOn,
        finishedOn: _finishedOn,
        tags: _tags,
      );

      final updatedMedia = widget.game.media.copyWith(
        userData: updatedUserData,
      );

      final updatedGame = widget.game.copyWith(
        media: updatedMedia,
      );

      await widget.gameService.update(updatedGame);

      if (mounted) {
        widget.onSaved();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User data updated!')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}

// ============================================================
// Edit Media Metadata Sheet
// ============================================================

class _EditMediaMetadataSheet extends StatefulWidget {
  const _EditMediaMetadataSheet({
    required this.game,
    required this.gameService,
    required this.onSaved,
  });

  final GameItem game;
  final GameService gameService;
  final VoidCallback onSaved;

  @override
  State<_EditMediaMetadataSheet> createState() =>
      _EditMediaMetadataSheetState();
}

class _EditMediaMetadataSheetState extends State<_EditMediaMetadataSheet> {
  late String _title;
  late String? _description;
  late String? _coverUrl;
  late DateOnly? _releaseDate;
  late List<domain_genre.Genre> _genres;
  late List<domain_theme.Theme> _themes;
  late List<domain_series.Series> _series;
  late bool _isLoading;

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _coverUrlController = TextEditingController();
  final _genreController = TextEditingController();
  final _themeController = TextEditingController();
  final _seriesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _title = widget.game.media.metadata.title;
    _description = widget.game.media.metadata.description;
    _coverUrl = widget.game.media.metadata.coverUrl;
    _releaseDate = widget.game.media.metadata.releaseDate;
    _genres = List.from(widget.game.media.metadata.genres);
    _themes = List.from(widget.game.media.metadata.themes);
    _series = List.from(widget.game.media.metadata.series);
    _isLoading = false;

    _titleController.text = _title;
    _descriptionController.text = _description ?? '';
    _coverUrlController.text = _coverUrl ?? '';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _coverUrlController.dispose();
    _genreController.dispose();
    _themeController.dispose();
    _seriesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
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
              'Edit Media Metadata',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            // Title
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title *',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => _title = value,
            ),
            const SizedBox(height: 12),

            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              onChanged: (value) => _description = value.isEmpty ? null : value,
            ),
            const SizedBox(height: 12),

            // Cover URL
            TextFormField(
              controller: _coverUrlController,
              decoration: const InputDecoration(
                labelText: 'Cover URL',
                border: OutlineInputBorder(),
                helperText: 'Paste a direct image URL',
              ),
              keyboardType: TextInputType.url,
              onChanged: (value) => _coverUrl = value.isEmpty ? null : value,
            ),
            const SizedBox(height: 12),

            // Release Date
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _selectReleaseDate,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Release Date',
                        border: OutlineInputBorder(),
                      ),
                      child: Text(_releaseDate?.toString() ?? 'Not set'),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                if (_releaseDate != null)
                  IconButton(
                    onPressed: () => setState(() => _releaseDate = null),
                    icon: const Icon(Icons.clear, size: 20),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Genres
            _buildTagInput(
              label: 'Genres',
              controller: _genreController,
              items: _genres.map((g) => g.name).toList(),
              onAdd: () => _addGenre(_genreController.text.trim()),
              onRemove: (index) => setState(() => _genres.removeAt(index)),
            ),
            const SizedBox(height: 12),

            // Themes
            _buildTagInput(
              label: 'Themes',
              controller: _themeController,
              items: _themes.map((t) => t.name).toList(),
              onAdd: () => _addTheme(_themeController.text.trim()),
              onRemove: (index) => setState(() => _themes.removeAt(index)),
            ),
            const SizedBox(height: 12),

            // Series
            _buildTagInput(
              label: 'Series',
              controller: _seriesController,
              items: _series.map((s) => s.name).toList(),
              onAdd: () => _addSeries(_seriesController.text.trim()),
              onRemove: (index) => setState(() => _series.removeAt(index)),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _isLoading ? null : _save,
                    child: _isLoading
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : const Text('Save'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTagInput({
    required String label,
    required TextEditingController controller,
    required List<String> items,
    required VoidCallback onAdd,
    required void Function(int) onRemove,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: const Icon(Icons.add),
              onPressed: onAdd,
            ),
          ),
          onFieldSubmitted: (_) => onAdd(),
        ),
        if (items.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Chip(
                label: Text(item),
                onDeleted: () => onRemove(index),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  void _addGenre(String name) {
    if (name.isNotEmpty && !_genres.any((g) => g.name == name)) {
      setState(() {
        _genres.add(domain_genre.Genre(id: -1, name: name));
        _genreController.clear();
      });
    }
  }

  void _addTheme(String name) {
    if (name.isNotEmpty && !_themes.any((t) => t.name == name)) {
      setState(() {
        _themes.add(domain_theme.Theme(id: -1, name: name));
        _themeController.clear();
      });
    }
  }

  void _addSeries(String name) {
    if (name.isNotEmpty && !_series.any((s) => s.name == name)) {
      setState(() {
        _series.add(domain_series.Series(id: -1, name: name));
        _seriesController.clear();
      });
    }
  }

  Future<void> _selectReleaseDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _releaseDate != null
          ? DateTime(_releaseDate!.year, _releaseDate!.month, _releaseDate!.day)
          : DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && mounted) {
      setState(() => _releaseDate = DateOnly.fromDateTime(picked));
    }
  }

  Future<void> _save() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title cannot be empty')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final metadata = MediaMetadata(
        title: _titleController.text.trim(),
        description: _description,
        coverUrl: _coverUrl,
        releaseDate: _releaseDate,
        genres: _genres,
        themes: _themes,
        series: _series,
      );

      await widget.gameService.updateMediaMetadata(widget.game.media.id, metadata);

      if (mounted) {
        widget.onSaved();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Media metadata updated!')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}

// ============================================================
// Edit Game Metadata Sheet
// ============================================================

class _EditGameMetadataSheet extends StatefulWidget {
  const _EditGameMetadataSheet({
    required this.game,
    required this.gameService,
    required this.onSaved,
  });

  final GameItem game;
  final GameService gameService;
  final VoidCallback onSaved;

  @override
  State<_EditGameMetadataSheet> createState() => _EditGameMetadataSheetState();
}

class _EditGameMetadataSheetState extends State<_EditGameMetadataSheet> {
  late List<String> _developerNames;
  late List<String> _publisherNames;
  late bool _isLoading;
  final _developerController = TextEditingController();
  final _publisherController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _developerNames = [];
    _publisherNames = [];
    _isLoading = false;
    _loadContributorNames();
  }

  @override
  void dispose() {
    _developerController.dispose();
    _publisherController.dispose();
    super.dispose();
  }

  Future<void> _loadContributorNames() async {
    final developers = widget.game.gameMetadata.developers;
    final publishers = widget.game.gameMetadata.publishers;

    final devNames = <String>[];
    for (final dev in developers) {
      try {
        final name = await widget.gameService.getContributorName(dev);
        devNames.add(name);
      } catch (_) {
        devNames.add('Unknown');
      }
    }

    final pubNames = <String>[];
    for (final pub in publishers) {
      try {
        final name = await widget.gameService.getContributorName(pub);
        pubNames.add(name);
      } catch (_) {
        pubNames.add('Unknown');
      }
    }

    if (mounted) {
      setState(() {
        _developerNames = devNames;
        _publisherNames = pubNames;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
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
              'Edit Game Metadata',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            // Developers
            _buildTagInput(
              label: 'Developers',
              controller: _developerController,
              items: _developerNames,
              onAdd: () => _addDeveloper(_developerController.text.trim()),
              onRemove: (index) => setState(() => _developerNames.removeAt(index)),
            ),
            const SizedBox(height: 12),

            // Publishers
            _buildTagInput(
              label: 'Publishers',
              controller: _publisherController,
              items: _publisherNames,
              onAdd: () => _addPublisher(_publisherController.text.trim()),
              onRemove: (index) => setState(() => _publisherNames.removeAt(index)),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _isLoading ? null : _save,
                    child: _isLoading
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : const Text('Save'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTagInput({
    required String label,
    required TextEditingController controller,
    required List<String> items,
    required VoidCallback onAdd,
    required void Function(int) onRemove,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: const Icon(Icons.add),
              onPressed: onAdd,
            ),
          ),
          onFieldSubmitted: (_) => onAdd(),
        ),
        if (items.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Chip(
                label: Text(item),
                onDeleted: () => onRemove(index),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  void _addDeveloper(String name) {
    if (name.isNotEmpty && !_developerNames.contains(name)) {
      setState(() {
        _developerNames.add(name);
        _developerController.clear();
      });
    }
  }

  void _addPublisher(String name) {
    if (name.isNotEmpty && !_publisherNames.contains(name)) {
      setState(() {
        _publisherNames.add(name);
        _publisherController.clear();
      });
    }
  }

  Future<void> _save() async {
    setState(() => _isLoading = true);

    try {
      await widget.gameService.updateGameMetadataFromNames(
        widget.game.media.id,
        _developerNames,
        _publisherNames,
      );

      if (mounted) {
        widget.onSaved();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Game metadata updated!')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}

// ============================================================
// Edit Game User Data Sheet
// ============================================================

class _EditGameUserDataSheet extends StatefulWidget {
  const _EditGameUserDataSheet({
    required this.game,
    required this.gameService,
    required this.onSaved,
  });

  final GameItem game;
  final GameService gameService;
  final VoidCallback onSaved;

  @override
  State<_EditGameUserDataSheet> createState() => _EditGameUserDataSheetState();
}

class _EditGameUserDataSheetState extends State<_EditGameUserDataSheet> {
  late Set<GameMode> _playedModes;
  late Set<GamePlatform> _playedPlatforms;
  late bool _isLoading;

  @override
  void initState() {
    super.initState();
    _playedModes = widget.game.gameUserData.playedModes.toSet();
    _playedPlatforms = widget.game.gameUserData.playedPlatforms.toSet();
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
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
              'Edit Your Game Data',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'Played Modes',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: GameMode.values.map((mode) {
                final isSelected = _playedModes.contains(mode);
                return FilterChip(
                  label: Text(_gameModeLabel(mode)),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _playedModes.add(mode);
                      } else {
                        _playedModes.remove(mode);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Text(
              'Played On',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: GamePlatform.values.map((platform) {
                final isSelected = _playedPlatforms.contains(platform);
                return FilterChip(
                  label: Text(_gamePlatformLabel(platform)),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _playedPlatforms.add(platform);
                      } else {
                        _playedPlatforms.remove(platform);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _isLoading ? null : _save,
                    child: _isLoading
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : const Text('Save'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    setState(() => _isLoading = true);

    try {
      final updatedGameUserData = widget.game.gameUserData.copyWith(
        playedModes: _playedModes.toList(),
        playedPlatforms: _playedPlatforms.toList(),
      );

      final updatedGame = widget.game.copyWith(
        gameUserData: updatedGameUserData,
      );

      await widget.gameService.update(updatedGame);

      if (mounted) {
        widget.onSaved();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Game user data updated!')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
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

  String _gamePlatformLabel(GamePlatform platform) {
    return switch (platform) {
      GamePlatform.pc => 'PC',
      GamePlatform.playStation4 => 'PS4',
      GamePlatform.playStation5 => 'PS5',
      GamePlatform.xbox360 => 'Xbox 360',
      GamePlatform.xboxOne => 'Xbox One',
      GamePlatform.nintendoWii => 'Wii',
      GamePlatform.nintendoSwitch => 'Switch',
      GamePlatform.nintendoSwitch2 => 'Switch 2',
      GamePlatform.steamDeck => 'Steam Deck',
      GamePlatform.mobile => 'Mobile',
    };
  }
}