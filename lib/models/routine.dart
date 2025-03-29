import 'bodyweight_exercise.dart';

class Routine {
  final String name;
  final String day; // Day of the week or routine name
  final List<BodyweightExercise> exercises;
  final int estimatedDuration;
  
  Routine({
    required this.name,
    required this.day,
    required this.exercises,
    required this.estimatedDuration,
  });
  
  Routine copyWith({
    String? name,
    String? day,
    List<BodyweightExercise>? exercises,
    int? estimatedDuration,
  }) {
    return Routine(
      name: name ?? this.name,
      day: day ?? this.day,
      exercises: exercises ?? this.exercises,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
    );
  }
  
  // Convert to map for database storage
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'day': day,
      'estimatedDuration': estimatedDuration,
    };
  }
  
  // Create from map for database retrieval (exercises loaded separately)
  factory Routine.fromMap(Map<String, dynamic> map, List<BodyweightExercise> exercises) {
    return Routine(
      name: map['name'],
      day: map['day'],
      estimatedDuration: map['estimatedDuration'],
      exercises: exercises,
    );
  }
} 