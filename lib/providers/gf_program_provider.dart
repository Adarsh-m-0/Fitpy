import 'package:confetti/confetti.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/enum/muscle_group.dart';
import '../models/hive/exercise_record.dart';
import '../models/hive/gf_program_record.dart';
import '../models/hive/routine_record.dart';

part 'gf_program_provider.g.dart';

/// Provider for the GF Program
@riverpod
class GFProgram extends _$GFProgram {
  late Box<GFProgramRecord> _gfProgramBox;
  late ConfettiController confettiController;
  
  @override
  Future<GFProgramRecord> build() async {
    // Initialize confetti controller for celebration animations
    confettiController = ConfettiController(duration: const Duration(seconds: 3));
    
    // Access Hive box
    _gfProgramBox = Hive.box<GFProgramRecord>('gf_program');
    
    // Check if we already have a GF program record
    GFProgramRecord? program = _gfProgramBox.get('current');
    
    // If no program exists, create a default one
    if (program == null) {
      program = await _createDefaultProgram();
      await _gfProgramBox.put('current', program);
    }
    
    return program;
  }
  
  /// Toggle completion status of a workout day
  Future<void> toggleDayCompletion(int day) async {
    final program = await future;
    
    // Toggle completion status
    if (program.isCompleted(day)) {
      program.markIncomplete(day);
    } else {
      program.markCompleted(day);
      
      // Check if this completion triggers a week completion
      final weekProgress = program.getWeekCompletionPercentage();
      if (weekProgress == 1.0) {
        confettiController.play();
      }
    }
    
    // Save updated program
    await _gfProgramBox.put('current', program);
    
    // Refresh state
    ref.invalidateSelf();
  }
  
  /// Increment the program week
  Future<void> incrementWeek() async {
    final program = await future;
    
    // Clear completion status for the week
    program.completedDays.clear();
    
    // Increment week
    program.currentWeek++;
    
    // Save updated program
    await _gfProgramBox.put('current', program);
    
    // Refresh state
    ref.invalidateSelf();
  }
  
  /// Reset the program to week 1
  Future<void> resetProgram() async {
    final program = await future;
    
    // Reset to week 1 and clear completion
    program.currentWeek = 1;
    program.completedDays.clear();
    
    // Save updated program
    await _gfProgramBox.put('current', program);
    
    // Refresh state
    ref.invalidateSelf();
  }
  
