import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitals/provider/provider_application.dart';
import 'package:vitals/provider/provider_health_data.dart';
import 'package:vitals/view/dashboard/screen_dashboard.dart';

class WatchConnectionScreen extends StatefulWidget {
  const WatchConnectionScreen({super.key});

  @override
  State<WatchConnectionScreen> createState() => _WatchConnectionScreenState();
}

class _WatchConnectionScreenState extends State<WatchConnectionScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue[400]!, Colors.blue[800]!],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Card(
              margin: const EdgeInsets.all(32),
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (_, child) {
                        return Transform.rotate(
                          angle: _controller.value * 2 * 3.14159,
                          child: child,
                        );
                      },
                      child: const Icon(
                        Icons.watch,
                        size: 80,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _isSearching ? 'Searching for Watch...' : 'Connect Your Watch',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _isSearching 
                          ? 'Make sure your watch is nearby and Bluetooth is enabled'
                          : 'Please connect your smartwatch to start monitoring your health',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      icon: Icon(_isSearching ? Icons.stop : Icons.bluetooth_searching),
                      label: Text(_isSearching ? 'Cancel' : 'Search for Watch'),
                      onPressed: _isSearching 
                          ? () {
                              setState(() {
                                _isSearching = false;
                              });
                              _controller.stop();
                            }
                          : () async {
                              setState(() {
                                _isSearching = true;
                              });
                              _controller.repeat();
                              
                              final success = await context
                                  .read<ProviderApplication>()
                                  .connectToWatch();
                              
                              if (success && mounted) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>  const DashboardScreen(),
                                  ),
                                );
                              }
                            },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}