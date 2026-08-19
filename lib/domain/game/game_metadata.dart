import 'package:cybershelf/domain/game/game_mode.dart';
import 'package:cybershelf/domain/media/contributor.dart';

/// Game-specific metadata: facts about the game itself.
///
/// Composed alongside `MediaMetadata` on a `GameItem` rather than
/// replacing it. Developers and publishers reference [Contributor]
/// (person or company) via the game_developers / game_publishers
/// join tables.
class GameMetadata {
  const GameMetadata({
    this.availableModes = const [],
    this.developers = const [],
    this.publishers = const [],
  });

  final List<GameMode> availableModes;
  final List<Contributor> developers;
  final List<Contributor> publishers;

  GameMetadata copyWith({
    List<GameMode>? availableModes,
    List<Contributor>? developers,
    List<Contributor>? publishers,
  }) {
    return GameMetadata(
      availableModes: availableModes ?? this.availableModes,
      developers: developers ?? this.developers,
      publishers: publishers ?? this.publishers,
    );
  }
}