import 'package:flutter_test/flutter_test.dart';
import 'package:cybershelf/application/media/media_service.dart';
import 'package:cybershelf/domain/media/media_metadata.dart';
import 'package:cybershelf/domain/media/media_user_data.dart';
import 'package:cybershelf/domain/media_status.dart';
import 'package:cybershelf/domain/media_type.dart';

import '../../helpers/fake_media_repository.dart';

void main() {
  group('MediaService', () {
    test('create creates media through the repository', () async {
      final repository = FakeMediaRepository();
      final service = MediaService(repository);

      const metadata = MediaMetadata(
        title: 'Test Game',
      );

      const userData = MediaUserData(
        status: MediaStatus.planned,
      );

      final result = await service.create(
        type: MediaType.game,
        metadata: metadata,
        userData: userData,
      );

      expect(result.id, 1);
      expect(result.type, MediaType.game);
      expect(result.metadata, metadata);
      expect(result.userData, userData);

      expect(repository.createCallCount, 1);
      expect(repository.createdType, MediaType.game);
      expect(repository.createdMetadata, metadata);
      expect(repository.createdUserData, userData);
    });

    test('update updates media through the repository', () async {
      final repository = FakeMediaRepository();

      final original = await repository.create(
        type: MediaType.game,
        metadata: const MediaMetadata(
          title: 'Original Title',
        ),
        userData: const MediaUserData(
          status: MediaStatus.planned,
        ),
      );

      final service = MediaService(repository);

      final updated = original.copyWith(
        metadata: original.metadata.copyWith(
          title: 'Updated Title',
        ),
        userData: original.userData.copyWith(
          status: MediaStatus.completed,
        ),
      );

      final result = await service.update(updated);

      expect(result, updated);
      expect(repository.updateCallCount, 1);
      expect(repository.updatedMedia, updated);

      final stored = await repository.getById(original.id);

      expect(stored, updated);
    });

    test('getById gets media through the repository', () async {
      final repository = FakeMediaRepository();

      final created = await repository.create(
        type: MediaType.game,
        metadata: const MediaMetadata(
          title: 'Test Game',
        ),
        userData: const MediaUserData(
          status: MediaStatus.planned,
        ),
      );

      final service = MediaService(repository);

      final result = await service.getById(created.id);

      expect(result, created);
      expect(repository.getByIdCallCount, 1);
      expect(repository.requestedId, created.id);
    });

    test('getAll gets all media through the repository', () async {
      final repository = FakeMediaRepository();

      final first = await repository.create(
        type: MediaType.game,
        metadata: const MediaMetadata(
          title: 'First Game',
        ),
        userData: const MediaUserData(
          status: MediaStatus.planned,
        ),
      );

      final second = await repository.create(
        type: MediaType.game,
        metadata: const MediaMetadata(
          title: 'Second Game',
        ),
        userData: const MediaUserData(
          status: MediaStatus.completed,
        ),
      );

      final service = MediaService(repository);

      final result = await service.getAll();

      expect(result, [first, second]);
      expect(repository.getAllCallCount, 1);
    });

    test('delete deletes media through the repository', () async {
      final repository = FakeMediaRepository();

      final created = await repository.create(
        type: MediaType.game,
        metadata: const MediaMetadata(
          title: 'Test Game',
        ),
        userData: const MediaUserData(
          status: MediaStatus.planned,
        ),
      );

      final service = MediaService(repository);

      await service.delete(created.id);

      expect(repository.deleteCallCount, 1);
      expect(repository.deletedId, created.id);
      expect(await repository.getById(created.id), isNull);
    });
  });
}