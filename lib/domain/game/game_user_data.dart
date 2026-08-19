import 'package:cybershelf/domain/game/game_mode.dart';
import 'package:cybershelf/domain/game/game_platform.dart';

/// Game-specific user data: what the user actually did.
///
/// `playedModes` overlaps in shape with `GameMetadata.availableModes`
/// but is user data, not metadata — "I played co-op" describes the
/// user, not the game.
class GameUserData {
  const GameUserData({
    this.playedModes = const [],
    this.playedPlatforms = const [],
  });

  final List<GameMode> playedModes;
  final List<GamePlatform> playedPlatforms;

  GameUserData copyWith({
    List<GameMode>? playedModes,
    List<GamePlatform>? playedPlatforms,
  }) {
    return GameUserData(
      playedModes: playedModes ?? this.playedModes,
      playedPlatforms: playedPlatforms ?? this.playedPlatforms,
    );
  }
}