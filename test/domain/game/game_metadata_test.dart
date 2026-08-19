import 'package:flutter_test/flutter_test.dart';
import 'package:cybershelf/domain/game/game_metadata.dart';
import 'package:cybershelf/domain/game/game_mode.dart';
import 'package:cybershelf/domain/media/contributor.dart';

void main() {
  group('GameMetadata', () {
    test('can be created with required and optional values', () {
      const availableModes = [
        GameMode.singlePlayer,
        GameMode.cooperative,
      ];

      const developers = [
        Contributor(id: 1, personId: 10),
      ];

      const publishers = [
        Contributor(id: 2, companyId: 20),
      ];

      const metadata = GameMetadata(
        availableModes: availableModes,
        developers: developers,
        publishers: publishers,
      );

      expect(metadata.availableModes, availableModes);
      expect(metadata.developers, developers);
      expect(metadata.publishers, publishers);
    });

    test('defaults collections to empty lists', () {
      const metadata = GameMetadata();

      expect(metadata.availableModes, isEmpty);
      expect(metadata.developers, isEmpty);
      expect(metadata.publishers, isEmpty);
    });

    test('copyWith leaves unspecified values unchanged', () {
      const original = GameMetadata(
        availableModes: [GameMode.singlePlayer],
        developers: [Contributor(id: 1, personId: 10)],
        publishers: [Contributor(id: 2, companyId: 20)],
      );

      final copy = original.copyWith(
        availableModes: [GameMode.multiplayer],
      );

      expect(copy.availableModes, [GameMode.multiplayer]);
      expect(copy.developers, original.developers);
      expect(copy.publishers, original.publishers);
    });

    test('copyWith can replace developers', () {
      const original = GameMetadata(
        developers: [Contributor(id: 1, personId: 10)],
      );

      const replacement = [Contributor(id: 2, companyId: 20)];

      final copy = original.copyWith(developers: replacement);

      expect(copy.developers, replacement);
    });

    test('copyWith can replace publishers', () {
      const original = GameMetadata(
        publishers: [Contributor(id: 1, companyId: 10)],
      );

      const replacement = [Contributor(id: 2, companyId: 20)];

      final copy = original.copyWith(publishers: replacement);

      expect(copy.publishers, replacement);
    });
  });
}