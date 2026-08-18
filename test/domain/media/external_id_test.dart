import 'package:cybershelf/domain/media/external_id.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExternalId', () {
    test('creates with required values', () {
      const externalId = ExternalId(
        source: 'igdb',
        value: '12345',
      );

      expect(externalId.source, 'igdb');
      expect(externalId.value, '12345');
    });

    test('copyWith replaces values', () {
      const externalId = ExternalId(
        source: 'igdb',
        value: '12345',
      );

      final updated = externalId.copyWith(
        source: 'tmdb',
        value: '67890',
      );

      expect(updated.source, 'tmdb');
      expect(updated.value, '67890');
    });

    test('copyWith preserves values when omitted', () {
      const externalId = ExternalId(
        source: 'igdb',
        value: '12345',
      );

      final copied = externalId.copyWith();

      expect(copied.source, 'igdb');
      expect(copied.value, '12345');
    });
  });
}