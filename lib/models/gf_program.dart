import 'routine.dart';

class GFProgram {
  final Map<int, Routine> weekDays; // 1-7 for Monday-Sunday
  final int currentWeek;
  final Set<DateTime> completedDays;
  
  GFProgram({
    required this.weekDays,
    required this.currentWeek,
    required this.completedDays,
  });
  
  GFProgram copyWith({
    Map<int, Routine>? weekDays,
    int? currentWeek,
    Set<DateTime>? completedDays,
  }) {
    return GFProgram(
      weekDays: weekDays ?? this.weekDays,
      currentWeek: currentWeek ?? this.currentWeek,
      completedDays: completedDays ?? this.completedDays,
    );
  }
  
  // Add a completed day
  GFProgram markDayAsCompleted(DateTime date) {
    final newCompletedDays = Set<DateTime>.from(completedDays);
    newCompletedDays.add(DateTime(date.year, date.month, date.day));
    return copyWith(completedDays: newCompletedDays);
  }
  
  // Remove a completed day
  GFProgram markDayAsIncomplete(DateTime date) {
    final newCompletedDays = Set<DateTime>.from(completedDays);
    newCompletedDays.removeWhere((d) => 
      d.year == date.year && d.month == date.month && d.day == date.day);
    return copyWith(completedDays: newCompletedDays);
  }
  
  // Check if a day is completed
  bool isDayCompleted(DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    return completedDays.any((d) => 
      d.year == dateOnly.year && d.month == dateOnly.month && d.day == dateOnly.day);
  }
  
  // Get routine for a specific day
  Routine? getRoutineForDay(DateTime date) {
    final weekday = date.weekday;
    return weekDays[weekday];
  }
  
  // Convert completed days to a list of strings for storage
  List<String> _completedDaysToStringList() {
    return completedDays
        .map((date) => '${date.year}-${date.month}-${date.day}')
        .toList();
  }
  
  // Convert to map for database storage
  Map<String, dynamic> toMap() {
    return {
      'currentWeek': currentWeek,
      'completedDays': _completedDaysToStringList(),
    };
  }
  
  // Create from map for database retrieval (routines loaded separately)
  factory GFProgram.fromMap(
    Map<String, dynamic> map, 
    Map<int, Routine> routines,
    List<String> completedDayStrings,
  ) {
    final completedDays = completedDayStrings.map((dateStr) {
      final parts = dateStr.split('-');
      return DateTime(
        int.parse(parts[0]), 
        int.parse(parts[1]), 
        int.parse(parts[2])
      );
    }).toSet();
    
    return GFProgram(
      currentWeek: map['currentWeek'],
      weekDays: routines,
      completedDays: completedDays,
    );
  }
} 