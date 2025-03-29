import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart' as tc;

import '../models/enum/muscle_group.dart';
import '../models/hive/exercise_record.dart';
import '../models/hive/workout_record.dart';
import '../providers/date_provider.dart';
import '../providers/workout_provider.dart';
import '../widgets/workout_form_dialog.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedDateProvider);
    final todaysWorkoutAsync = ref.watch(selectedDateWorkoutProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Tracker'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildCalendar(),
          Expanded(
            child: todaysWorkoutAsync.when(
              data: (todaysWorkout) {
                if (todaysWorkout == null) {
                  return _buildEmptyState(selectedDate);
                } else {
                  return _buildWorkoutDetails(todaysWorkout);
                }
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('Error: $error'),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _isCurrentDay(selectedDate) ? FloatingActionButton(
        onPressed: () => _showAddWorkoutDialog(selectedDate),
        mini: true,
        child: const Icon(Icons.add),
      ) : null,
    );
  }

  // Helper method to check if a date is the current day
  bool _isCurrentDay(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  Widget _buildCalendar() {
    final selectedDate = ref.watch(selectedDateProvider);
    final focusedDate = ref.watch(focusedDateProvider);
    
    final workoutsStatsAsync = ref.watch(monthlyWorkoutStatsProvider);
    
    return workoutsStatsAsync.when(
      data: (workouts) {
        // Function to customize calendar day markers
        List<Widget> eventMarkerBuilder(context, day, events) {
          // Check if the day has a workout
          if (workouts.containsKey(day)) {
            // Determine if this is the selected date
            final isSelected = isSameDay(selectedDate, day);
            
            return [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected 
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  day.day.toString(),
                  style: TextStyle(
                    color: isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.bold : null,
                  ),
                ),
              ),
              Positioned(
                bottom: 5,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ];
          }
          
          // Default appearance for days without workouts
          final isSelected = isSameDay(selectedDate, day);
          return [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected 
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Text(
                day.day.toString(),
                style: TextStyle(
                  color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.bold : null,
                ),
              ),
            ),
          ];
        }
        
        return tc.TableCalendar(
          firstDay: DateTime.utc(2021, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: focusedDate,
          selectedDayPredicate: (day) => isSameDay(selectedDate, day),
          calendarFormat: tc.CalendarFormat.week,
          startingDayOfWeek: tc.StartingDayOfWeek.monday,
          daysOfWeekHeight: 20,
          rowHeight: 48,
          headerStyle: const tc.HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            headerPadding: EdgeInsets.symmetric(vertical: 8),
            titleTextStyle: TextStyle(fontSize: 14),
          ),
          calendarStyle: tc.CalendarStyle(
            markerDecoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          availableCalendarFormats: const {
            tc.CalendarFormat.week: 'Week',
          },
          onDaySelected: (selected, focused) {
            ref.read(selectedDateProvider.notifier).updateSelectedDate(selected);
            ref.read(focusedDateProvider.notifier).updateFocusedDate(focused);
          },
          eventLoader: (day) {
            return workouts.containsKey(day) ? [1] : [];
          },
          calendarBuilders: tc.CalendarBuilders(
            defaultBuilder: (context, day, _) {
              return eventMarkerBuilder(context, day, null).first;
            },
            todayBuilder: (context, day, _) {
              return Stack(
                alignment: Alignment.center,
                children: eventMarkerBuilder(context, day, null),
              );
            },
            selectedBuilder: (context, day, _) {
              return Stack(
                alignment: Alignment.center,
                children: eventMarkerBuilder(context, day, null),
              );
            },
            markerBuilder: (context, day, events) {
              if (workouts.containsKey(day)) {
                return Positioned(
                  bottom: 5,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isSameDay(selectedDate, day)
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }
              return null;
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error loading calendar: $error'),
      ),
    );
  }

  Widget _buildEmptyState(DateTime date) {
    final dateFormatter = DateFormat('EEEE, MMMM d');
    final workoutsAsync = ref.watch(workoutRecordsProvider);
    final isToday = _isCurrentDay(date);
    
    return workoutsAsync.when(
      data: (workouts) {
        // Show different message based on total workouts
        final bool hasAnyWorkouts = workouts.isNotEmpty;
        
        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer.withAlpha(76),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    hasAnyWorkouts ? Icons.fitness_center_outlined : Icons.directions_run,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  hasAnyWorkouts 
                      ? isToday ? 'No Workout Yet?' : 'Rest Day'
                      : 'Start Your Fitness Journey!',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  isToday
                      ? hasAnyWorkouts
                          ? 'No workout for today yet.\nAdd one to track your progress!'
                          : 'Track your workouts, see your progress,\nand stay motivated to reach your goals.'
                      : 'No workout recorded for ${dateFormatter.format(date)}.\nWorkouts can only be added for the current day.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withAlpha(179),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                
                // Add workout button - only visible for today
                if (isToday) 
                  FilledButton.icon(
                    onPressed: () => _showAddWorkoutDialog(date),
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(hasAnyWorkouts ? 'Add Workout' : 'Add First Workout'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      minimumSize: const Size(200, 48),
                    ),
                  ),
                
                if (hasAnyWorkouts) ...[
                  const SizedBox(height: 40),
                  _buildQuickStats(workouts),
                  const SizedBox(height: 32),
                  
                  // Suggested workout for this day - only if it's today
                  if (isToday) _buildSuggestedWorkoutType(date),
                ],
                
                // If no workouts, show more descriptive info
                if (!hasAnyWorkouts) ...[
                  const SizedBox(height: 48),
                  _buildFeaturesList(),
                ],
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error: $error'),
      ),
    );
  }
  
  Widget _buildQuickStats(List<WorkoutRecord> workouts) {
    // Calculate some basic stats
    final totalWorkouts = workouts.length;
    
    // Find most common muscle group
    final muscleGroupCounts = <MuscleGroup, int>{};
    for (var workout in workouts) {
      for (var group in workout.muscleGroups) {
        muscleGroupCounts[group] = (muscleGroupCounts[group] ?? 0) + 1;
      }
    }
    
    MuscleGroup? mostCommonGroup;
    int maxCount = 0;
    muscleGroupCounts.forEach((group, count) {
      if (count > maxCount) {
        maxCount = count;
        mostCommonGroup = group;
      }
    });
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'Quick Stats',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildQuickStat(
                context,
                'Total Workouts',
                totalWorkouts.toString(),
                Icons.fitness_center,
              ),
              if (mostCommonGroup != null)
                _buildQuickStat(
                  context,
                  'Favorite',
                  mostCommonGroup?.displayName ?? 'Unknown',
                  Icons.favorite,
                  color: Colors.red,
                )
              else
                _buildQuickStat(
                  context,
                  'Favorite',
                  'None',
                  Icons.favorite_border,
                  color: Colors.grey,
                ),
              _buildQuickStat(
                context,
                'Streak',
                _calculateStreak(workouts).toString(),
                Icons.local_fire_department,
                color: Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildQuickStat(BuildContext context, String label, String value, IconData icon, {Color? color}) {
    return Column(
      children: [
        Icon(
          icon,
          size: 22,
          color: color ?? Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color ?? Theme.of(context).colorScheme.onSurface,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
      ],
    );
  }
  
  int _calculateStreak(List<WorkoutRecord> workouts) {
    if (workouts.isEmpty) return 0;
    
    int currentStreak = 0;
    
    // Sort by date (newest first)
    final sortedWorkouts = [...workouts];
    sortedWorkouts.sort((a, b) => b.date.compareTo(a.date));
    
    // Check if today or yesterday has a workout
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final yesterdayDate = DateTime(today.year, today.month, today.day - 1);
    
    final hasWorkoutTodayOrYesterday = sortedWorkouts.any((w) {
      final wDate = DateTime(w.date.year, w.date.month, w.date.day);
      return wDate.isAtSameMomentAs(todayDate) || wDate.isAtSameMomentAs(yesterdayDate);
    });
    
    if (hasWorkoutTodayOrYesterday) {
      currentStreak = 1;
      
      // Go backward day by day
      for (int i = 1; i < 365; i++) {
        final previousDate = DateTime(today.year, today.month, today.day - i);
        
        // Check if there's a workout on this date
        final hasWorkout = workouts.any((w) {
          final wDate = DateTime(w.date.year, w.date.month, w.date.day);
          return wDate.isAtSameMomentAs(previousDate);
        });
        
        if (hasWorkout) {
          currentStreak++;
        } else {
          // Streak is broken
          break;
        }
      }
    }
    
    return currentStreak;
  }
  
  Widget _buildSuggestedWorkoutType(DateTime date) {
    // Get day of the week
    final dayOfWeek = date.weekday;
    
    // Very simple recommendation based on day of the week
    MuscleGroup suggestedGroup;
    String dayName = DateFormat('EEEE').format(date);
    
    switch (dayOfWeek) {
      case DateTime.monday:
        suggestedGroup = MuscleGroup.chest;
        break;
      case DateTime.tuesday:
        suggestedGroup = MuscleGroup.back;
        break;
      case DateTime.wednesday:
        suggestedGroup = MuscleGroup.legs;
        break;
      case DateTime.thursday:
        suggestedGroup = MuscleGroup.shoulders;
        break;
      case DateTime.friday:
        suggestedGroup = MuscleGroup.arms;
        break;
      case DateTime.saturday:
        suggestedGroup = MuscleGroup.core;
        break;
      case DateTime.sunday:
      default:
        suggestedGroup = MuscleGroup.cardio;
        break;
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer.withAlpha(76),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lightbulb_outline,
                size: 16,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(width: 8),
              Text(
                'Suggested for $dayName',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  shape: BoxShape.circle,
                ),
                child: _getMuscleGroupIcon(suggestedGroup),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    suggestedGroup.displayName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'Great day for ${suggestedGroup.displayName.toLowerCase()} exercises!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {
              // Create a pre-filled workout with the suggested muscle group
              _showAddWorkoutDialog(date);
            },
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Create Workout'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFeaturesList() {
    return Column(
      children: [
        Text(
          'Features',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        _buildFeatureItem(Icons.calendar_today, 'Track your workouts by date'),
        _buildFeatureItem(Icons.show_chart, 'Monitor your progress over time'),
        _buildFeatureItem(Icons.fitness_center, 'Log exercises for different muscle groups'),
        _buildFeatureItem(Icons.local_fire_department, 'Build and maintain streaks'),
      ],
    );
  }
  
  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutDetails(WorkoutRecord workout) {
    final dateFormatter = DateFormat('EEEE, MMMM d');
    final isToday = _isCurrentDay(workout.date);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Statistics card
          _buildStatsCard(),
          
          // Header card with date and actions
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.calendar_today,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dateFormatter.format(workout.date),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (!isToday) 
                          Text(
                            'Historical workout - cannot be modified',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (isToday) ...[
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showAddWorkoutDialog(workout.date, workout),
                      tooltip: 'Edit workout',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _confirmDelete(workout),
                      tooltip: 'Delete workout',
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          // Muscle groups card
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.fitness_center,
                          color: Theme.of(context).colorScheme.onSecondaryContainer,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Muscle Groups',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: workout.muscleGroups.map((group) {
                      return Chip(
                        avatar: _getMuscleGroupIcon(group),
                        label: Text(group.displayName),
                        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          
          // Exercises list
          if (workout.exercises.isNotEmpty) ... [
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 8, top: 8),
              child: Text(
                'Exercises',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...workout.exercises.map((exercise) => _buildExerciseCard(exercise)).toList(),
          ],
          
          // Notes card (only if notes exist)
          if (workout.notes != null && workout.notes!.isNotEmpty)
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.tertiaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.notes,
                            color: Theme.of(context).colorScheme.onTertiaryContainer,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Notes',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      workout.notes!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            
          // Suggested next workout
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: _buildSuggestedNextWorkout(workout),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatsCard() {
    final workoutsAsync = ref.watch(workoutRecordsProvider);
    
    return workoutsAsync.when(
      data: (workouts) {
        // Calculate stats
        final totalWorkouts = workouts.length;
        final thisWeekWorkouts = workouts.where((w) => 
          w.date.isAfter(DateTime.now().subtract(const Duration(days: 7)))).length;
        
        // Calculate streak
        int currentStreak = 0;
        DateTime? lastWorkoutDate;
        
        final sortedWorkouts = [...workouts];
        sortedWorkouts.sort((a, b) => b.date.compareTo(a.date));
        
        if (sortedWorkouts.isNotEmpty) {
          lastWorkoutDate = sortedWorkouts.first.date;
          
          // Check if today or yesterday has a workout
          final today = DateTime.now();
          final todayDate = DateTime(today.year, today.month, today.day);
          final yesterdayDate = DateTime(today.year, today.month, today.day - 1);
          
          final hasWorkoutTodayOrYesterday = sortedWorkouts.any((w) {
            final wDate = DateTime(w.date.year, w.date.month, w.date.day);
            return wDate.isAtSameMomentAs(todayDate) || wDate.isAtSameMomentAs(yesterdayDate);
          });
          
          if (hasWorkoutTodayOrYesterday) {
            currentStreak = 1;
            
            // Go backward day by day
            for (int i = 1; i < 365; i++) {
              final previousDate = DateTime(today.year, today.month, today.day - i);
              
              // Check if there's a workout on this date
              final hasWorkout = workouts.any((w) {
                final wDate = DateTime(w.date.year, w.date.month, w.date.day);
                return wDate.isAtSameMomentAs(previousDate);
              });
              
              if (hasWorkout) {
                currentStreak++;
              } else {
                // Streak is broken
                break;
              }
            }
          }
        }
        
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Progress',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      context,
                      'Total\nWorkouts',
                      totalWorkouts.toString(),
                      Icons.fitness_center,
                    ),
                    _buildStatItem(
                      context,
                      'Current\nStreak',
                      '$currentStreak ${currentStreak == 1 ? 'day' : 'days'}',
                      Icons.local_fire_department,
                      color: Colors.orange,
                    ),
                    _buildStatItem(
                      context,
                      'This\nWeek',
                      thisWeekWorkouts.toString(),
                      Icons.date_range,
                    ),
                  ],
                ),
                if (lastWorkoutDate != null) ...[
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.history,
                        size: 16,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Last workout: ${DateFormat('MMM d').format(lastWorkoutDate)}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.outline,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Error loading stats: $error'),
        ),
      ),
    );
  }
  
  Widget _buildStatItem(BuildContext context, String label, String value, IconData icon, {Color? color}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color != null 
                ? color.withAlpha(26) 
                : Theme.of(context).colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color ?? Theme.of(context).colorScheme.primary,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color ?? Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.outline,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildExerciseCard(ExerciseRecord exercise) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _getMuscleGroupIcon(exercise.muscleGroup),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      exercise.muscleGroup.displayName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildExerciseDetail(context, 'Sets', '${exercise.sets}', Icons.fitness_center),
                _buildExerciseDetail(context, 'Reps', '${exercise.reps}', Icons.repeat),
              ],
            ),
            if (exercise.notes != null && exercise.notes!.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.notes,
                    size: 16,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      exercise.notes!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildExerciseDetail(BuildContext context, String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
      ],
    );
  }
  
  Widget _buildSuggestedNextWorkout(WorkoutRecord currentWorkout) {
    // Simple suggestion logic: suggest a different muscle group
    final allGroups = MuscleGroup.values.toList();
    
    // Remove current muscle groups from suggestions
    final availableGroups = allGroups
        .where((group) => !currentWorkout.muscleGroups.contains(group))
        .toList();
    
    // If all muscle groups are already used, suggest any
    final suggestedGroup = availableGroups.isNotEmpty 
        ? availableGroups.first 
        : allGroups.first;
    
    return Card(
      margin: EdgeInsets.zero,
      color: Theme.of(context).colorScheme.secondaryContainer.withAlpha(128),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Suggested Next Workout',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: _getMuscleGroupIcon(suggestedGroup),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      suggestedGroup.displayName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'For a balanced routine',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                OutlinedButton(
                  onPressed: () {
                    final tomorrow = DateTime.now().add(const Duration(days: 1));
                    _showAddWorkoutDialog(
                      DateTime(tomorrow.year, tomorrow.month, tomorrow.day),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Schedule'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddWorkoutDialog(DateTime date, [WorkoutRecord? existingWorkout]) {
    // Only allow adding or editing workouts for the current day
    if (!_isCurrentDay(date) && existingWorkout == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Workouts can only be added for the current day'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }
    
    // Only allow editing workouts created today
    if (existingWorkout != null && !_isCurrentDay(existingWorkout.date)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Historical workouts cannot be modified'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }
    
    showDialog(
      context: context,
      builder: (context) => WorkoutFormDialog(
        selectedDate: date,
        existingWorkout: existingWorkout,
      ),
    ).then((saved) {
      if (saved == true) {
        // Refresh the UI (will happen automatically with Riverpod)
      }
    });
  }

  void _confirmDelete(WorkoutRecord workout) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Workout'),
        content: const Text('Are you sure you want to delete this workout? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(workoutRecordsProvider.notifier).deleteWorkout(workout.id);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // Helper method to get the appropriate icon for each muscle group
  Icon _getMuscleGroupIcon(MuscleGroup group) {
    switch (group) {
      case MuscleGroup.chest:
        return const Icon(Icons.fitness_center);
      case MuscleGroup.back:
        return const Icon(Icons.arrow_upward);
      case MuscleGroup.shoulders:
        return const Icon(Icons.accessibility_new);
      case MuscleGroup.arms:
        return const Icon(Icons.sports_martial_arts);
      case MuscleGroup.legs:
        return const Icon(Icons.directions_walk);
      case MuscleGroup.core:
        return const Icon(Icons.circle);
      case MuscleGroup.cardio:
        return const Icon(Icons.directions_run);
      case MuscleGroup.fullBody:
        return const Icon(Icons.accessibility);
    }
  }
} 