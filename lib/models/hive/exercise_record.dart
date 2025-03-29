import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../enum/muscle_group.dart';

part 'exercise_record.g.dart';

/// A record of an exercise with sets, reps, and notes
@HiveType(typeId: 1)
class ExerciseRecord {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final int sets;
  
  @HiveField(3)
  final int reps;
  
  @HiveField(4)
  final MuscleGroup muscleGroup;
  
  @HiveField(5)
  final String? notes;
  
  /// Constructor with required fields and optional ID
  ExerciseRecord({
    String? id,
    required this.name,
    required this.sets,
    required this.reps,
    required this.muscleGroup,
    this.notes,
  }) : id = id ?? const Uuid().v4();
  
  /// Create a copy with modified fields
  ExerciseRecord copyWith({
    String? id,
    String? name,
    int? sets,
    int? reps,
    MuscleGroup? muscleGroup,
    String? notes,
  }) {
    return ExerciseRecord(
      id: id ?? this.id,
      name: name ?? this.name,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      muscleGroup: muscleGroup ?? this.muscleGroup,
      notes: notes ?? this.notes,
    );
  }
} 