import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitals/provider/provider_auth.dart';
import 'package:vitals/provider/provider_health_data.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final healthService = context.watch<ProviderHealthData>();
    final authService = context.read<ProviderAuth>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.bluetooth),
                  title: const Text('Smartwatch Connection'),
                  subtitle: Text(
                    healthService.isWatchConnected
                        ? 'Connected'
                        : 'Disconnected',
                  ),
                  trailing: Switch(
                    value: healthService.isWatchConnected,
                    onChanged: (value) {
                      healthService.setConnectionStatus = value;
                    },
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.sync),
                  title: const Text('Sync Frequency'),
                  subtitle: const Text('Every 10 seconds'),
                  onTap: () {
                    // Show sync frequency options
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text('Notifications'),
                  trailing: Switch(
                    value: true,
                    onChanged: (value) {
                      // Toggle notifications
                    },
                  ),
                ),
                const Divider(),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 84, 129, 196),
              padding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.logout),
            label: const Text('Sign Out'),
            onPressed: () async {
              await authService.signOut();
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
          ),
        ],
      ),
    );
  }
}
