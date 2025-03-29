import 'package:hive/hive.dart';

import '../enum/muscle_group.dart';

/// TypeAdapter for MuscleGroup enum
class MuscleGroupAdapter extends TypeAdapter<MuscleGroup> {
  @override
  final int typeId = 1;

  @override
  MuscleGroup read(BinaryReader reader) {
    final index = reader.readInt();
    return MuscleGroup.values[index];
  }

  @override
  void write(BinaryWriter writer, MuscleGroup obj) {
    writer.writeInt(obj.index);
  }
} 