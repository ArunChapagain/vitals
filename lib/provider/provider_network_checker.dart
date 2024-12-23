import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ProviderNetworkChecker extends ChangeNotifier {
  bool get isConnected => _status == InternetStatus.connected;
  InternetStatus _status = InternetStatus.connected;

  ProviderNetworkChecker() {
    listenNetwork();
  }

  void listenNetwork() {
    InternetConnection().onStatusChange.listen((status) {
      _status = status;
      notifyListeners();
    });
  }
}
