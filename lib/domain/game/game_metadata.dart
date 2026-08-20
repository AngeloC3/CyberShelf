import 'package:cybershelf/domain/media/contributor.dart';

/// Game-specific metadata: facts about the game itself.
///
/// Composed alongside `MediaMetadata` on a `GameItem` rather than
/// replacing it. Developers and publishers reference [Contributor]
/// (person or company) via the game_developers / game_publishers
/// join tables.
class GameMetadata {
  const GameMetadata({
    this.developers = const [],
    this.publishers = const [],
  });

  final List<Contributor> developers;
  final List<Contributor> publishers;

  GameMetadata copyWith({
    List<Contributor>? developers,
    List<Contributor>? publishers,
  }) {
    return GameMetadata(
      developers: developers ?? this.developers,
      publishers: publishers ?? this.publishers,
    );
  }
}