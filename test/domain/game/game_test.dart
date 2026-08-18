import 'package:flutter_test/flutter_test.dart';
import 'package:cybershelf/domain/game/game.dart';
import 'package:cybershelf/domain/game/game_mode.dart';
import 'package:cybershelf/domain/game/game_platform.dart';
import 'package:cybershelf/domain/media/contributor.dart';

void main() {
  group('Game', () {
    test('can be created with default values', () {
      const game = Game(
        mediaId: 1,
      );

      expect(game.mediaId, 1);
      expect(game.developers, isEmpty);
      expect(game.publishers, isEmpty);
      expect(game.availableModes, isEmpty);
      expect(game.playedModes, isEmpty);
      expect(game.playedPlatforms, isEmpty);
    });

    test('stores developers', () {
      const developers = [
        Contributor(
          id: 1,
          companyId: 10,
        ),
        Contributor(
          id: 2,
          companyId: 20,
        ),
      ];

      const game = Game(
        mediaId: 1,
        developers: developers,
      );

      expect(game.developers, hasLength(2));
      expect(game.developers[0].id, 1);
      expect(game.developers[0].companyId, 10);
      expect(game.developers[1].id, 2);
      expect(game.developers[1].companyId, 20);
    });

    test('stores publishers', () {
      const publishers = [
        Contributor(
          id: 1,
          companyId: 10,
        ),
      ];

      const game = Game(
        mediaId: 1,
        publishers: publishers,
      );

      expect(game.publishers, hasLength(1));
      expect(game.publishers.first.id, 1);
      expect(game.publishers.first.companyId, 10);
    });

    test('stores available modes', () {
      final game = Game(
        mediaId: 1,
        availableModes: {
          GameMode.singlePlayer,
          GameMode.multiplayer,
        },
      );

      expect(game.availableModes, hasLength(2));
      expect(
        game.availableModes,
        contains(GameMode.singlePlayer),
      );
      expect(
        game.availableModes,
        contains(GameMode.multiplayer),
      );
    });

    test('stores played modes', () {
      final game = Game(
        mediaId: 1,
        playedModes: {
          GameMode.singlePlayer,
        },
      );

      expect(game.playedModes, hasLength(1));
      expect(
        game.playedModes,
        contains(GameMode.singlePlayer),
      );
    });

    test('stores played platforms', () {
      final game = Game(
        mediaId: 1,
        playedPlatforms: {
          GamePlatform.pc,
          GamePlatform.playStation5,
        },
      );

      expect(game.playedPlatforms, hasLength(2));
      expect(
        game.playedPlatforms,
        contains(GamePlatform.pc),
      );
      expect(
        game.playedPlatforms,
        contains(GamePlatform.playStation5),
      );
    });

    test('stores complete game data', () {
      final game = Game(
        mediaId: 42,
        developers: const [
          Contributor(
            id: 1,
            companyId: 10,
          ),
        ],
        publishers: const [
          Contributor(
            id: 2,
            companyId: 20,
          ),
        ],
        availableModes: {
          GameMode.singlePlayer,
          GameMode.multiplayer,
        },
        playedModes: {
          GameMode.singlePlayer,
        },
        playedPlatforms: {
          GamePlatform.pc,
        },
      );

      expect(game.mediaId, 42);

      expect(game.developers, hasLength(1));
      expect(game.developers.first.id, 1);

      expect(game.publishers, hasLength(1));
      expect(game.publishers.first.id, 2);

      expect(game.availableModes, {
        GameMode.singlePlayer,
        GameMode.multiplayer,
      });

      expect(game.playedModes, {
        GameMode.singlePlayer,
      });

      expect(game.playedPlatforms, {
        GamePlatform.pc,
      });
    });
  });
}