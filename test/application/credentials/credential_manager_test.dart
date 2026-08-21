import 'package:flutter_test/flutter_test.dart';
import 'package:cybershelf/application/credentials/credential_manager.dart';
import 'package:cybershelf/application/credentials/credential_storage.dart';

void main() {
  group('CredentialManager Integration Tests', () {
    test('full credential lifecycle works correctly', () async {
      // 1. Initially no credentials
      expect(await CredentialManager.instance.hasCredentials(), isFalse);
      expect(await CredentialManager.instance.getCredentials(), isNull);

      // 2. Save credentials
      final testCreds = IgdbCredentials(
        clientId: 'integration-test-id',
        clientSecret: 'integration-test-secret',
      );
      await CredentialManager.instance.saveCredentials(testCreds);

      // 3. Verify credentials exist
      expect(await CredentialManager.instance.hasCredentials(), isTrue);
      final loaded = await CredentialManager.instance.getCredentials();
      expect(loaded, isNotNull);
      expect(loaded!.clientId, 'integration-test-id');
      expect(loaded.clientSecret, 'integration-test-secret');

      // 4. Update credentials
      final updatedCreds = IgdbCredentials(
        clientId: 'updated-id',
        clientSecret: 'updated-secret',
      );
      await CredentialManager.instance.saveCredentials(updatedCreds);

      // 5. Verify updated credentials
      final updated = await CredentialManager.instance.getCredentials();
      expect(updated, isNotNull);
      expect(updated!.clientId, 'updated-id');
      expect(updated.clientSecret, 'updated-secret');

      // 6. Delete credentials
      await CredentialManager.instance.deleteCredentials();

      // 7. Verify deleted
      expect(await CredentialManager.instance.hasCredentials(), isFalse);
      expect(await CredentialManager.instance.getCredentials(), isNull);
      expect(await CredentialStorage.exists(), isFalse);
    });

    test('credentials persist across manager instances', () async {
      // Save via one reference
      final testCreds = IgdbCredentials(
        clientId: 'persistence-id',
        clientSecret: 'persistence-secret',
      );
      await CredentialManager.instance.saveCredentials(testCreds);

      // Clear cache but keep file
      CredentialManager.instance.clearCache();

      // New instance should load from file
      final loaded = await CredentialManager.instance.getCredentials();
      expect(loaded, isNotNull);
      expect(loaded!.clientId, 'persistence-id');
      expect(loaded.clientSecret, 'persistence-secret');
    });
  });
}