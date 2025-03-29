import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'muscle_group.g.dart';

/// Enum defining different muscle groups
@HiveType(typeId: 0)
enum MuscleGroup {
  @HiveField(0)
  chest,
  
  @HiveField(1)
  back,
  
  @HiveField(2)
  shoulders,
  
  @HiveField(3)
  arms,
  
  @HiveField(4)
  legs,
  
  @HiveField(5)
  core,
  
  @HiveField(6)
  cardio,
  
  @HiveField(7)
  fullBody;
  
  /// Get display name for the muscle group
  String get displayName {
    switch (this) {
      case MuscleGroup.chest:
        return 'Chest';
      case MuscleGroup.back:
        return 'Back';
      case MuscleGroup.shoulders:
        return 'Shoulders';
      case MuscleGroup.arms:
        return 'Arms';
      case MuscleGroup.legs:
        return 'Legs';
      case MuscleGroup.core:
        return 'Core';
      case MuscleGroup.cardio:
        return 'Cardio';
      case MuscleGroup.fullBody:
        return 'Full Body';
    }
  }
  
  Color get color {
    switch (this) {
      case MuscleGroup.chest:
        return Colors.red;
      case MuscleGroup.back:
        return Colors.blue;
      case MuscleGroup.shoulders:
        return Colors.purple;
      case MuscleGroup.arms:
        return Colors.orange;
      case MuscleGroup.legs:
        return Colors.green;
      case MuscleGroup.core:
        return Colors.amber;
      case MuscleGroup.cardio:
        return Colors.pink;
      case MuscleGroup.fullBody:
        return Colors.teal;
    }
  }
  
  IconData get icon {
    switch (this) {
      case MuscleGroup.chest:
        return Icons.fitness_center;
      case MuscleGroup.back:
        return Icons.arrow_upward;
      case MuscleGroup.shoulders:
        return Icons.accessibility_new;
      case MuscleGroup.arms:
        return Icons.sports_martial_arts;
      case MuscleGroup.legs:
        return Icons.directions_walk;
      case MuscleGroup.core:
        return Icons.circle;
      case MuscleGroup.cardio:
        return Icons.directions_run;
      case MuscleGroup.fullBody:
        return Icons.accessibility;
    }
  }
} 