import 'package:flutter/material.dart';
import 'package:vitals/view/connection/screen_watch_connection.dart';

class ProviderApplication extends ChangeNotifier {
  bool _isWatchConnected = false;
  bool get isWatchConnected => _isWatchConnected;
  Duration _syncInterval = const Duration(minutes: 5);

  Duration get syncInterval => _syncInterval;

  set syncInterval(Duration interval) {
    _syncInterval = interval;
    notifyListeners();
  }

  Future<bool> connectToWatch() async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      _isWatchConnected = true;
      notifyListeners();
      return true;
    } catch (e) {
      _isWatchConnected = false;
      notifyListeners();
      return false;
    }
  }

  void disconnectWatch(BuildContext context) {
    _isWatchConnected = false;
     if (!_isWatchConnected) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const WatchConnectionScreen(),
        ),
        (route) => false,
      );
    }
    notifyListeners();
  }

  set setConnectionStatus(bool isWatchConnected) {
    _isWatchConnected = isWatchConnected;
    notifyListeners();
  }

  void monitorWatchConnection(BuildContext context) {
   
  }
}