  /// Create a default GF program
  Future<GFProgramRecord> _createDefaultProgram() async {
    // Day 1: Full-Body Strength
    final day1Routine = RoutineRecord(
      name: 'Full-Body Strength',
      day: 1, // Monday
      estimatedDuration: 45,
      exercises: [
        ExerciseRecord(
          name: 'Squats',
          sets: 3,
          reps: 15,
          muscleGroup: MuscleGroup.legs,
        ),
        ExerciseRecord(
          name: 'Push-Ups',
          sets: 3,
          reps: 12,
          muscleGroup: MuscleGroup.chest,
        ),
        ExerciseRecord(
          name: 'Reverse Lunges',
          sets: 3,
          reps: 10,
          muscleGroup: MuscleGroup.legs,
          notes: '10 per leg',
        ),
        ExerciseRecord(
          name: 'Plank',
          sets: 3,
          reps: 30,
          muscleGroup: MuscleGroup.core,
          notes: '30 seconds',
        ),
        ExerciseRecord(
          name: 'Glute Bridges',
          sets: 3,
          reps: 15,
          muscleGroup: MuscleGroup.legs,
        ),
        ExerciseRecord(
          name: 'Mountain Climbers',
          sets: 3,
          reps: 30,
          muscleGroup: MuscleGroup.core,
          notes: '30 seconds',
        ),
      ],
    );
    
    // Day 2: Cardio & Core
    final day2Routine = RoutineRecord(
      name: 'Cardio & Core',
      day: 2, // Tuesday
      estimatedDuration: 45,
      exercises: [
        ExerciseRecord(
          name: 'Jumping Jacks',
          sets: 3,
          reps: 60,
          muscleGroup: MuscleGroup.cardio,
          notes: '1 minute',
        ),
        ExerciseRecord(
          name: 'Bicycle Crunches',
          sets: 3,
          reps: 20,
          muscleGroup: MuscleGroup.core,
          notes: '20 per side',
        ),
        ExerciseRecord(
          name: 'High Knees',
          sets: 3,
          reps: 60,
          muscleGroup: MuscleGroup.cardio,
          notes: '1 minute',
        ),
        ExerciseRecord(
          name: 'Russian Twists',
          sets: 3,
          reps: 20,
          muscleGroup: MuscleGroup.core,
          notes: '20 per side',
        ),
        ExerciseRecord(
          name: 'Burpees',
          sets: 3,
          reps: 10,
          muscleGroup: MuscleGroup.fullBody,
        ),
        ExerciseRecord(
          name: 'Side Plank',
          sets: 3,
          reps: 30,
          muscleGroup: MuscleGroup.core,
          notes: '30 seconds per side',
        ),
      ],
    );
    
    // Day 3: Lower Body
    final day3Routine = RoutineRecord(
      name: 'Lower Body',
      day: 3, // Wednesday
      estimatedDuration: 45,
      exercises: [
        ExerciseRecord(
          name: 'Squats',
          sets: 4,
          reps: 15,
          muscleGroup: MuscleGroup.legs,
        ),
        ExerciseRecord(
          name: 'Forward Lunges',
          sets: 3,
          reps: 10,
          muscleGroup: MuscleGroup.legs,
          notes: '10 per leg',
        ),
        ExerciseRecord(
          name: 'Side Lunges',
          sets: 3,
          reps: 10,
          muscleGroup: MuscleGroup.legs,
          notes: '10 per leg',
        ),
        ExerciseRecord(
          name: 'Calf Raises',
          sets: 3,
          reps: 20,
          muscleGroup: MuscleGroup.legs,
        ),
        ExerciseRecord(
          name: 'Single-Leg Glute Bridges',
          sets: 3,
          reps: 12,
          muscleGroup: MuscleGroup.legs,
          notes: '12 per leg',
        ),
        ExerciseRecord(
          name: 'Wall Sit',
          sets: 3,
          reps: 45,
          muscleGroup: MuscleGroup.legs,
          notes: '30-60 seconds',
        ),
      ],
    );
    
    // Day 4: Upper Body & Core
    final day4Routine = RoutineRecord(
      name: 'Upper Body & Core',
      day: 4, // Thursday
      estimatedDuration: 45,
      exercises: [
        ExerciseRecord(
          name: 'Wide Push-Ups',
          sets: 3,
          reps: 12,
          muscleGroup: MuscleGroup.chest,
        ),
        ExerciseRecord(
          name: 'Tricep Dips',
          sets: 3,
          reps: 15,
          muscleGroup: MuscleGroup.arms,
        ),
        ExerciseRecord(
          name: 'Superman',
          sets: 3,
          reps: 20,
          muscleGroup: MuscleGroup.back,
        ),
        ExerciseRecord(
          name: 'Plank Shoulder Taps',
          sets: 3,
          reps: 20,
          muscleGroup: MuscleGroup.core,
        ),
        ExerciseRecord(
          name: 'Bird Dog',
          sets: 3,
          reps: 10,
          muscleGroup: MuscleGroup.core,
          notes: '10 per side',
        ),
        ExerciseRecord(
          name: 'Side Plank Dips',
          sets: 3,
          reps: 10,
          muscleGroup: MuscleGroup.core,
          notes: '10 per side',
        ),
      ],
    );
    
    // Day 5: Active Recovery (Yoga/Stretching)
    final day5Routine = RoutineRecord(
      name: 'Active Recovery (Yoga/Stretching)',
      day: 5, // Friday
      estimatedDuration: 30,
      exercises: [
        ExerciseRecord(
          name: 'Sun Salutations',
          sets: 1,
          reps: 10,
          muscleGroup: MuscleGroup.fullBody,
        ),
        ExerciseRecord(
          name: 'Pigeon Pose',
          sets: 1,
          reps: 60,
          muscleGroup: MuscleGroup.legs,
          notes: 'Each side, 60 seconds',
        ),
        ExerciseRecord(
          name: 'Butterfly Stretch',
          sets: 1,
          reps: 60,
          muscleGroup: MuscleGroup.legs,
          notes: '60 seconds',
        ),
        ExerciseRecord(
          name: 'Deep Breathing',
          sets: 1,
          reps: 5,
          muscleGroup: MuscleGroup.fullBody,
          notes: '5 minutes',
        ),
      ],
    );
    
    // Day 6: HIIT & Core
    final day6Routine = RoutineRecord(
      name: 'HIIT & Core',
      day: 6, // Saturday
      estimatedDuration: 30,
      exercises: [
        ExerciseRecord(
          name: 'Burpees',
          sets: 3,
          reps: 30,
          muscleGroup: MuscleGroup.fullBody,
          notes: '30 seconds, 3 rounds with 30s rest between',
        ),
        ExerciseRecord(
          name: 'Squat Jumps',
          sets: 3,
          reps: 30,
          muscleGroup: MuscleGroup.legs,
          notes: '30 seconds, 3 rounds with 30s rest between',
        ),
        ExerciseRecord(
          name: 'Plank Jacks',
          sets: 3,
          reps: 30,
          muscleGroup: MuscleGroup.core,
          notes: '30 seconds, 3 rounds with 30s rest between',
        ),
        ExerciseRecord(
          name: 'Mountain Climbers',
          sets: 3,
          reps: 30,
          muscleGroup: MuscleGroup.core,
          notes: '30 seconds, 3 rounds with 30s rest between',
        ),
        ExerciseRecord(
          name: 'Bicycle Crunches',
          sets: 3,
          reps: 30,
          muscleGroup: MuscleGroup.core,
          notes: '30 seconds, 3 rounds with 30s rest between',
        ),
      ],
    );
    
    // Day 7: Rest Day
    final day7Routine = RoutineRecord(
      name: 'Rest Day',
      day: 7, // Sunday
      estimatedDuration: 0,
      exercises: [], // No exercises on rest day
    );
    
    // Create the program with routines for 6 workout days plus rest day
    final program = GFProgramRecord(
      weekDays: {
        1: day1Routine,
        2: day2Routine,
        3: day3Routine,
        4: day4Routine,
        5: day5Routine,
        6: day6Routine,
        7: day7Routine, // Include rest day
      },
      currentWeek: 1,
      completedDays: {},
    );
    
    return program;
  }
}

