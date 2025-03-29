// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExerciseRecordAdapter extends TypeAdapter<ExerciseRecord> {
  @override
  final int typeId = 1;

  @override
  ExerciseRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExerciseRecord(
      id: fields[0] as String?,
      name: fields[1] as String,
      sets: fields[2] as int,
      reps: fields[3] as int,
      muscleGroup: fields[4] as MuscleGroup,
      notes: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ExerciseRecord obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.sets)
      ..writeByte(3)
      ..write(obj.reps)
      ..writeByte(4)
      ..write(obj.muscleGroup)
      ..writeByte(5)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
