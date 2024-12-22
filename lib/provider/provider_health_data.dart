import 'package:flutter/foundation.dart';
import 'package:vitals/model/health_data.dart';
import 'package:vitals/service/service_local_database.dart';
import 'package:vitals/service/service_mock_blutooth.dart';

class ProviderHealthData with ChangeNotifier {
  final MockBluetoothSDK _sdk = MockBluetoothSDK();
  final databaseService = LocalDatabaseService();
  bool _isConnected = false;

  Stream<HealthData> get healthDataStream async* {
    await for (final heartRate in _sdk.getHeartRateStream()) {
      final steps = await _sdk.getStepCountStream().first;
      final healthData = HealthData(
        heartRate: heartRate,
        steps: steps,
        timestamp: DateTime.now(),
      );

      // Store locally
      await _storeLocalData(healthData);

      // Sync with Firebase if online
      if (_isConnected) {
        await _syncWithFirebase(healthData);
      }

      yield healthData;
    }
  }

  Future<void> _storeLocalData(HealthData data) async {
    databaseService.saveData(data);
  }

  Future<void> _syncWithFirebase(HealthData data) async {
//TODO: add data to firestore
  }

  void setConnectionStatus(bool isConnected) {
    //TODO; write connection status logic
    _isConnected = isConnected;
    notifyListeners();
  }
}
