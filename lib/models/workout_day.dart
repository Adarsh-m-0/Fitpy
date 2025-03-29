import 'package:intl/intl.dart';
import 'hive/exercise_record.dart';
import 'enum/muscle_group.dart';

class WorkoutDay {
  final DateTime date;
  final List<ExerciseRecord> exercises;
  final int duration; // in minutes

  WorkoutDay({
    required this.date,
    required this.exercises,
    required this.duration,
  });

  WorkoutDay copyWith({
    DateTime? date,
    List<ExerciseRecord>? exercises,
    int? duration,
  }) {
    return WorkoutDay(
      date: date ?? this.date,
      exercises: exercises ?? this.exercises,
      duration: duration ?? this.duration,
    );
  }

  // Get all exercises for a specific muscle group
  List<ExerciseRecord> getExercisesByMuscleGroup(MuscleGroup muscleGroup) {
    return exercises.where((e) => e.muscleGroup == muscleGroup).toList();
  }

  // Get all unique muscle groups trained on this day
  Set<MuscleGroup> get muscleGroups {
    return exercises.map((e) => e.muscleGroup).toSet();
  }

  // Convert to map for database storage
  Map<String, dynamic> toMap() {
    return {
      'date': DateFormat('yyyy-MM-dd').format(date),
      'duration': duration,
    };
  }

  // Create from map for database retrieval (exercises loaded separately)
  factory WorkoutDay.fromMap(Map<String, dynamic> map, List<ExerciseRecord> exercises) {
    return WorkoutDay(
      date: DateFormat('yyyy-MM-dd').parse(map['date']),
      duration: map['duration'],
      exercises: exercises,
    );
  }
} 