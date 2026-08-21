import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:cybershelf/application/credentials/credential_storage.dart';

void main() {
  group('CredentialStorage Integration Tests', () {
    // Temporary test directory
    late Directory testDirectory;

    // Set up test environment before each test
    setUp(() async {
      // Create a temporary directory for testing
      testDirectory = await Directory.systemTemp.createTemp('cybershelf_integration_test_');

      // Tell CredentialStorage to use the test directory
      CredentialStorage.setTestDirectory(testDirectory.path);

      // Clean up any existing test files
      await CredentialStorage.delete();
    });

    // Clean up after each test
    tearDown(() async {
      await CredentialStorage.delete();

      // Delete the temporary test directory
      if (await testDirectory.exists()) {
        await testDirectory.delete(recursive: true);
      }

      // Reset to use the real directory
      CredentialStorage.resetToRealDirectory();
    });

    test('full lifecycle works correctly', () async {
      // 1. Initially no credentials
      expect(await CredentialStorage.exists(), isFalse);
      expect(await CredentialStorage.load(), isNull);

      // 2. Save credentials
      const testCreds = IgdbCredentials(
        clientId: 'integration-test-id',
        clientSecret: 'integration-test-secret',
      );
      await CredentialStorage.save(testCreds);

      // 3. Verify they exist
      expect(await CredentialStorage.exists(), isTrue);
      final loaded = await CredentialStorage.load();
      expect(loaded, isNotNull);
      expect(loaded!.clientId, 'integration-test-id');
      expect(loaded.clientSecret, 'integration-test-secret');

      // 4. Update credentials
      const updatedCreds = IgdbCredentials(
        clientId: 'updated-id',
        clientSecret: 'updated-secret',
      );
      await CredentialStorage.save(updatedCreds);

      // 5. Verify updated
      final updated = await CredentialStorage.load();
      expect(updated, isNotNull);
      expect(updated!.clientId, 'updated-id');
      expect(updated.clientSecret, 'updated-secret');

      // 6. Delete credentials
      await CredentialStorage.delete();

      // 7. Verify deleted
      expect(await CredentialStorage.exists(), isFalse);
      expect(await CredentialStorage.load(), isNull);
    });

    test('credentials persist across multiple operations', () async {
      // Save credentials
      const testCreds = IgdbCredentials(
        clientId: 'persistence-id',
        clientSecret: 'persistence-secret',
      );
      await CredentialStorage.save(testCreds);

      // Verify they exist
      expect(await CredentialStorage.exists(), isTrue);

      // Load and verify
      final loaded = await CredentialStorage.load();
      expect(loaded, isNotNull);
      expect(loaded!.clientId, 'persistence-id');
      expect(loaded.clientSecret, 'persistence-secret');

      // Update
      const updatedCreds = IgdbCredentials(
        clientId: 'persistence-updated-id',
        clientSecret: 'persistence-updated-secret',
      );
      await CredentialStorage.save(updatedCreds);

      // Verify update
      final updated = await CredentialStorage.load();
      expect(updated, isNotNull);
      expect(updated!.clientId, 'persistence-updated-id');
      expect(updated.clientSecret, 'persistence-updated-secret');

      // Delete
      await CredentialStorage.delete();
      expect(await CredentialStorage.exists(), isFalse);
      expect(await CredentialStorage.load(), isNull);
    });

    test('handles concurrent operations correctly', () async {
      // Perform multiple operations concurrently
      final futures = <Future>[];

      for (int i = 0; i < 5; i++) {
        futures.add(CredentialStorage.save(
          IgdbCredentials(
            clientId: 'concurrent-$i',
            clientSecret: 'secret-$i',
          ),
        ));
      }

      await Future.wait(futures);

      // Verify at least one succeeded
      final loaded = await CredentialStorage.load();
      expect(loaded, isNotNull);
      expect(loaded!.clientId, contains('concurrent-'));

      // Delete
      await CredentialStorage.delete();
      expect(await CredentialStorage.exists(), isFalse);
    });

    test('file is correctly formatted after save', () async {
      const testCreds = IgdbCredentials(
        clientId: 'format-test-id',
        clientSecret: 'format-test-secret',
      );

      await CredentialStorage.save(testCreds);

      final path = await CredentialStorage.getFilePath();
      final file = File(path);
      final content = await file.readAsString();

      // Verify it's valid JSON
      expect(() => jsonDecode(content), returnsNormally);

      // Verify structure
      final data = jsonDecode(content) as Map<String, dynamic>;
      expect(data.containsKey('credentials'), isTrue);
      expect(data.containsKey('savedAt'), isTrue);

      final creds = data['credentials'] as Map<String, dynamic>;
      expect(creds['clientId'], 'format-test-id');
      expect(creds['clientSecret'], 'format-test-secret');
    });

    test('path is in the test directory', () async {
      final path = await CredentialStorage.getFilePath();
      expect(path, contains('cybershelf_integration_test_'));
      expect(path, endsWith('igdb_credentials.json'));
    });
  });
}