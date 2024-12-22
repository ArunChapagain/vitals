import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitals/provider/provider_auth.dart';
import 'package:vitals/view/connection/screen_watch_connection.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                    const Icon(
                      Icons.watch,
                      size: 80,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Health Monitor',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
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
                      icon: const Icon(Icons.login),
                      label: const Text('Sign in with Google'),
                      onPressed: () async {
                        final authProvider = context.read<ProviderAuth>();
                        final user = await authProvider.signInWithGoogle();
                        if (user != null && context.mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const WatchConnectionScreen(),
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