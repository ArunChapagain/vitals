import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:vitals/model/health_data.dart';
import 'package:vitals/service/service_local_database.dart';
import 'package:vitals/service/service_mock_blutooth.dart';

class ProviderHealthData with ChangeNotifier {
  ProviderHealthData(bool isNetworkConnected, Duration syncInterval) {
    _isNetworkConnected = isNetworkConnected;
    _syncInterval = syncInterval;
    _startDataStreams();
    _startSyncTimer();
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
  Timer? _syncTimer;
  bool _isSyncing = false;

  Stream<HealthData> get healthDataStream => _healthDataController.stream;

  void _startSyncTimer() {
    _syncTimer = Timer.periodic(_syncInterval, (_) => _performSync());
    // Perform initial sync
    _performSync();
  }

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
  }

  Future<void> _performSync() async {
    if (_isSyncing) return;
    
    _isSyncing = true;
    try {
      final healthData = HealthData(
        heartRate: _currentHeartRate,
        steps: _currentSteps,
        timestamp: DateTime.now(),
      );

      await databaseService.saveData(healthData);
      
      if (_isNetworkConnected) {
        await _syncWithFirebase(healthData);
      }
      
      _lastSyncTime = DateTime.now();
    } catch (e) {
      debugPrint('Sync failed: $e');
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _syncWithFirebase(HealthData data) async {
    try {
      // Round timestamp to nearest sync interval
      final roundedTimestamp = DateTime.fromMillisecondsSinceEpoch(
        (data.timestamp.millisecondsSinceEpoch ~/ _syncInterval.inMilliseconds) * 
        _syncInterval.inMilliseconds
      );
      
      await _firestore
          .collection('health_records')
          .doc(roundedTimestamp.toIso8601String())
          .set(data.toMap());
    } catch (e) {
      debugPrint('Firebase sync failed: $e');
    }
  }


  @override
  void dispose() {
    _syncTimer?.cancel();
    _healthDataController.close();
    super.dispose();
  }
}