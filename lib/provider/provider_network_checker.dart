import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ProviderNetworkChecker extends ChangeNotifier {
  InternetStatus _status = InternetStatus.disconnected;

  ProviderNetworkChecker() {
    listenNetwork();
  }

  void listenNetwork() {
    InternetConnection().onStatusChange.listen((status) {
      _status = status;
      notifyListeners();
    });
  }

  InternetStatus get status => _status;
}
