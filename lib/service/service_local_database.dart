import 'package:hive/hive.dart';
import 'package:vitals/model/health_data.dart';

class LocalDatabaseService {
  static const String _boxName = 'vitals_db';
  late Box<HealthData> _box;

  Future<void> init() async {
    _box = await Hive.openBox<HealthData>(_boxName);
  }

  Future<void> saveData(HealthData data) async {
    try {
      await _box.put(data.timestamp.millisecondsSinceEpoch.toString(), data);
    } catch (e) {
      throw DatabaseException('Failed to save data: $e');
    }
  }

  Future<List<HealthData>> getData() async {
    try {
      return _box.values.toList();
    } catch (e) {
      throw DatabaseException('Failed to retrieve data: $e');
    }
  }

  Future<void> close() async {
    await _box.close();
  }
}

class DatabaseException implements Exception {
  final String message;
  DatabaseException(this.message);

  @override
  String toString() => 'DatabaseException: $message';
}