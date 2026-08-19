import 'package:flutter_test/flutter_test.dart';
import 'package:cybershelf/domain/game/game_item.dart';
import 'package:cybershelf/domain/game/game_metadata.dart';
import 'package:cybershelf/domain/game/game_user_data.dart';
import 'package:cybershelf/domain/game/game_mode.dart';
import 'package:cybershelf/domain/media/media_item.dart';
import 'package:cybershelf/domain/media/media_metadata.dart';
import 'package:cybershelf/domain/media/media_user_data.dart';
import 'package:cybershelf/domain/media_status.dart';
import 'package:cybershelf/domain/media_type.dart';

void main() {
  group('GameItem', () {
    test('composes a MediaItem with game metadata and user data', () {
      const media = MediaItem(
        id: 1,
        type: MediaType.game,
        metadata: MediaMetadata(title: 'Test Game'),
        userData: MediaUserData(status: MediaStatus.planned),
      );

      const gameMetadata = GameMetadata(
        availableModes: [GameMode.singlePlayer, GameMode.cooperative],
      );

      const gameUserData = GameUserData(
        playedModes: [GameMode.cooperative],
      );

      const item = GameItem(
        media: media,
        gameMetadata: gameMetadata,
        gameUserData: gameUserData,
      );

      expect(item.media, media);
      expect(item.gameMetadata, gameMetadata);
      expect(item.gameUserData, gameUserData);
    });

    test('copyWith leaves unspecified values unchanged', () {
      const original = GameItem(
        media: MediaItem(
          id: 1,
          type: MediaType.game,
          metadata: MediaMetadata(title: 'Test Game'),
          userData: MediaUserData(status: MediaStatus.planned),
        ),
        gameMetadata: GameMetadata(
          availableModes: [GameMode.singlePlayer],
        ),
        gameUserData: GameUserData(
          playedModes: [GameMode.singlePlayer],
        ),
      );

      final copy = original.copyWith(
        gameUserData: const GameUserData(
          playedModes: [GameMode.singlePlayer, GameMode.multiplayer],
        ),
      );

      expect(copy.media, original.media);
      expect(copy.gameMetadata, original.gameMetadata);
      expect(
        copy.gameUserData.playedModes,
        [GameMode.singlePlayer, GameMode.multiplayer],
      );
    });

    test('copyWith can replace the underlying MediaItem', () {
      const original = GameItem(
        media: MediaItem(
          id: 1,
          type: MediaType.game,
          metadata: MediaMetadata(title: 'Original Title'),
          userData: MediaUserData(status: MediaStatus.planned),
        ),
        gameMetadata: GameMetadata(),
        gameUserData: GameUserData(),
      );

      final updatedMedia = original.media.copyWith(
        metadata: original.media.metadata.copyWith(title: 'Updated Title'),
      );

      final copy = original.copyWith(media: updatedMedia);

      expect(copy.media.metadata.title, 'Updated Title');
      expect(copy.gameMetadata, original.gameMetadata);
      expect(copy.gameUserData, original.gameUserData);
    });
  });
}