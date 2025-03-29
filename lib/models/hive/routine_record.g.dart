// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routine_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RoutineRecordAdapter extends TypeAdapter<RoutineRecord> {
  @override
  final int typeId = 3;

  @override
  RoutineRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RoutineRecord(
      name: fields[0] as String,
      day: fields[1] as int,
      exercises: (fields[2] as List).cast<ExerciseRecord>(),
      estimatedDuration: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, RoutineRecord obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.day)
      ..writeByte(2)
      ..write(obj.exercises)
      ..writeByte(3)
      ..write(obj.estimatedDuration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoutineRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
