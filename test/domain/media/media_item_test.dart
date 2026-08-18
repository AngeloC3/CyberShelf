import 'package:flutter_test/flutter_test.dart';
import 'package:cybershelf/domain/media/media_item.dart';
import 'package:cybershelf/domain/media/media_metadata.dart';
import 'package:cybershelf/domain/media/media_user_data.dart';
import 'package:cybershelf/domain/game/game_item.dart';
import 'package:cybershelf/domain/media_status.dart';
import 'package:cybershelf/domain/media_type.dart';

void main() {
  group('MediaItem', () {
    test('GameItem can be used as a MediaItem', () {
      const item = GameItem(
        id: 1,
        metadata: MediaMetadata(
          title: 'Test Game',
        ),
        userData: MediaUserData(
          status: MediaStatus.planned,
        ),
      );

      final MediaItem mediaItem = item;

      expect(mediaItem.id, 1);
      expect(mediaItem.type, MediaType.game);
      expect(mediaItem.metadata.title, 'Test Game');
      expect(mediaItem.userData.status, MediaStatus.planned);
    });

    test('MediaItem reference preserves the concrete GameItem', () {
      const item = GameItem(
        id: 1,
        metadata: MediaMetadata(
          title: 'Test Game',
        ),
        userData: MediaUserData(
          status: MediaStatus.planned,
        ),
      );

      final MediaItem mediaItem = item;

      expect(mediaItem, isA<GameItem>());
    });
  });
}