import 'dart:math';
import 'dart:async';

class MockBluetoothSDK {
  MockBluetoothSDK() {
    _baseHeartRate = 70; // Average resting heart rate
  }

  late int _baseHeartRate;
  final Random _random = Random();

  Stream<int> getHeartRateStream() async* {
    while (true) {
      await Future.delayed(const Duration(
          milliseconds: 500)); // Update heart rate at 800 millisecond

      // Randomly adjust base heart rate occasionally
      if (_random.nextInt(60) == 0) {
        // Chance to change every ~minute
        _baseHeartRate = 70 + _random.nextInt(30); // 70-100 bpm base range
      }

      // Generate heart rate with natural variation
      final variation = _random.nextInt(5) - 2; // -2 to +2 variation
      int heartRate = _baseHeartRate + variation;

      // Ensure heart rate stays within realistic bounds
      heartRate = heartRate.clamp(60, 120);

      yield heartRate;
    }
  }

  Stream<int> getStepCountStream() async* {
    int totalSteps = 0;

    while (true) {
      await Future.delayed(
          const Duration(seconds: 3)); // Update steps every 3 seconds

      // Generate random steps (0-4 steps per 3-second interval)
      int newSteps = _random.nextInt(2) + 1;
      totalSteps += newSteps;

      yield totalSteps;
    }
  }
}
