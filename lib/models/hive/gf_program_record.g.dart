// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gf_program_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GFProgramRecordAdapter extends TypeAdapter<GFProgramRecord> {
  @override
  final int typeId = 4;

  @override
  GFProgramRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GFProgramRecord(
      weekDays: (fields[0] as Map).cast<int, RoutineRecord>(),
      currentWeek: fields[1] as int,
      completedDays: (fields[2] as Map).cast<int, bool>(),
    );
  }

  @override
  void write(BinaryWriter writer, GFProgramRecord obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.weekDays)
      ..writeByte(1)
      ..write(obj.currentWeek)
      ..writeByte(2)
      ..write(obj.completedDays);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GFProgramRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
