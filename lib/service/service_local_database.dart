import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vitals/model/health_data.dart';

class LocalDatabaseService {
  static const String _boxName = 'vitals_db';
  Box<HealthData>? _box;
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    
    try {
      final directory = await getApplicationDocumentsDirectory();
      Hive.init(directory.path);
      
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(HealthDataAdapter());
      }
      
      _box = await Hive.openBox<HealthData>(_boxName);
      _isInitialized = true;
    } catch (e) {
      throw DatabaseException('Failed to initialize database: $e');
    }
  }

  Future<void> saveData(HealthData data) async {
    if (!_isInitialized || _box == null) {
      await init();
    }
    
    try {
      await _box?.put(data.timestamp.millisecondsSinceEpoch.toString(), data);
    } catch (e) {
      throw DatabaseException('Failed to save data: $e');
    }
  }

  Future<List<HealthData>> getData() async {
    if (!_isInitialized || _box == null) {
      await init();
    }
    
    try {
      return _box?.values.toList() ?? [];
    } catch (e) {
      throw DatabaseException('Failed to retrieve data: $e');
    }
  }

  

  Future<void> close() async {
    await _box?.close();
    _isInitialized = false;
  }
}

class DatabaseException implements Exception {
  final String message;
  DatabaseException(this.message);
  
  @override
  String toString() => message;
}