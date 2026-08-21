import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cybershelf/application/credentials/credential_manager.dart';
import 'package:cybershelf/application/credentials/credential_storage.dart';
import 'package:cybershelf/application/credentials/providers.dart';
import 'package:cybershelf/data/external/igdb_game_source.dart';
import 'package:cybershelf/domain/game/external_game_source.dart';

void main() {
  group('Credential Providers', () {
    late Directory testDirectory;

    const testCreds = IgdbCredentials(
      clientId: 'provider-test-id',
      clientSecret: 'provider-test-secret',
    );

    setUp(() async {
      // Use an isolated temp directory for file storage so tests don't
      // touch (or depend on) the real credentials file.
      testDirectory =
      await Directory.systemTemp.createTemp('cybershelf_providers_test_');
      CredentialStorage.setTestDirectory(testDirectory.path);
      await CredentialStorage.delete();

      // The manager is a singleton, so make sure no stale cache/state
      // leaks in between tests.
      CredentialManager.instance.clearCache();
    });

    tearDown(() async {
      await CredentialStorage.delete();

      if (await testDirectory.exists()) {
        await testDirectory.delete(recursive: true);
      }

      CredentialStorage.resetToRealDirectory();
      CredentialManager.instance.clearCache();
    });

    group('credentialManagerProvider', () {
      test('provides the CredentialManager singleton', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final manager = container.read(credentialManagerProvider);

        expect(manager, same(CredentialManager.instance));
      });
    });

    group('gameCredentialsProvider', () {
      test('resolves to null when no credentials are stored', () async {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final result = await container.read(gameCredentialsProvider.future);

        expect(result, isNull);
      });

      test('resolves to an IgdbGameSource when credentials exist', () async {
        await CredentialManager.instance.saveCredentials(testCreds);

        final container = ProviderContainer();
        addTearDown(container.dispose);

        final result = await container.read(gameCredentialsProvider.future);

        expect(result, isNotNull);
        expect(result, isA<IgdbGameSource>());
        expect(result!.sourceName, 'IGDB');
        expect((result as IgdbGameSource).clientId, testCreds.clientId);
        expect(result.clientSecret, testCreds.clientSecret);
      });
    });

    group('hasGameCredentialsProvider', () {
      test('resolves to false when no credentials are stored', () async {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final result = await container.read(hasGameCredentialsProvider.future);

        expect(result, isFalse);
      });

      test('resolves to true when credentials exist', () async {
        await CredentialManager.instance.saveCredentials(testCreds);

        final container = ProviderContainer();
        addTearDown(container.dispose);

        final result = await container.read(hasGameCredentialsProvider.future);

        expect(result, isTrue);
      });
    });

    group('credentialStateProvider / CredentialState', () {
      test('starts in a loading state', () async {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final state = container.read(credentialStateProvider);

        expect(state, isA<AsyncLoading<ExternalGameSource?>>());

        // The constructor kicks off an async `loadCredentials()` call that
        // isn't awaited by the container itself. Drain it here so it
        // resolves *before* `addTearDown` disposes the container - setting
        // state on a disposed StateNotifier throws.
        await container.read(credentialStateProvider.notifier).loadCredentials();
      });

      test('resolves to AsyncData(null) when no credentials exist', () async {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        // Ensure the notifier's initial load has completed.
        await container.read(credentialStateProvider.notifier).loadCredentials();

        final state = container.read(credentialStateProvider);

        expect(state, isA<AsyncData<ExternalGameSource?>>());
        expect(state.value, isNull);
      });

      test('resolves to an IgdbGameSource when credentials exist', () async {
        await CredentialManager.instance.saveCredentials(testCreds);

        final container = ProviderContainer();
        addTearDown(container.dispose);

        await container.read(credentialStateProvider.notifier).loadCredentials();

        final state = container.read(credentialStateProvider);

        expect(state, isA<AsyncData<ExternalGameSource?>>());
        expect(state.value, isNotNull);
        expect(state.value, isA<IgdbGameSource>());
        expect(state.value!.sourceName, 'IGDB');
      });

      test('onCredentialsUpdated reloads state after Settings save', () async {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(credentialStateProvider.notifier);
        await notifier.loadCredentials();
        expect(container.read(credentialStateProvider).value, isNull);

        await CredentialManager.instance.saveCredentials(testCreds);
        await notifier.onCredentialsUpdated();

        final state = container.read(credentialStateProvider);
        expect(state.value, isNotNull);
        expect(state.value!.sourceName, 'IGDB');
      });

      test('clearCredentials clears state and deletes storage', () async {
        await CredentialManager.instance.saveCredentials(testCreds);

        final container = ProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(credentialStateProvider.notifier);
        await notifier.loadCredentials();
        expect(container.read(credentialStateProvider).value, isNotNull);

        await notifier.clearCredentials();

        final state = container.read(credentialStateProvider);
        expect(state, isA<AsyncData<ExternalGameSource?>>());
        expect(state.value, isNull);
        expect(await CredentialStorage.exists(), isFalse);
        expect(await CredentialManager.instance.hasCredentials(), isFalse);
      });

      test('refresh reloads credentials from storage', () async {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(credentialStateProvider.notifier);
        await notifier.loadCredentials();
        expect(container.read(credentialStateProvider).value, isNull);

        // Simulate credentials being saved elsewhere (e.g. Settings screen)
        // and the cache being cleared so the next read hits storage again.
        await CredentialManager.instance.saveCredentials(testCreds);

        await notifier.refresh();

        final state = container.read(credentialStateProvider);
        expect(state.value, isNotNull);
        expect(state.value!.sourceName, 'IGDB');
      });

      test('state updates propagate to listeners', () async {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final states = <AsyncValue<ExternalGameSource?>>[];
        container.listen<AsyncValue<ExternalGameSource?>>(
          credentialStateProvider,
              (previous, next) => states.add(next),
          fireImmediately: true,
        );

        final notifier = container.read(credentialStateProvider.notifier);
        await notifier.loadCredentials();

        await CredentialManager.instance.saveCredentials(testCreds);
        await notifier.refresh();

        expect(states, isNotEmpty);
        expect(states.last.value, isNotNull);
        expect(states.last.value!.sourceName, 'IGDB');
      });
    });

    group('credentialRefreshProvider', () {
      test('is a valid marker provider that can be invalidated', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        // The marker provider itself has no meaningful value; reading it
        // should simply not throw, and invalidating it should also be safe.
        expect(() => container.read(credentialRefreshProvider), returnsNormally);
        expect(() => container.invalidate(credentialRefreshProvider), returnsNormally);
      });
    });
  });
}