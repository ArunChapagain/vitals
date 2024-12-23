import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitals/main.dart';
import 'package:vitals/provider/provider_application.dart';
import 'package:vitals/provider/provider_auth.dart';
import 'package:vitals/view/auth/auth_page.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final applicationService = context.watch<ProviderApplication>();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildConnectionCard(applicationService, context),
          const SizedBox(height: 16),
          _buildSyncCard(applicationService),
          const SizedBox(height: 24),
          _buildSignOutButton(context),
        ],
      ),
    );
  }

  Widget _buildConnectionCard(
      ProviderApplication applicationService, BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          leading: Icon(
            Icons.bluetooth,
            color:
                applicationService.isWatchConnected ? Colors.blue : Colors.grey,
          ),
          title: const Text(
            'Smartwatch Connection',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            applicationService.isWatchConnected ? 'Connected' : 'Disconnected',
            style: TextStyle(
              color: applicationService.isWatchConnected
                  ? Colors.green
                  : Colors.red,
            ),
          ),
          trailing: Switch.adaptive(
            value: applicationService.isWatchConnected,
            onChanged: (value) async {
              if (value) {
                await applicationService.connectToWatch();
              } else {
                applicationService.disconnectWatch(context);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSyncCard(ProviderApplication applicationService) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          leading: const Icon(Icons.sync, color: Colors.blue),
          title: const Text(
            'Sync Frequency',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            _getSyncIntervalText(applicationService.syncInterval),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => _showSyncIntervalDialog(applicationService),
        ),
      ),
    );
  }

  Widget _buildSignOutButton(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      icon: const Icon(Icons.logout),
      label: const Text(
        'Sign Out',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      onPressed: () => _handleSignOut(context),
    );
  }

  String _getSyncIntervalText(Duration interval) {
    if (interval.inMinutes < 1) {
      return 'Every ${interval.inSeconds} seconds';
    } else if (interval.inHours < 1) {
      return 'Every ${interval.inMinutes} minutes';
    } else {
      return 'Every ${interval.inHours} hours';
    }
  }

  Future<void> _showSyncIntervalDialog(
      ProviderApplication applicationService) async {
    final List<Duration> intervals = [
      const Duration(minutes: 1),
      const Duration(minutes: 5),
      const Duration(minutes: 15),
      const Duration(minutes: 30),
      const Duration(hours: 1),
    ];

    await showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => AlertDialog(
        title: const Text('Select Sync Interval'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: intervals
                .map((interval) => ListTile(
                      title: Text(_getSyncIntervalText(interval)),
                      onTap: () {
                        applicationService.syncInterval = interval;
                        Navigator.pop(context);
                      },
                      trailing: interval == applicationService.syncInterval
                          ? const Icon(Icons.check, color: Colors.green)
                          : null,
                    ))
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _handleSignOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await Provider.of<ProviderAuth>(context, listen: false).signOut();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const AuthPage()),
                  (route) => false,
                );
              }
            },
            child: const Text('Sign Out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

