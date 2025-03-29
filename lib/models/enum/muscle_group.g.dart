// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'muscle_group.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MuscleGroupAdapter extends TypeAdapter<MuscleGroup> {
  @override
  final int typeId = 0;

  @override
  MuscleGroup read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MuscleGroup.chest;
      case 1:
        return MuscleGroup.back;
      case 2:
        return MuscleGroup.shoulders;
      case 3:
        return MuscleGroup.arms;
      case 4:
        return MuscleGroup.legs;
      case 5:
        return MuscleGroup.core;
      case 6:
        return MuscleGroup.cardio;
      case 7:
        return MuscleGroup.fullBody;
      default:
        return MuscleGroup.chest;
    }
  }

  @override
  void write(BinaryWriter writer, MuscleGroup obj) {
    switch (obj) {
      case MuscleGroup.chest:
        writer.writeByte(0);
        break;
      case MuscleGroup.back:
        writer.writeByte(1);
        break;
      case MuscleGroup.shoulders:
        writer.writeByte(2);
        break;
      case MuscleGroup.arms:
        writer.writeByte(3);
        break;
      case MuscleGroup.legs:
        writer.writeByte(4);
        break;
      case MuscleGroup.core:
        writer.writeByte(5);
        break;
      case MuscleGroup.cardio:
        writer.writeByte(6);
        break;
      case MuscleGroup.fullBody:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MuscleGroupAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
