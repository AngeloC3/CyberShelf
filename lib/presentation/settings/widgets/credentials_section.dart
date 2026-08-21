import 'package:flutter/material.dart';
import 'package:cybershelf/application/credentials/credential_manager.dart';
import 'package:cybershelf/presentation/settings/widgets/credentials_dialog.dart';

class CredentialsSection extends StatefulWidget {
  const CredentialsSection({
    super.key,
    required this.hasCredentials,
    required this.onCredentialsSaved,
  });

  final bool hasCredentials;
  final VoidCallback onCredentialsSaved;

  @override
  State<CredentialsSection> createState() => _CredentialsSectionState();
}

class _CredentialsSectionState extends State<CredentialsSection> {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'API Credentials',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ),
        ListTile(
          leading: Icon(
            widget.hasCredentials ? Icons.check_circle : Icons.vpn_key,
            color: widget.hasCredentials ? Colors.green : Colors.orange,
          ),
          title: Text(
            widget.hasCredentials ? 'IGDB Credentials Set' : 'IGDB Credentials Required',
          ),
          subtitle: Text(
            widget.hasCredentials
                ? 'Your API credentials are configured and ready to use.'
                : 'You need to set your IGDB API credentials to search and import games.',
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.hasCredentials)
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  onPressed: _isDeleting ? null : _confirmDelete,
                  color: Colors.red,
                  tooltip: 'Delete credentials',
                ),
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                onPressed: _showCredentialsDialog,
                tooltip: widget.hasCredentials ? 'Update credentials' : 'Set credentials',
              ),
            ],
          ),
          onTap: _showCredentialsDialog,
        ),
      ],
    );
  }

  void _showCredentialsDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => CredentialsDialog(
        onCredentialsSaved: widget.onCredentialsSaved,
      ),
    );
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Credentials?'),
        content: const Text(
          'This will delete your stored IGDB API credentials. '
              'You will need to re-enter them to use external game search.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isDeleting = true);
      try {
        await CredentialManager.instance.deleteCredentials();
        widget.onCredentialsSaved();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Credentials deleted'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting credentials: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isDeleting = false);
        }
      }
    }
  }
}