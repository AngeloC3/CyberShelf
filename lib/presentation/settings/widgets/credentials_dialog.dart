import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cybershelf/application/credentials/credential_manager.dart';
import 'package:cybershelf/application/credentials/credential_storage.dart';
import 'package:cybershelf/application/credentials/providers.dart';

class CredentialsDialog extends ConsumerStatefulWidget {
  const CredentialsDialog({
    super.key,
    required this.onCredentialsSaved,
  });

  final VoidCallback onCredentialsSaved;

  @override
  ConsumerState<CredentialsDialog> createState() => _CredentialsDialogState();
}

class _CredentialsDialogState extends ConsumerState<CredentialsDialog> {
  final _formKey = GlobalKey<FormState>();
  final _clientIdController = TextEditingController();
  final _clientSecretController = TextEditingController();
  bool _isLoading = false;
  bool _obscureSecret = true;
  bool _hasExistingCreds = false;

  @override
  void initState() {
    super.initState();
    _loadExistingCredentials();
  }

  @override
  void dispose() {
    _clientIdController.dispose();
    _clientSecretController.dispose();
    super.dispose();
  }

  Future<void> _loadExistingCredentials() async {
    final creds = await CredentialManager.instance.getCredentials();
    if (creds != null && mounted) {
      setState(() {
        _hasExistingCreds = true;
        _clientIdController.text = creds.clientId;
        _clientSecretController.text = creds.clientSecret;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_hasExistingCreds ? 'Update Credentials' : 'Set Credentials'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _hasExistingCreds
                  ? 'Update your IGDB API credentials below.'
                  : 'Enter your IGDB API credentials to enable external game search.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _clientIdController,
              decoration: const InputDecoration(
                labelText: 'Client ID',
                border: OutlineInputBorder(),
                helperText: 'From your Twitch Developer dashboard',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your Client ID';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _clientSecretController,
              obscureText: _obscureSecret,
              decoration: InputDecoration(
                labelText: 'Client Secret',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureSecret ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureSecret = !_obscureSecret;
                    });
                  },
                ),
                helperText: 'Keep this secret!',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your Client Secret';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            Text(
              'Get your credentials from:',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            SelectableText(
              'https://dev.twitch.tv/console/apps',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _saveCredentials,
          child: _isLoading
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : const Text('Save'),
        ),
      ],
    );
  }

  Future<void> _saveCredentials() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final clientId = _clientIdController.text.trim();
      final clientSecret = _clientSecretController.text.trim();

      final credentials = IgdbCredentials(
        clientId: clientId,
        clientSecret: clientSecret,
      );

      await CredentialManager.instance.saveCredentials(credentials);

      // Notify Riverpod that credentials changed
      await ref.read(credentialStateProvider.notifier).onCredentialsUpdated();

      widget.onCredentialsSaved();

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _hasExistingCreds
                  ? 'Credentials updated successfully!'
                  : 'Credentials saved successfully!',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving credentials: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}