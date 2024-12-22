// lib/main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitals/provider/provider_auth.dart';
import 'package:vitals/provider/provider_health_data.dart';
import 'package:vitals/provider/provider_history.dart';
import 'package:vitals/provider/provider_network_checker.dart';
import 'package:vitals/view/connection/screen_watch_connection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProviderAuth()),
        ChangeNotifierProvider(create: (_) => ProviderHealthData()),
        ChangeNotifierProvider(create: (_) => ProviderHistory()),
        ChangeNotifierProvider(create: (_) => ProviderNetworkChecker()),
      ],
      child: const HealthMonitorApp(),
    ),
  );
}

class HealthMonitorApp extends StatelessWidget {
  const HealthMonitorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Health Monitor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:const  WatchConnectionScreen(), // home:
    );
  }
}
