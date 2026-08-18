import 'package:cybershelf/domain/game/game_mode.dart';
import 'package:cybershelf/domain/game/game_platform.dart';
import 'package:cybershelf/domain/media/contributor.dart';

class Game {
  const Game({
    required this.mediaId,
    this.developers = const [],
    this.publishers = const [],
    this.availableModes = const {},
    this.playedModes = const {},
    this.playedPlatforms = const {},
  });

  final int mediaId;

  final List<Contributor> developers;
  final List<Contributor> publishers;

  final Set<GameMode> availableModes;
  final Set<GameMode> playedModes;
  final Set<GamePlatform> playedPlatforms;
}