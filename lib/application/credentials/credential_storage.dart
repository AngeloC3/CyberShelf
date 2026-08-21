import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Model for IGDB API credentials
class IgdbCredentials {
  const IgdbCredentials({
    required this.clientId,
    required this.clientSecret,
  });

  final String clientId;
  final String clientSecret;

  Map<String, dynamic> toJson() => {
    'clientId': clientId,
    'clientSecret': clientSecret,
  };

  factory IgdbCredentials.fromJson(Map<String, dynamic> json) {
    return IgdbCredentials(
      clientId: json['clientId'] as String,
      clientSecret: json['clientSecret'] as String,
    );
  }
}

/// Manages credential storage in a local JSON file
class CredentialStorage {
  CredentialStorage._();

  static const String _fileName = 'igdb_credentials.json';
  static const String _dataFolder = 'data';

  // For testing - can be overridden
  static String? _testDirectoryPath;

  /// Set a custom test directory for testing
  static void setTestDirectory(String path) {
    _testDirectoryPath = path;
  }

  /// Reset to use the real directory
  static void resetToRealDirectory() {
    _testDirectoryPath = null;
  }

  static Future<File> _getFile() async {
    final dir = await _getStorageDirectory();
    return File('${dir.path}/$_fileName');
  }

  static Future<Directory> _getStorageDirectory() async {
    // If a test directory is set, use it
    if (_testDirectoryPath != null) {
      final testDir = Directory(_testDirectoryPath!);
      if (!await testDir.exists()) {
        await testDir.create(recursive: true);
      }
      return testDir;
    }

    if (Platform.isWindows) {
      // On Windows, use the executable's directory
      final exeDir = File(Platform.resolvedExecutable).parent;
      final dataDir = Directory('${exeDir.path}/$_dataFolder');

      if (!await dataDir.exists()) {
        await dataDir.create(recursive: true);
      }

      return dataDir;
    } else {
      return await getApplicationSupportDirectory();
    }
  }

  /// Save credentials to local file
  static Future<void> save(IgdbCredentials credentials) async {
    final file = await _getFile();
    final data = {
      'credentials': credentials.toJson(),
      'savedAt': DateTime.now().toIso8601String(),
    };
    await file.writeAsString(jsonEncode(data));
  }

  /// Load credentials from local file
  static Future<IgdbCredentials?> load() async {
    try {
      final file = await _getFile();
      if (!await file.exists()) return null;

      final content = await file.readAsString();
      if (content.isEmpty) return null;

      final data = jsonDecode(content) as Map<String, dynamic>;
      final credsData = data['credentials'] as Map<String, dynamic>;

      return IgdbCredentials.fromJson(credsData);
    } catch (_) {
      return null;
    }
  }

  /// Check if credentials exist
  static Future<bool> exists() async {
    final file = await _getFile();
    return await file.exists();
  }

  /// Delete credentials file
  static Future<void> delete() async {
    final file = await _getFile();
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// Get the file path for debugging
  static Future<String> getFilePath() async {
    final file = await _getFile();
    return file.path;
  }
}