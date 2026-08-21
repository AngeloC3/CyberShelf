import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cybershelf/application/credentials/credential_manager.dart';
import 'package:cybershelf/data/external/igdb_game_source.dart';
import 'package:cybershelf/domain/game/external_game_source.dart';

/// Provider for the CredentialManager singleton
final credentialManagerProvider = Provider<CredentialManager>((ref) {
  return CredentialManager.instance;
});

/// Provider that loads game credentials asynchronously
final gameCredentialsProvider = FutureProvider<ExternalGameSource?>((ref) async {
  final manager = ref.watch(credentialManagerProvider);
  final creds = await manager.getCredentials();

  if (creds == null) return null;

  return IgdbGameSource(
    clientId: creds.clientId,
    clientSecret: creds.clientSecret,
  );
});

/// Provider that checks if game credentials exist
final hasGameCredentialsProvider = FutureProvider<bool>((ref) async {
  final manager = ref.watch(credentialManagerProvider);
  return await manager.hasCredentials();
});

/// AsyncNotifier for managing credential state with refresh capability
final credentialStateProvider =
AsyncNotifierProvider<CredentialState, ExternalGameSource?>(CredentialState.new);

/// AsyncNotifier to manage credential state
class CredentialState extends AsyncNotifier<ExternalGameSource?> {
  @override
  FutureOr<ExternalGameSource?> build() async {
    return _load();
  }

  Future<ExternalGameSource?> _load() async {
    final manager = ref.read(credentialManagerProvider);
    final creds = await manager.getCredentials();

    if (creds == null) return null;

    return IgdbGameSource(
      clientId: creds.clientId,
      clientSecret: creds.clientSecret,
    );
  }

  /// Load credentials from storage
  Future<void> loadCredentials() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_load);
  }

  /// Called when credentials are updated in Settings
  Future<void> onCredentialsUpdated() async {
    await loadCredentials();
  }

  /// Clear credentials (for testing or logout)
  Future<void> clearCredentials() async {
    final manager = ref.read(credentialManagerProvider);
    await manager.deleteCredentials();
    state = const AsyncValue.data(null);
  }

  /// Refresh credentials (force reload)
  Future<void> refresh() async {
    await loadCredentials();
  }
}

/// Provider that invalidates credentials (for refresh)
final credentialRefreshProvider = Provider<void>((ref) {
  // This is just a marker provider to trigger refreshes
  // Use ref.invalidate() on this to refresh
  return;
});