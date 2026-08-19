import 'package:flutter/material.dart';
import 'package:cybershelf/application/game/game_service.dart';
import 'package:cybershelf/domain/date_only.dart';
import 'package:cybershelf/domain/game/game_mode.dart';
import 'package:cybershelf/domain/game/game_platform.dart';
import 'package:cybershelf/domain/media_status.dart';
import 'package:cybershelf/presentation/game/game_detail_page.dart';

class ManualAddGamePage extends StatefulWidget {
  const ManualAddGamePage({
    super.key,
    required this.gameService,
    this.onGameAdded,
  });

  final GameService gameService;
  final VoidCallback? onGameAdded;

  @override
  State<ManualAddGamePage> createState() => _ManualAddGamePageState();
}

class _ManualAddGamePageState extends State<ManualAddGamePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _coverUrlController = TextEditingController();
  final _genreController = TextEditingController();
  final _themeController = TextEditingController();
  final _developerController = TextEditingController();
  final _publisherController = TextEditingController();

  DateTime? _releaseDate;
  MediaStatus _status = MediaStatus.planned;
  final List<String> _genres = [];
  final List<String> _themes = [];
  final List<String> _developers = [];
  final List<String> _publishers = [];
  final Set<GameMode> _availableModes = {};
  final Set<GameMode> _playedModes = {};
  final Set<GamePlatform> _playedPlatforms = {};
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _coverUrlController.dispose();
    _genreController.dispose();
    _themeController.dispose();
    _developerController.dispose();
    _publisherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Game Manually'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveGame,
            child: const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 16),

              // Cover URL
              TextFormField(
                controller: _coverUrlController,
                decoration: const InputDecoration(
                  labelText: 'Cover URL',
                  border: OutlineInputBorder(),
                  helperText: 'Paste a direct image URL',
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 16),

              // Release Date
              InkWell(
                onTap: _selectReleaseDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Release Date',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    _releaseDate != null
                        ? DateOnly.fromDateTime(_releaseDate!).toString()
                        : 'Not set',
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Status
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
              const SizedBox(height: 16),

              // Genres
              _buildTagInput(
                label: 'Genres',
                controller: _genreController,
                items: _genres,
                onAdd: () => _addItem(_genreController, _genres),
                onRemove: (index) => setState(() => _genres.removeAt(index)),
              ),
              const SizedBox(height: 16),

              // Themes
              _buildTagInput(
                label: 'Themes',
                controller: _themeController,
                items: _themes,
                onAdd: () => _addItem(_themeController, _themes),
                onRemove: (index) => setState(() => _themes.removeAt(index)),
              ),
              const SizedBox(height: 16),

              // Developers
              _buildTagInput(
                label: 'Developers',
                controller: _developerController,
                items: _developers,
                onAdd: () => _addItem(_developerController, _developers),
                onRemove: (index) => setState(() => _developers.removeAt(index)),
              ),
              const SizedBox(height: 16),

              // Publishers
              _buildTagInput(
                label: 'Publishers',
                controller: _publisherController,
                items: _publishers,
                onAdd: () => _addItem(_publisherController, _publishers),
                onRemove: (index) => setState(() => _publishers.removeAt(index)),
              ),
              const SizedBox(height: 16),

              // Available Modes
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

              // Played Modes
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

              // Played Platforms
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
              const SizedBox(height: 32),

              if (_isLoading)
                const Center(child: CircularProgressIndicator()),
            ],
          ),
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

  void _addItem(TextEditingController controller, List<String> items) {
    final value = controller.text.trim();
    if (value.isNotEmpty) {
      setState(() {
        items.add(value);
        controller.clear();
      });
    }
  }

  Future<void> _selectReleaseDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _releaseDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && mounted) {
      setState(() => _releaseDate = picked);
    }
  }

  Future<void> _saveGame() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final game = await widget.gameService.createManual(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        coverUrl: _coverUrlController.text.trim().isEmpty
            ? null
            : _coverUrlController.text.trim(),
        releaseDate: _releaseDate != null
            ? DateOnly.fromDateTime(_releaseDate!)
            : null,
        genreNames: _genres,
        themeNames: _themes,
        developerNames: _developers,
        publisherNames: _publishers,
        availableModes: _availableModes.toList(),
        playedModes: _playedModes.toList(),
        playedPlatforms: _playedPlatforms.toList(),
        status: _status,
      );

      if (mounted) {
        widget.onGameAdded?.call();
        Navigator.pop(context);
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
          const SnackBar(content: Text('Game added successfully!')),
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
}