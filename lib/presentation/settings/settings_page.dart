import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cybershelf/application/credentials/credential_manager.dart';
import 'package:cybershelf/application/credentials/credential_storage.dart';
import 'package:cybershelf/application/credentials/providers.dart';
import 'package:cybershelf/presentation/settings/widgets/credentials_section.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _hasCredentials = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkCredentials();
  }

  Future<void> _checkCredentials() async {
    setState(() => _isLoading = true);
    _hasCredentials = await CredentialManager.instance.hasCredentials();
    setState(() => _isLoading = false);
  }

  void _onCredentialsSaved() async {
    _checkCredentials();
    // Refresh the credential state - this will notify all listeners
    await ref.read(credentialStateProvider.notifier).onCredentialsUpdated();
  }

  Future<void> _copyPathToClipboard(String path) async {
    await Clipboard.setData(ClipboardData(text: path));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Path copied to clipboard!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        children: [
          // Credentials Section
          CredentialsSection(
            hasCredentials: _hasCredentials,
            onCredentialsSaved: _onCredentialsSaved,
          ),

          const Divider(height: 1),

          // Placeholder for future settings
          ListTile(
            leading: Icon(
              Icons.info_outline,
              color: Colors.grey.shade400,
            ),
            title: const Text('About'),
            subtitle: const Text('CyberShelf v0.1.0'),
            onTap: () {
              // Placeholder - could show about dialog later
            },
          ),

          const Divider(height: 1),

          // Data Location - Shows to all users
          FutureBuilder<String>(
            future: CredentialStorage.getFilePath(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final path = snapshot.data!;
                return ListTile(
                  leading: Icon(
                    Icons.folder_open,
                    color: Colors.grey.shade400,
                  ),
                  title: const Text('Data Location'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        path,
                        style: const TextStyle(fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 12,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Tap to copy path to clipboard',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.copy, size: 20),
                    onPressed: () => _copyPathToClipboard(path),
                    tooltip: 'Copy path to clipboard',
                  ),
                  onTap: () => _copyPathToClipboard(path),
                );
              }
              return ListTile(
                leading: Icon(
                  Icons.folder_open,
                  color: Colors.grey.shade400,
                ),
                title: const Text('Data Location'),
                subtitle: const Text('Loading...'),
              );
            },
          ),
        ],
      ),
    );
  }
}