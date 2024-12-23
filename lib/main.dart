import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitals/provider/provider_application.dart';
import 'package:vitals/provider/provider_auth.dart';
import 'package:vitals/provider/provider_health_data.dart';
import 'package:vitals/provider/provider_history.dart';
import 'package:vitals/provider/provider_network_checker.dart';
import 'package:vitals/view/auth/auth_page.dart';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProviderAuth()),
        ChangeNotifierProvider(create: (_) => ProviderApplication()),
        ChangeNotifierProvider(
          create: (_) => ProviderNetworkChecker(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider2<ProviderNetworkChecker,ProviderApplication, ProviderHealthData>(
          create: (_) => ProviderHealthData(true,Duration(minutes: 5)),
          update: (_, networkChecker, application, healthData) =>
              ProviderHealthData(networkChecker.isConnected, application.syncInterval),
        ),
        ChangeNotifierProxyProvider<ProviderNetworkChecker, ProviderHistory>(
          create: (_) => ProviderHistory(true),
          update: (_, networkChecker, history) =>
              ProviderHistory(networkChecker.isConnected),
        ),
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
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Health Monitor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const AuthPage(), 
      initialRoute: '/',
    );
  }
}
