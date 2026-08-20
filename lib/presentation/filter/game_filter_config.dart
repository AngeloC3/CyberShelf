import 'package:cybershelf/domain/game/game_item.dart';
import 'package:cybershelf/domain/game/game_mode.dart';
import 'package:cybershelf/domain/game/game_platform.dart';
import 'package:cybershelf/domain/media_status.dart';
import 'package:cybershelf/presentation/filter/filter_models.dart';

class GameFilterField extends FilterField {
  const GameFilterField(super.id, super.label, super.fieldType);

  static const title = GameFilterField('title', 'Title', FilterFieldType.text);
  static const status = GameFilterField('status', 'Status', FilterFieldType.select);
  static const rating = GameFilterField('rating', 'Rating', FilterFieldType.number);
  static const genre = GameFilterField('genre', 'Genre', FilterFieldType.text);
  static const tag = GameFilterField('tag', 'Tag', FilterFieldType.text);
  static const developer = GameFilterField('developer', 'Developer', FilterFieldType.text);
  static const publisher = GameFilterField('publisher', 'Publisher', FilterFieldType.text);
  static const releaseDate = GameFilterField('releaseDate', 'Release Date', FilterFieldType.date);
  static const playedPlatform = GameFilterField('playedPlatform', 'Played Platform', FilterFieldType.text);
  static const availableMode = GameFilterField('availableMode', 'Available Mode', FilterFieldType.text);

  static const List<FilterField> all = [
    title,
    status,
    rating,
    genre,
    tag,
    developer,
    publisher,
    releaseDate,
    playedPlatform,
    availableMode,
  ];

  static FilterField fromId(String id) {
    return all.firstWhere((f) => f.id == id);
  }
}

class GameFilterEvaluator implements FilterEvaluator<GameItem> {
  const GameFilterEvaluator();

  @override
  List<FilterField> get availableFields => GameFilterField.all;

  @override
  List<String> getSelectOptions(FilterField field) {
    if (field.id == GameFilterField.status.id) {
      return MediaStatus.values.map((s) => _statusLabel(s)).toList();
    }
    return [];
  }

  @override
  bool evaluate(GameItem game, FilterCondition condition) {
    final value = condition.value;
    final value2 = condition.value2;

    switch (condition.field.id) {
      case 'title':
        final title = game.media.metadata.title.toLowerCase();
        final searchValue = value?.toString().toLowerCase() ?? '';
        switch (condition.operator) {
          case FilterOperator.contains:
            return title.contains(searchValue);
          case FilterOperator.equals:
            return title == searchValue;
          case FilterOperator.notEquals:
            return title != searchValue;
          case FilterOperator.startsWith:
            return title.startsWith(searchValue);
          case FilterOperator.endsWith:
            return title.endsWith(searchValue);
          default:
            return true;
        }

      case 'status':
        final status = _statusLabel(game.media.userData.status);
        switch (condition.operator) {
          case FilterOperator.equals:
            return status == value;
          case FilterOperator.notEquals:
            return status != value;
          default:
            return true;
        }

      case 'rating':
        final rating = game.media.userData.rating;
        final numValue = double.tryParse(value?.toString() ?? '') ?? 0;
        final numValue2 = double.tryParse(value2?.toString() ?? '') ?? 0;
        switch (condition.operator) {
          case FilterOperator.greaterThan:
            return (rating ?? -1) > numValue;
          case FilterOperator.lessThan:
            return (rating ?? -1) < numValue;
          case FilterOperator.between:
            return (rating ?? -1) >= numValue && (rating ?? -1) <= numValue2;
          case FilterOperator.equals:
            return (rating ?? -1) == numValue;
          case FilterOperator.notEquals:
            return (rating ?? -1) != numValue;
          default:
            return true;
        }

      case 'genre':
        final genres = game.media.metadata.genres.map((g) => g.name.toLowerCase()).toList();
        final searchValue = value?.toString().toLowerCase() ?? '';
        switch (condition.operator) {
          case FilterOperator.contains:
            return genres.any((g) => g.contains(searchValue));
          case FilterOperator.equals:
            return genres.contains(searchValue);
          case FilterOperator.notEquals:
            return !genres.contains(searchValue);
          default:
            return true;
        }

      case 'tag':
        final tags = game.media.userData.tags.map((t) => t.name.toLowerCase()).toList();
        final searchValue = value?.toString().toLowerCase() ?? '';
        switch (condition.operator) {
          case FilterOperator.contains:
            return tags.any((t) => t.contains(searchValue));
          case FilterOperator.equals:
            return tags.contains(searchValue);
          case FilterOperator.notEquals:
            return !tags.contains(searchValue);
          default:
            return true;
        }

      case 'developer':
      case 'publisher':
      // These need contributor name resolution - skip for now
        return true;

      case 'releaseDate':
      // Date filtering - skip for now
        return true;

      case 'playedPlatform':
        final platforms = game.gameUserData.playedPlatforms.map((p) => _platformLabel(p)).toList();
        final searchValue = value?.toString().toLowerCase() ?? '';
        switch (condition.operator) {
          case FilterOperator.contains:
            return platforms.any((p) => p.toLowerCase().contains(searchValue));
          case FilterOperator.equals:
            return platforms.contains(searchValue);
          case FilterOperator.notEquals:
            return !platforms.contains(searchValue);
          default:
            return true;
        }

      case 'availableMode':
        final modes = game.gameMetadata.availableModes.map((m) => _modeLabel(m)).toList();
        final searchValue = value?.toString().toLowerCase() ?? '';
        switch (condition.operator) {
          case FilterOperator.contains:
            return modes.any((m) => m.toLowerCase().contains(searchValue));
          case FilterOperator.equals:
            return modes.contains(searchValue);
          case FilterOperator.notEquals:
            return !modes.contains(searchValue);
          default:
            return true;
        }

      default:
        return true;
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

  String _modeLabel(GameMode mode) {
    return switch (mode) {
      GameMode.singlePlayer => 'Single Player',
      GameMode.multiplayer => 'Multiplayer',
      GameMode.cooperative => 'Co-op',
      GameMode.competitive => 'Competitive',
      GameMode.localMultiplayer => 'Local MP',
      GameMode.onlineMultiplayer => 'Online MP',
    };
  }

  String _platformLabel(GamePlatform platform) {
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