import 'package:flutter/material.dart';
import 'package:cybershelf/application/game/game_service.dart';
import 'package:cybershelf/domain/date_only.dart';
import 'package:cybershelf/domain/game/game_item.dart';
import 'package:cybershelf/domain/game/game_mode.dart';
import 'package:cybershelf/domain/game/game_platform.dart';
import 'package:cybershelf/domain/media/tag.dart';
import 'package:cybershelf/domain/media_status.dart';

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
              _buildStatusChip(game.media.userData.status),
              if (game.media.userData.rating != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      '${game.media.userData.rating}/100',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(MediaStatus status) {
    final label = switch (status) {
      MediaStatus.planned => 'Planned',
      MediaStatus.inProgress => 'In Progress',
      MediaStatus.completed => 'Completed',
      MediaStatus.dropped => 'Dropped',
    };

    final color = switch (status) {
      MediaStatus.planned => Colors.blue,
      MediaStatus.inProgress => Colors.orange,
      MediaStatus.completed => Colors.green,
      MediaStatus.dropped => Colors.red,
    };

    return Chip(
      label: Text(label),
      backgroundColor: color.withAlpha(51),
      side: BorderSide.none,
    );
  }

  Widget _buildMetadataSection(GameItem game) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Media Metadata',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Title', game.media.metadata.title),
            if (game.media.metadata.description != null)
              _buildInfoRow('Description', game.media.metadata.description!),
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
            _buildInfoRow('Status', _statusLabel(game.media.userData.status)),
            if (game.media.userData.rating != null)
              _buildInfoRow('Rating', '${game.media.userData.rating}/100'),
            if (game.media.userData.startedOn != null)
              _buildInfoRow('Started', game.media.userData.startedOn.toString()),
            if (game.media.userData.finishedOn != null)
              _buildInfoRow('Finished', game.media.userData.finishedOn.toString()),
            if (game.media.userData.review != null)
              _buildInfoRow('Review', game.media.userData.review!),
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
            if (game.gameMetadata.availableModes.isNotEmpty)
              _buildInfoRow(
                'Available Modes',
                game.gameMetadata.availableModes
                    .map((m) => _gameModeLabel(m))
                    .join(', '),
              ),
            if (game.gameMetadata.developers.isNotEmpty)
              _buildInfoRow(
                'Developers',
                game.gameMetadata.developers.map((d) =>
                d.isPerson ? 'Person ID: ${d.personId}' : 'Company ID: ${d.companyId}'
                ).join(', '),
              ),
            if (game.gameMetadata.publishers.isNotEmpty)
              _buildInfoRow(
                'Publishers',
                game.gameMetadata.publishers.map((p) =>
                p.isPerson ? 'Person ID: ${p.personId}' : 'Company ID: ${p.companyId}'
                ).join(', '),
              ),
            if (game.gameMetadata.availableModes.isEmpty &&
                game.gameMetadata.developers.isEmpty &&
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

  String _statusLabel(MediaStatus status) {
    return switch (status) {
      MediaStatus.planned => 'Planned',
      MediaStatus.inProgress => 'In Progress',
      MediaStatus.completed => 'Completed',
      MediaStatus.dropped => 'Dropped',
    };
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

// ==================== Edit User Data Sheet ====================

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
  late int? _rating;
  late DateOnly? _startedOn;
  late DateOnly? _finishedOn;
  late String? _review;
  late List<Tag> _tags;
  late bool _isLoading;
  final _ratingController = TextEditingController();
  final _reviewController = TextEditingController();
  final _tagController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _status = widget.game.media.userData.status;
    _rating = widget.game.media.userData.rating;
    _startedOn = widget.game.media.userData.startedOn;
    _finishedOn = widget.game.media.userData.finishedOn;
    _review = widget.game.media.userData.review;
    _tags = List.from(widget.game.media.userData.tags);
    _isLoading = false;
    _ratingController.text = _rating?.toString() ?? '';
    _reviewController.text = _review ?? '';
  }

  @override
  void dispose() {
    _ratingController.dispose();
    _reviewController.dispose();
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
                child: Text(_statusLabel(status)),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) setState(() => _status = value);
            },
          ),
          const SizedBox(height: 12),
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
            controller: _reviewController,
            decoration: const InputDecoration(
              labelText: 'Review',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            maxLines: 4,
            onChanged: (value) {
              setState(() {
                _review = value.isEmpty ? null : value;
              });
            },
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
        rating: _rating,
        startedOn: _startedOn,
        finishedOn: _finishedOn,
        review: _review,
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

  String _statusLabel(MediaStatus status) {
    return switch (status) {
      MediaStatus.planned => 'Planned',
      MediaStatus.inProgress => 'In Progress',
      MediaStatus.completed => 'Completed',
      MediaStatus.dropped => 'Dropped',
    };
  }
}

// ==================== Edit Game Metadata Sheet ====================

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
  late Set<GameMode> _availableModes;
  late bool _isLoading;

  @override
  void initState() {
    super.initState();
    _availableModes = widget.game.gameMetadata.availableModes.toSet();
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
          const SizedBox(height: 8),
          Text(
            'Note: Developers and Publishers cannot be edited yet.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Available Modes',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: GameMode.values.map((mode) {
              final isSelected = _availableModes.contains(mode);
              return FilterChip(
                label: Text(_gameModeLabel(mode)),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _availableModes.add(mode);
                    } else {
                      _availableModes.remove(mode);
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
    );
  }

  Future<void> _save() async {
    setState(() => _isLoading = true);

    try {
      final updatedGameMetadata = widget.game.gameMetadata.copyWith(
        availableModes: _availableModes.toList(),
      );

      final updatedGame = widget.game.copyWith(
        gameMetadata: updatedGameMetadata,
      );

      await widget.gameService.update(updatedGame);

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
}

// ==================== Edit Game User Data Sheet ====================

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