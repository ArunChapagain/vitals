import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:vitals/model/health_data.dart';
import 'package:vitals/service/service_local_database.dart';
import 'package:vitals/service/service_mock_blutooth.dart';

class ProviderHealthData with ChangeNotifier {
  ProviderHealthData(bool isNetworkConnected, Duration syncInterval) {
    _isNetworkConnected = isNetworkConnected;
    _lastSyncTime = DateTime.now();
    _syncInterval = syncInterval;
    _startDataStreams(); // Start listening to both streams immediately
  }

  final MockBluetoothSDK _sdk = MockBluetoothSDK();
  final databaseService = LocalDatabaseService();
  final _firestore = FirebaseFirestore.instance;

  bool _isNetworkConnected = true;

  // Health data state
  int _currentSteps = 0;
  int _currentHeartRate = 0;
  final StreamController<HealthData> _healthDataController =
      StreamController<HealthData>.broadcast();

  // Sync related variables
  late DateTime _lastSyncTime;
  late Duration _syncInterval;
  bool _isFirstSync = true;

  Stream<HealthData> get healthDataStream => _healthDataController.stream;

  void _startDataStreams() {
    // Listen to heart rate updates
    _sdk.getHeartRateStream().listen((heartRate) {
      _currentHeartRate = heartRate;
      _emitHealthData();
    });

    // Listen to step count updates
    _sdk.getStepCountStream().listen((steps) {
      _currentSteps = steps;
      _emitHealthData();
    });
  }

  void _emitHealthData() {
    final healthData = HealthData(
      heartRate: _currentHeartRate,
      steps: _currentSteps,
      timestamp: DateTime.now(),
    );

    _healthDataController.add(healthData);
    _storeLocalData(healthData);
  }

  Future<void> _storeLocalData(HealthData data) async {
    if (_shouldSync()) {
      await databaseService.saveData(data);
      if (_isNetworkConnected) {
        await _syncWithFirebase(data);
      }
      _lastSyncTime = DateTime.now();
      _isFirstSync = false;
    }
  }

  bool _shouldSync() {
    if (_isFirstSync) return true;
    final timeSinceLastSync = DateTime.now().difference(_lastSyncTime);
    return timeSinceLastSync >= _syncInterval;
  }

  Future<void> _syncWithFirebase(HealthData data) async {
    try {
      await _firestore
          .collection('health_records')
          .doc(data.timestamp.toIso8601String())
          .set(data.toMap());
    } catch (e) {
      debugPrint('Firebase sync failed: $e');
    }
  }

  @override
  void dispose() {
    _healthDataController.close();
    super.dispose();
  }
}
