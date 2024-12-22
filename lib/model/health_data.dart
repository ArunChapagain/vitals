import 'package:hive/hive.dart';
part 'health_data.g.dart';

@HiveType(typeId: 0)
class HealthData {
  @HiveField(0)
  final DateTime timestamp;

  @HiveField(1)
  final int heartRate;

  @HiveField(2)
  final int steps;

  HealthData({
    required this.heartRate,
    required this.steps,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'heartRate': heartRate,
      'steps': steps,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory HealthData.fromMap(Map<String, dynamic> map) {
    return HealthData(
      heartRate: map['heartRate'],
      steps: map['steps'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
