import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../enum/muscle_group.dart';
import 'exercise_record.dart';

part 'workout_record.g.dart';

/// A record of a workout with exercises, duration, and notes
@HiveType(typeId: 2)
class WorkoutRecord {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final DateTime date;
  
  @HiveField(2)
  final List<MuscleGroup> muscleGroups;
  
  @HiveField(3)
  final int duration;
  
  @HiveField(4)
  final List<ExerciseRecord> exercises;
  
  @HiveField(5)
  final String? notes;
  
  /// Constructor with required fields and optional ID
  WorkoutRecord({
    String? id,
    required this.date,
    required this.muscleGroups,
    required this.duration,
    required this.exercises,
    this.notes,
  }) : id = id ?? const Uuid().v4();
  
  /// Create a copy with modified fields
  WorkoutRecord copyWith({
    String? id,
    DateTime? date,
    List<MuscleGroup>? muscleGroups,
    int? duration,
    List<ExerciseRecord>? exercises,
    String? notes,
  }) {
    return WorkoutRecord(
      id: id ?? this.id,
      date: date ?? this.date,
      muscleGroups: muscleGroups ?? this.muscleGroups,
      duration: duration ?? this.duration,
      exercises: exercises ?? this.exercises,
      notes: notes,
    );
  }
} 