/// Provider for a specific day's routine
@riverpod
Future<RoutineRecord?> dayRoutine(DayRoutineRef ref, int day) async {
  final programAsync = ref.watch(gFProgramProvider);
  
  return programAsync.when(
    data: (program) {
      return program.weekDays[day];
    },
    loading: () => null,
    error: (_, __) => null,
  );
}

/// Provider to check if a day is completed
@riverpod
Future<bool> isDayCompleted(IsDayCompletedRef ref, int day) async {
  final programAsync = ref.watch(gFProgramProvider);
  
  return programAsync.when(
    data: (program) {
      return program.isCompleted(day);
    },
    loading: () => false,
    error: (_, __) => false,
  );
}

/// Provider for week progress percentage
@riverpod
Future<double> weekProgress(WeekProgressRef ref) async {
  final programAsync = ref.watch(gFProgramProvider);
  
  return programAsync.when(
    data: (program) {
      return program.getWeekCompletionPercentage();
    },
    loading: () => 0.0,
    error: (_, __) => 0.0,
  );
}

/// Provider for current week number
@riverpod
Future<int> currentWeek(CurrentWeekRef ref) async {
  final programAsync = ref.watch(gFProgramProvider);
  
  return programAsync.when(
    data: (program) {
      return program.currentWeek;
    },
    loading: () => 1,
    error: (_, __) => 1,
  );
} 