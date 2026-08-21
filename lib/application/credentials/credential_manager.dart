import 'package:flutter/foundation.dart';
import 'package:cybershelf/application/credentials/credential_storage.dart';

/// Manages credentials with fallback to environment variables for development
class CredentialManager {
  CredentialManager._();

  static final CredentialManager _instance = CredentialManager._();
  static CredentialManager get instance => _instance;

  IgdbCredentials? _cachedCredentials;

  // ============================================================
  // SET THIS TO false TO DISABLE --dart-define FALLBACK
  // SET THIS TO true TO ENABLE --dart-define FALLBACK
  // ============================================================
  static const bool _useEnvFallback = false;

  /// Get credentials, checking:
  /// 1. Cache first
  /// 2. File storage
  /// 3. Environment variables (development only)
  Future<IgdbCredentials?> getCredentials() async {
    // Return cached if available
    if (_cachedCredentials != null) {
      return _cachedCredentials;
    }

    // Try file storage
    final fileCreds = await CredentialStorage.load();
    if (fileCreds != null) {
      _cachedCredentials = fileCreds;
      return fileCreds;
    }

    // In development, fall back to environment variables
    if (kDebugMode && _useEnvFallback) {
      final envCreds = _loadFromEnvironment();
      if (envCreds != null) {
        _cachedCredentials = envCreds;
        return envCreds;
      }
    }

    return null;
  }

  /// Load credentials from environment variables (--dart-define)
  IgdbCredentials? _loadFromEnvironment() {
    const clientId = String.fromEnvironment('IGDB_CLIENT_ID');
    const clientSecret = String.fromEnvironment('IGDB_CLIENT_SECRET');

    if (clientId.isNotEmpty && clientSecret.isNotEmpty) {
      return IgdbCredentials(
        clientId: clientId,
        clientSecret: clientSecret,
      );
    }

    return null;
  }

  /// Save credentials
  Future<void> saveCredentials(IgdbCredentials credentials) async {
    await CredentialStorage.save(credentials);
    _cachedCredentials = credentials;
  }

  /// Check if credentials exist
  Future<bool> hasCredentials() async {
    if (_cachedCredentials != null) return true;

    final fileExists = await CredentialStorage.exists();
    if (fileExists) return true;

    if (kDebugMode && _useEnvFallback) {
      const clientId = String.fromEnvironment('IGDB_CLIENT_ID');
      const clientSecret = String.fromEnvironment('IGDB_CLIENT_SECRET');
      if (clientId.isNotEmpty && clientSecret.isNotEmpty) {
        return true;
      }
    }

    return false;
  }

  /// Delete credentials
  Future<void> deleteCredentials() async {
    await CredentialStorage.delete();
    _cachedCredentials = null;
  }

  /// Clear cache (useful for testing)
  void clearCache() {
    _cachedCredentials = null;
  }

  /// Get the storage path for debugging
  Future<String> getStoragePath() async {
    return await CredentialStorage.getFilePath();
  }
}