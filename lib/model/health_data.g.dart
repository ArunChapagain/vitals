// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HealthDataAdapter extends TypeAdapter<HealthData> {
  @override
  final int typeId = 0;

  @override
  HealthData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HealthData(
      heartRate: fields[1] as int,
      steps: fields[2] as int,
      timestamp: fields[0] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, HealthData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.timestamp)
      ..writeByte(1)
      ..write(obj.heartRate)
      ..writeByte(2)
      ..write(obj.steps);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
