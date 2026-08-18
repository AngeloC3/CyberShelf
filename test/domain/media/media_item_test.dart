import 'package:flutter_test/flutter_test.dart';
import 'package:cybershelf/domain/media/media_item.dart';
import 'package:cybershelf/domain/media/media_metadata.dart';
import 'package:cybershelf/domain/media/media_user_data.dart';
import 'package:cybershelf/domain/media_status.dart';
import 'package:cybershelf/domain/media_type.dart';

void main() {
  group('MediaItem', () {
    test('can be created with metadata and user data', () {
      const item = MediaItem(
        id: 1,
        type: MediaType.game,
        metadata: MediaMetadata(
          title: 'Test Game',
        ),
        userData: MediaUserData(
          status: MediaStatus.planned,
        ),
      );

      expect(item.id, 1);
      expect(item.type, MediaType.game);
      expect(item.metadata.title, 'Test Game');
      expect(item.userData.status, MediaStatus.planned);
    });

    test('copyWith leaves unspecified values unchanged', () {
      const original = MediaItem(
        id: 1,
        type: MediaType.game,
        metadata: MediaMetadata(
          title: 'Test Game',
        ),
        userData: MediaUserData(
          status: MediaStatus.planned,
        ),
      );

      final copy = original.copyWith(
        metadata: const MediaMetadata(
          title: 'Updated Game',
        ),
      );

      expect(copy.id, original.id);
      expect(copy.type, original.type);
      expect(copy.metadata.title, 'Updated Game');
      expect(copy.userData, original.userData);
    });
  });
}