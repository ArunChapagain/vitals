import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:vitals/model/health_data.dart';
import 'package:vitals/service/service_local_database.dart';

class ProviderHistory with ChangeNotifier {
  final LocalDatabaseService _databaseService = LocalDatabaseService();
  final _firestore = FirebaseFirestore.instance;
  bool _isConnected = false;

  // Get connection status from network provider 
  void setConnectionStatus(bool isConnected) {
    _isConnected = isConnected;
    notifyListeners();
  }

  Future<List<HealthData>> getHealthHistory() async {
    try {
      // First try to get local data
      List<HealthData> localData = await _databaseService.getData();
      
      if (_isConnected) {
        // If online, try to sync with Firebase
        try {
          final firebaseData = await _firestore.collection('health_data').get().then((snapshot) {
            return snapshot.docs.map((doc) => HealthData.fromMap(doc.data())).toList();
          });
          // Merge and sort data
          localData.addAll(firebaseData);
          localData.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        } catch (e) {
          debugPrint('Firebase sync failed: $e');
          // Continue with local data if Firebase fails
        }
      }
      
      return localData;
    } catch (e) {
      throw Exception('Failed to load health history: $e');
    }
  }

}