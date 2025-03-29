import 'package:hive/hive.dart';

import 'routine_record.dart';

part 'gf_program_record.g.dart';

/// Record of a user's GF program with routines for different days
@HiveType(typeId: 4)
class GFProgramRecord {
  /// Map of weekday (1-7) to routine
  @HiveField(0)
  final Map<int, RoutineRecord> weekDays;
  
  /// Current week of the program
  @HiveField(1)
  int currentWeek;
  
  /// Map to track completed days
  @HiveField(2)
  final Map<int, bool> completedDays;
  
  /// Constructor
  GFProgramRecord({
    required this.weekDays,
    required this.currentWeek,
    required this.completedDays,
  });
  
  /// Check if a specific day is completed
  bool isCompleted(int day) {
    return completedDays[day] == true;
  }
  
  /// Mark a day as completed
  void markCompleted(int day) {
    completedDays[day] = true;
  }
  
  /// Mark a day as incomplete
  void markIncomplete(int day) {
    completedDays.remove(day);
  }
  
  /// Get the number of completed days in the current week
  int getCompletedDaysCount() {
    return completedDays.length;
  }
  
  /// Get the total number of workout days in a week
  int getTotalWorkoutDays() {
    // Always return 6 for our specific program (6 workout days + 1 rest day)
    return 6;
  }
  
  /// Calculate the completion percentage for the current week
  double getWeekCompletionPercentage() {
    final totalDays = getTotalWorkoutDays();
    if (totalDays == 0) return 0;
    
    final completedCount = getCompletedDaysCount();
    return completedCount / totalDays;
  }
} 