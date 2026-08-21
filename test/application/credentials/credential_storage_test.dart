import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:cybershelf/application/credentials/credential_storage.dart';

void main() {
  group('CredentialStorage', () {
    // Temporary test directory
    late Directory testDirectory;

    // Set up test environment before each test
    setUp(() async {
      // Create a temporary directory for testing
      testDirectory = await Directory.systemTemp.createTemp('cybershelf_test_');

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

    group('IgdbCredentials', () {
      test('creates with required values', () {
        const testCreds = IgdbCredentials(
          clientId: 'test-id',
          clientSecret: 'test-secret',
        );

        expect(testCreds.clientId, 'test-id');
        expect(testCreds.clientSecret, 'test-secret');
      });

      test('toJson returns correct map', () {
        const testCreds = IgdbCredentials(
          clientId: 'test-id',
          clientSecret: 'test-secret',
        );

        final json = testCreds.toJson();
        expect(json['clientId'], 'test-id');
        expect(json['clientSecret'], 'test-secret');
      });

      test('fromJson creates correct object', () {
        final json = {
          'clientId': 'test-id',
          'clientSecret': 'test-secret',
        };

        final creds = IgdbCredentials.fromJson(json);
        expect(creds.clientId, 'test-id');
        expect(creds.clientSecret, 'test-secret');
      });

      test('fromJson handles empty strings', () {
        final json = {
          'clientId': '',
          'clientSecret': '',
        };

        final creds = IgdbCredentials.fromJson(json);
        expect(creds.clientId, '');
        expect(creds.clientSecret, '');
      });
    });

    group('save', () {
      test('saves credentials to file', () async {
        const testCreds = IgdbCredentials(
          clientId: 'save-test-id',
          clientSecret: 'save-test-secret',
        );

        await CredentialStorage.save(testCreds);

        final loaded = await CredentialStorage.load();
        expect(loaded, isNotNull);
        expect(loaded!.clientId, 'save-test-id');
        expect(loaded.clientSecret, 'save-test-secret');
      });

      test('overwrites existing credentials', () async {
        const firstCreds = IgdbCredentials(
          clientId: 'first-id',
          clientSecret: 'first-secret',
        );
        await CredentialStorage.save(firstCreds);

        const secondCreds = IgdbCredentials(
          clientId: 'second-id',
          clientSecret: 'second-secret',
        );
        await CredentialStorage.save(secondCreds);

        final loaded = await CredentialStorage.load();
        expect(loaded, isNotNull);
        expect(loaded!.clientId, 'second-id');
        expect(loaded.clientSecret, 'second-secret');
      });

      test('includes savedAt timestamp', () async {
        const testCreds = IgdbCredentials(
          clientId: 'timestamp-test-id',
          clientSecret: 'timestamp-test-secret',
        );

        final beforeSave = DateTime.now();
        await CredentialStorage.save(testCreds);
        final afterSave = DateTime.now();

        final file = await _getCredentialFile();
        final content = await file.readAsString();
        final data = jsonDecode(content) as Map<String, dynamic>;

        expect(data['savedAt'], isNotNull);
        final savedAt = DateTime.parse(data['savedAt'] as String);
        expect(savedAt.isAfter(beforeSave) || savedAt == beforeSave, isTrue);
        expect(savedAt.isBefore(afterSave) || savedAt == afterSave, isTrue);
      });
    });

    group('load', () {
      test('returns null when file does not exist', () async {
        await CredentialStorage.delete();
        final loaded = await CredentialStorage.load();
        expect(loaded, isNull);
      });

      test('returns credentials when file exists', () async {
        const testCreds = IgdbCredentials(
          clientId: 'load-test-id',
          clientSecret: 'load-test-secret',
        );

        await CredentialStorage.save(testCreds);
        final loaded = await CredentialStorage.load();

        expect(loaded, isNotNull);
        expect(loaded!.clientId, 'load-test-id');
        expect(loaded.clientSecret, 'load-test-secret');
      });

      test('returns null when file is corrupted', () async {
        final file = await _getCredentialFile();
        await file.writeAsString('{invalid json}');

        final loaded = await CredentialStorage.load();
        expect(loaded, isNull);
      });

      test('returns null when file is empty', () async {
        final file = await _getCredentialFile();
        await file.writeAsString('');

        final loaded = await CredentialStorage.load();
        expect(loaded, isNull);
      });

      test('returns null when file has invalid structure', () async {
        final file = await _getCredentialFile();
        await file.writeAsString('{"wrongKey": "value"}');

        final loaded = await CredentialStorage.load();
        expect(loaded, isNull);
      });

      test('returns null when file has missing clientId', () async {
        final file = await _getCredentialFile();
        await file.writeAsString('{"credentials": {"clientSecret": "secret"}}');

        final loaded = await CredentialStorage.load();
        expect(loaded, isNull);
      });

      test('returns null when file has missing clientSecret', () async {
        final file = await _getCredentialFile();
        await file.writeAsString('{"credentials": {"clientId": "id"}}');

        final loaded = await CredentialStorage.load();
        expect(loaded, isNull);
      });
    });

    group('exists', () {
      test('returns false when file does not exist', () async {
        await CredentialStorage.delete();
        final exists = await CredentialStorage.exists();
        expect(exists, isFalse);
      });

      test('returns true when file exists', () async {
        const testCreds = IgdbCredentials(
          clientId: 'exists-test-id',
          clientSecret: 'exists-test-secret',
        );

        await CredentialStorage.save(testCreds);
        final exists = await CredentialStorage.exists();
        expect(exists, isTrue);
      });
    });

    group('delete', () {
      test('deletes existing file', () async {
        const testCreds = IgdbCredentials(
          clientId: 'delete-test-id',
          clientSecret: 'delete-test-secret',
        );

        await CredentialStorage.save(testCreds);
        expect(await CredentialStorage.exists(), isTrue);

        await CredentialStorage.delete();
        expect(await CredentialStorage.exists(), isFalse);
      });

      test('handles deletion when file does not exist', () async {
        await CredentialStorage.delete();
        expect(await CredentialStorage.exists(), isFalse);
      });
    });

    group('getFilePath', () {
      test('returns a valid file path', () async {
        final path = await CredentialStorage.getFilePath();
        expect(path, isNotEmpty);
        expect(path, contains('cybershelf_test_'));
        expect(path, endsWith('igdb_credentials.json'));
      });

      test('returns path to a file, not a directory', () async {
        final path = await CredentialStorage.getFilePath();
        final file = File(path);
        expect(file.path, path);
      });
    });

    group('Edge Cases', () {
      test('handles special characters in credentials', () async {
        final testCreds = IgdbCredentials(
          clientId: r'!@#$%^&*()_+',
          clientSecret: r'password/with/slashes',
        );

        await CredentialStorage.save(testCreds);
        final loaded = await CredentialStorage.load();

        expect(loaded, isNotNull);
        expect(loaded!.clientId, r'!@#$%^&*()_+');
        expect(loaded.clientSecret, r'password/with/slashes');
      });

      test('handles very long credentials (1000+ chars)', () async {
        final longString = 'a' * 1000;
        final testCreds = IgdbCredentials(
          clientId: longString,
          clientSecret: longString,
        );

        await CredentialStorage.save(testCreds);
        final loaded = await CredentialStorage.load();

        expect(loaded, isNotNull);
        expect(loaded!.clientId, longString);
        expect(loaded.clientSecret, longString);
      });

      test('handles Unicode characters', () async {
        final testCreds = IgdbCredentials(
          clientId: '😀🎮🕹️',
          clientSecret: '日本語テスト',
        );

        await CredentialStorage.save(testCreds);
        final loaded = await CredentialStorage.load();

        expect(loaded, isNotNull);
        expect(loaded!.clientId, '😀🎮🕹️');
        expect(loaded.clientSecret, '日本語テスト');
      });

      test('handles JSON special characters', () async {
        final testCreds = IgdbCredentials(
          clientId: '{"key":"value"}',
          clientSecret: '["array","of","strings"]',
        );

        await CredentialStorage.save(testCreds);
        final loaded = await CredentialStorage.load();

        expect(loaded, isNotNull);
        expect(loaded!.clientId, '{"key":"value"}');
        expect(loaded.clientSecret, '["array","of","strings"]');
      });

      test('handles whitespace in credentials', () async {
        final testCreds = IgdbCredentials(
          clientId: '  spaced-id  ',
          clientSecret: '  spaced-secret  ',
        );

        await CredentialStorage.save(testCreds);
        final loaded = await CredentialStorage.load();

        expect(loaded, isNotNull);
        expect(loaded!.clientId, '  spaced-id  ');
        expect(loaded.clientSecret, '  spaced-secret  ');
      });

      test('concurrent saves don\'t corrupt data', () async {
        final futures = <Future>[];
        for (int i = 0; i < 10; i++) {
          futures.add(CredentialStorage.save(
            IgdbCredentials(
              clientId: 'concurrent-$i',
              clientSecret: 'secret-$i',
            ),
          ));
        }
        await Future.wait(futures);

        final loaded = await CredentialStorage.load();
        expect(loaded, isNotNull);
        expect(loaded!.clientId, contains('concurrent-'));
      });
    });

    group('File System Integration', () {
      test('created file is readable and writable', () async {
        const testCreds = IgdbCredentials(
          clientId: 'fs-test-id',
          clientSecret: 'fs-test-secret',
        );

        await CredentialStorage.save(testCreds);

        final file = await _getCredentialFile();
        expect(await file.exists(), isTrue);
        expect(await file.length(), greaterThan(0));

        final content = await file.readAsString();
        expect(content, contains('fs-test-id'));
        expect(content, contains('fs-test-secret'));
      });

      test('data folder is created automatically', () async {
        const testCreds = IgdbCredentials(
          clientId: 'folder-test-id',
          clientSecret: 'folder-test-secret',
        );

        await CredentialStorage.save(testCreds);

        final file = await _getCredentialFile();
        final dir = file.parent;
        expect(await dir.exists(), isTrue);
      });
    });
  });
}

// ============================================================
// Helper Functions
// ============================================================

/// Helper to get the credential file for testing
Future<File> _getCredentialFile() async {
  final path = await CredentialStorage.getFilePath();
  return File(path);
}