import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/foundation.dart';

import '../models/enum/muscle_group.dart';
import '../models/hive/workout_record.dart';
import 'date_provider.dart';

part 'workout_provider.g.dart';

/// Provides access to workout records stored in Hive
@riverpod
class WorkoutRecords extends _$WorkoutRecords {
  late Box<WorkoutRecord> _workoutBox;
  
  @override
  Future<List<WorkoutRecord>> build() async {
    try {
      _workoutBox = Hive.box<WorkoutRecord>('workouts');
      return _workoutBox.values.toList();
    } catch (e) {
      throw Exception('Failed to load workouts: $e');
    }
  }
  
  /// Adds a new workout record
  Future<void> addWorkout(WorkoutRecord workout) async {
    try {
      // Save to Hive
      await _workoutBox.put(workout.id, workout);
      
      // Update the state immediately to refresh UI
      final currentState = await future;
      final updatedState = [...currentState, workout];
      
      // Sort workouts by date (newest first) for consistent display
      updatedState.sort((a, b) => b.date.compareTo(a.date));
      
      state = AsyncData(updatedState);
    } catch (e) {
      state = AsyncError('Failed to add workout: $e', StackTrace.current);
      throw Exception('Failed to add workout: $e');
    }
  }
  
  /// Updates an existing workout record
  Future<void> updateWorkout(WorkoutRecord workout) async {
    try {
      // Save to Hive
      await _workoutBox.put(workout.id, workout);
      
      // Update the workout in the state
      final currentState = await future;
      final updatedState = currentState.map((w) => 
        w.id == workout.id ? workout : w
      ).toList();
      
      state = AsyncData(updatedState);
    } catch (e) {
      state = AsyncError('Failed to update workout: $e', StackTrace.current);
      throw Exception('Failed to update workout: $e');
    }
  }
  
  /// Deletes a workout record
  Future<void> deleteWorkout(String workoutId) async {
    try {
      // Delete from Hive
      await _workoutBox.delete(workoutId);
      
      // Remove the workout from the state
      final currentState = await future;
      final updatedState = currentState.where((w) => w.id != workoutId).toList();
      
      state = AsyncData(updatedState);
    } catch (e) {
      state = AsyncError('Failed to delete workout: $e', StackTrace.current);
      throw Exception('Failed to delete workout: $e');
    }
  }
  
  /// Gets all workouts for a specific date
  Future<List<WorkoutRecord>> getWorkoutsForDate(DateTime date) async {
    try {
      final allWorkouts = await future;
      return allWorkouts.where((workout) => 
        isSameDay(workout.date, date)
      ).toList();
    } catch (e) {
      throw Exception('Failed to get workouts for date: $e');
    }
  }
  
  /// Force refresh data from Hive
  Future<void> refreshData() async {
    try {
      final workouts = _workoutBox.values.toList();
      workouts.sort((a, b) => b.date.compareTo(a.date));
      state = AsyncData(workouts);
    } catch (e) {
      state = AsyncError('Failed to refresh workouts: $e', StackTrace.current);
    }
  }
}

/// Provides workout for the selected date
@riverpod
Future<WorkoutRecord?> selectedDateWorkout(SelectedDateWorkoutRef ref) async {
  final selectedDate = ref.watch(selectedDateProvider);
  final workoutsAsyncValue = ref.watch(workoutRecordsProvider);
  
  return workoutsAsyncValue.when(
    data: (workouts) {
      final dayWorkouts = workouts.where((workout) => 
        isSameDay(workout.date, selectedDate)
      ).toList();
      
      return dayWorkouts.isNotEmpty ? dayWorkouts.first : null;
    },
    loading: () => null,
    error: (error, stack) {
      // Log the error but return null to avoid UI crashes
      debugPrint('Error loading selected date workout: $error\n$stack');
      return null;
    },
  );
}

/// Provides monthly workout statistics
@riverpod
Future<Map<DateTime, int>> monthlyWorkoutStats(MonthlyWorkoutStatsRef ref) async {
  final workoutsAsyncValue = ref.watch(workoutRecordsProvider);
  
  return workoutsAsyncValue.when(
    data: (workouts) {
      final Map<DateTime, int> monthStats = {};
      
      for (final workout in workouts) {
        final date = DateTime(workout.date.year, workout.date.month, workout.date.day);
        monthStats[date] = (monthStats[date] ?? 0) + 1;
      }
      
      return monthStats;
    },
    loading: () => {},
    error: (error, stack) {
      // Log the error but return empty map to avoid UI crashes
      debugPrint('Error loading monthly workout stats: $error\n$stack');
      return {};
    },
  );
}

/// Provides statistics on muscle groups trained
@riverpod
Future<Map<MuscleGroup, int>> muscleGroupStats(MuscleGroupStatsRef ref) async {
  final workoutsAsyncValue = ref.watch(workoutRecordsProvider);
  
  return workoutsAsyncValue.when(
    data: (workouts) {
      final Map<MuscleGroup, int> stats = {};
      
      for (final workout in workouts) {
        for (final group in workout.muscleGroups) {
          stats[group] = (stats[group] ?? 0) + 1;
        }
      }
      
      return stats;
    },
    loading: () => {},
    error: (error, stack) {
      // Log the error but return empty map to avoid UI crashes
      debugPrint('Error loading muscle group stats: $error\n$stack');
      return {};
    },
  );
}

/// Helper function to compare dates
bool isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
} 