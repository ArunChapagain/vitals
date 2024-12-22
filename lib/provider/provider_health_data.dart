import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:vitals/model/health_data.dart';
import 'package:vitals/service/service_local_database.dart';
import 'package:vitals/service/service_mock_blutooth.dart';

class ProviderHealthData with ChangeNotifier {
  final MockBluetoothSDK _sdk = MockBluetoothSDK();
  final databaseService = LocalDatabaseService();
  final _firestore = FirebaseFirestore.instance;
  bool _isWatchConnected = false;
  bool _isNetworkConnected = false;
  bool _isInitialized = false;

  bool get isConnected => _isWatchConnected;

  Future<bool> connectToWatch() async {
    try {
      // Simulate connection attempt
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

  void disconnectWatch() {
    _isWatchConnected = false;
    notifyListeners();
  }

  Stream<HealthData> get healthDataStream async* {
    await for (final heartRate in _sdk.getHeartRateStream()) {
      final steps = await _sdk.getStepCountStream().first;
      // final bloodPressure = await _sdk.getBloodPressureStream().first;
      final healthData = HealthData(
        heartRate: heartRate,
        steps: steps,
        timestamp: DateTime.now(),
        // bloodPressure: bloodPressure,
      );

      // Store locally
      await _storeLocalData(healthData);

      // Sync with Firebase if online
      if (_isNetworkConnected) {
        await _syncWithFirebase(healthData);
      }

      yield healthData;
    }
  }

  Future<void> _storeLocalData(HealthData data) async {
    if (_isInitialized) {
      databaseService.saveData(data);
      
      _isInitialized = true;
      return;
    } else {
      Future.delayed(const Duration(minutes: 5));
      databaseService.saveData(data);
    }
  }

  Future<void> _syncWithFirebase(HealthData data) async {
   await _firestore
        .collection('health_records')
        .doc(data.timestamp.toIso8601String())
        .set(data.toMap());
  }

  void setConnectionStatus(bool isConnected) {
    //TODO; write connection status logic
    _isNetworkConnected = isConnected;
    notifyListeners();
  }
}
