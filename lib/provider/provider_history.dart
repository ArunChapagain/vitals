import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:vitals/model/health_data.dart';
import 'package:vitals/service/service_local_database.dart';

class ProviderHistory with ChangeNotifier {
  ProviderHistory(bool isConnected) {
    _isConnected = isConnected;
  }
  final LocalDatabaseService _databaseService = LocalDatabaseService();
  final _firestore = FirebaseFirestore.instance;
  bool _isConnected = true;

  // Get connection status from network provider
  void setConnectionStatus(bool isConnected) {
    _isConnected = isConnected;
    notifyListeners();
  }

  Future<List<HealthData>> getHealthHistory() async {
    try {
      // Get local data first
      List<HealthData> localData = await _databaseService.getData();

      if (_isConnected) {
        try {
          // Fetch from Firebase with proper query
          final QuerySnapshot snapshot = await _firestore
              .collection('health_records')
              .orderBy('timestamp', descending: true)
              .limit(100)
              .get();

          if (snapshot.docs.isNotEmpty) {
            final firebaseData = snapshot.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return HealthData(
                timestamp: DateTime.parse(data['timestamp']),
                heartRate: data['heartRate'],
                steps: data['steps'],
              );
            }).toList();

            // Merge and sort data
            localData.addAll(firebaseData);
            localData.sort((a, b) => b.timestamp.compareTo(a.timestamp));
          }
        } catch (e) {
          debugPrint('Firebase fetch error: $e');
        }
      }

      return localData;
    } catch (e) {
      debugPrint('History fetch error: $e');
      throw Exception('Failed to load health history');
    }
  }
}
