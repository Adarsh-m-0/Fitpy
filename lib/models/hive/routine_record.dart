import 'package:hive/hive.dart';

import 'exercise_record.dart';

part 'routine_record.g.dart';

/// A record for a workout routine
@HiveType(typeId: 3)
class RoutineRecord {
  /// Unique identifier
  @HiveField(0)
  final String name;
  
  /// Which day of the week (1-7)
  @HiveField(1)
  final int day;
  
  /// List of exercises in this routine
  @HiveField(2)
  final List<ExerciseRecord> exercises;
  
  /// Estimated duration in minutes
  @HiveField(3)
  final int estimatedDuration;
  
  /// Constructor
  RoutineRecord({
    required this.name,
    required this.day,
    required this.exercises,
    required this.estimatedDuration,
  });
} 