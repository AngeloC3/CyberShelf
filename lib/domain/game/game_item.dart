import 'package:cybershelf/domain/game/game_mode.dart';
import 'package:cybershelf/domain/game/game_platform.dart';
import 'package:cybershelf/domain/media/contributor.dart';
import 'package:cybershelf/domain/media/media_item.dart';
import 'package:cybershelf/domain/media_type.dart';

class GameItem extends MediaItem {
  const GameItem({
    required super.id,
    required super.metadata,
    required super.userData,
    this.developers = const [],
    this.publishers = const [],
    this.availableModes = const {},
    this.playedModes = const {},
    this.playedPlatforms = const {},
  }) : super(
    type: MediaType.game,
  );

  final List<Contributor> developers;
  final List<Contributor> publishers;

  final Set<GameMode> availableModes;
  final Set<GameMode> playedModes;
  final Set<GamePlatform> playedPlatforms;
}