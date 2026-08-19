import 'package:flutter_test/flutter_test.dart';
import 'package:cybershelf/domain/game/game_user_data.dart';
import 'package:cybershelf/domain/game/game_mode.dart';
import 'package:cybershelf/domain/game/game_platform.dart';

void main() {
  group('GameUserData', () {
    test('can be created with optional values', () {
      const playedModes = [GameMode.cooperative];
      const playedPlatforms = [GamePlatform.pc, GamePlatform.nintendoSwitch];

      const userData = GameUserData(
        playedModes: playedModes,
        playedPlatforms: playedPlatforms,
      );

      expect(userData.playedModes, playedModes);
      expect(userData.playedPlatforms, playedPlatforms);
    });

    test('defaults collections to empty lists', () {
      const userData = GameUserData();

      expect(userData.playedModes, isEmpty);
      expect(userData.playedPlatforms, isEmpty);
    });

    test('copyWith leaves unspecified values unchanged', () {
      const original = GameUserData(
        playedModes: [GameMode.cooperative],
        playedPlatforms: [GamePlatform.pc],
      );

      final copy = original.copyWith(
        playedPlatforms: [GamePlatform.steamDeck],
      );

      expect(copy.playedModes, original.playedModes);
      expect(copy.playedPlatforms, [GamePlatform.steamDeck]);
    });

    test('copyWith can replace played modes', () {
      const original = GameUserData(
        playedModes: [GameMode.singlePlayer],
      );

      const replacement = [GameMode.competitive];

      final copy = original.copyWith(playedModes: replacement);

      expect(copy.playedModes, replacement);
    });
  });
}