class HealthData {
  final int heartRate;
  final int steps;
  final DateTime timestamp;
  
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