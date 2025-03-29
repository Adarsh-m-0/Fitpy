import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

import '../models/hive/gf_program_record.dart';
import '../models/hive/routine_record.dart';
import '../providers/gf_program_provider.dart';
import '../widgets/gf_routine_card.dart';
import '../widgets/progress_ring.dart';

/// Class to hold workout widget and metadata for the GF Program screen
class _WorkoutItem {
  final Widget workout;
  final int weekday;
  final bool isToday;
  
  _WorkoutItem({required this.workout, required this.weekday, required this.isToday});
}

class GFProgramScreen extends ConsumerStatefulWidget {
  const GFProgramScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<GFProgramScreen> createState() => _GFProgramScreenState();
}

class _GFProgramScreenState extends ConsumerState<GFProgramScreen> {
  Set<int> _weekSelection = {0}; // 0 = Current Week, 1 = Previous Week
  bool _showAllDays = false;
  
  // Controller for scrolling to today's workout
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final programAsync = ref.watch(gFProgramProvider);
    final weekProgressAsync = ref.watch(weekProgressProvider);
    
    // Calculate dates for the week view
    final now = DateTime.now();
    final startOfWeek = DateTime(now.year, now.month, now.day - now.weekday + 1);
    final daysOfWeek = List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
    
    // Get screen width to adjust UI based on available space
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    
    return programAsync.when(
      data: (program) {
        final confettiController = ref.read(gFProgramProvider.notifier).confettiController;
        final currentWeek = program.currentWeek;
        final viewingPreviousWeek = _weekSelection.first == 1;
        final viewingWeek = viewingPreviousWeek ? currentWeek - 1 : currentWeek;
        
        // Build the list of workouts for the week
        final workoutsForWeek = _buildWorkoutsForWeek(
          program, 
          daysOfWeek, 
          now, 
          viewingPreviousWeek,
        );
        
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Week $viewingWeek',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: isSmallScreen ? 18 : 20, // Responsive title size
              ),
            ),
            elevation: 0,
            titleSpacing: isSmallScreen ? 4 : 8, // Tighter spacing on small screens
            actions: [
              // Week selector as dropdown with better tap target
              if (currentWeek > 1)
                PopupMenuButton<int>(
                  tooltip: 'Select Week',
                  padding: EdgeInsets.zero, // Remove padding for better sizing
                  icon: Icon(
                    viewingPreviousWeek ? Icons.history : Icons.calendar_today,
                    size: isSmallScreen ? 20 : 22, // Responsive icon size
                  ),
                  onSelected: (value) {
                    setState(() {
                      _weekSelection = {value};
                      _showAllDays = false;
                    });
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 0,
                      height: 40, // Smaller height for better density
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 18,
                            color: _weekSelection.first == 0
                                ? Theme.of(context).colorScheme.primary
                                : null,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Current Week',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: _weekSelection.first == 0
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: _weekSelection.first == 0
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 1,
                      height: 40, // Smaller height for better density
                      child: Row(
                        children: [
                          Icon(
                            Icons.history,
                            size: 18,
                            color: _weekSelection.first == 1
                                ? Theme.of(context).colorScheme.primary
                                : null,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Previous Week',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: _weekSelection.first == 1
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: _weekSelection.first == 1
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              IconButton(
                icon: Icon(Icons.info_outline, size: isSmallScreen ? 20 : 22),
                onPressed: () => _showInfoDialog(context),
                tooltip: 'Program Info',
                visualDensity: VisualDensity.compact, // More compact
              ),
              // Add a small space at the end for better touch areas
              const SizedBox(width: 4),
            ],
          ),
          body: SafeArea(
            child: Stack(
              children: [
                // Main content
                Column(
                  children: [
                    // Weekly navigation when viewing previous weeks - more compact
                    if (viewingPreviousWeek && currentWeek > 2)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Week ${currentWeek - 1}',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 15, // Smaller font size
                              ),
                            ),
                            const Spacer(),
                            OutlinedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _weekSelection = {0}; // Go back to current week
                                });
                              },
                              icon: const Text(
                                'Current',
                                style: TextStyle(
                                  fontSize: 13, // Smaller font size
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              label: const Icon(Icons.arrow_forward_ios, size: 14), // Smaller icon
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6, // Smaller padding
                                  horizontal: 10, // Smaller padding
                                ),
                                minimumSize: const Size(0, 32), // Smaller minimum size
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8), // Smaller radius
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    
                    // Week progress section
                    _buildWeekProgressSection(context, program, weekProgressAsync, viewingWeek, isSmallScreen),
                    
                    // Toggle to show all days with more compact design
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        children: [
                          Text(
                            viewingPreviousWeek ? 'Week Overview' : 'Today\'s Workout',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: isSmallScreen ? 14 : 15, // Smaller on small screens
                            ),
                          ),
                          const Spacer(),
                          if (!viewingPreviousWeek && _hasFutureWorkouts(workoutsForWeek))
                            TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  _showAllDays = !_showAllDays;
                                });
                              },
                              icon: Icon(
                                _showAllDays ? Icons.unfold_less : Icons.unfold_more,
                                size: 18, // Smaller icon
                              ),
                              label: Text(
                                _showAllDays ? 'Show Less' : 'Show All',
                                style: const TextStyle(
                                  fontSize: 12, // Smaller text
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8, // Smaller padding
                                  vertical: 4, // Smaller padding
                                ),
                                minimumSize: const Size(0, 28), // Smaller minimum height
                              ),
                            ),
                        ],
                      ),
                    ),
                    
                    // Empty state if no workouts - more compact
                    if (workoutsForWeek.isEmpty)
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.fitness_center_outlined,
                                size: 60, // Smaller icon
                                color: Theme.of(context).colorScheme.outline,
                              ),
                              const SizedBox(height: 16), // Less spacing
                              Text(
                                'No workouts for this week',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15, // Smaller text
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    // Week calendar view with better scrolling
                    else
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.only(bottom: 24),
                          itemCount: workoutsForWeek.length,
                          itemBuilder: (context, index) {
                            final item = workoutsForWeek[index];
                            return item.workout;
                          },
                        ),
                      ),
                  ],
                ),
                
                // Confetti effect - reduce particles for performance
                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: confettiController,
                    blastDirection: math.pi / 2, // straight up
                    emissionFrequency: 0.05,
                    numberOfParticles: 10, // Reduced for performance
                    maxBlastForce: 70, // Reduced for better mobile experience
                    minBlastForce: 50, // Reduced for better mobile experience
                    gravity: 0.2,
                  ),
                ),
              ],
            ),
          ),
          // Floating button to jump to today's workout - smaller on mobile
          floatingActionButton: (!viewingPreviousWeek && _hasWorkoutToday(workoutsForWeek) && _showAllDays)
            ? FloatingActionButton.small( // Use small FAB for better proportions
                onPressed: _scrollToToday,
                tooltip: 'Scroll to Today',
                child: const Icon(Icons.today, size: 20),
              )
            : null,
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Better position on small screens
        );
      },
      loading: () => const Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16), // Less vertical space
                Text(
                  'Loading your program...',
                  style: TextStyle(fontSize: 14), // Smaller text
                ),
              ],
            ),
          ),
        ),
      ),
      error: (error, _) => Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0), // Slightly smaller padding
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Theme.of(context).colorScheme.error,
                    size: 56, // Smaller icon
                  ),
                  const SizedBox(height: 16), // Less vertical space
                  Text(
                    'Error loading program',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8), // Less vertical space
                  Text(
                    error.toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24), // Less vertical space
                  FilledButton.icon(
                    onPressed: () {
                      ref.invalidate(gFProgramProvider);
                    },
                    icon: const Icon(Icons.refresh, size: 20), // Smaller icon
                    label: const Text(
                      'Retry',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  /// Build the list of workouts for the week
  List<_WorkoutItem> _buildWorkoutsForWeek(
    GFProgramRecord program,
    List<DateTime> daysOfWeek,
    DateTime now,
    bool viewingPreviousWeek,
  ) {
    final List<_WorkoutItem> workouts = [];
    
    for (int index = 0; index < daysOfWeek.length; index++) {
      final date = daysOfWeek[index];
      final weekday = date.weekday; // 1-7 (Monday-Sunday)
      final routine = program.weekDays[weekday];
      final isToday = _isSameDay(date, now);
      
      // If it's a Sunday (day 7) and we have a routine with no exercises, it's a rest day
      // We still want to show it
      final isRestDay = weekday == 7 && routine != null && routine.exercises.isEmpty;
      
      // Skip days without workouts, unless it's a rest day
      if (routine == null && !isRestDay) continue;
      
      // Filter to show only today's workout unless expanded or viewing previous week
      if (!_showAllDays && !viewingPreviousWeek && !isToday) continue;
      
      final dayCard = FutureBuilder<bool>(
        future: ref.watch(isDayCompletedProvider(weekday).future),
        builder: (context, snapshot) {
          final isCompleted = snapshot.data ?? false;
          
          return _buildDayCard(
            context, 
            ref,
            weekday,
            routine,
            isToday,
            isCompleted,
            viewingPreviousWeek,
          );
        },
      );
      
      workouts.add(_WorkoutItem(
        workout: dayCard,
        weekday: weekday,
        isToday: isToday,
      ));
    }
    
    return workouts;
  }
  
  /// Check if there's a workout scheduled for today
  bool _hasWorkoutToday(List<_WorkoutItem> workouts) {
    return workouts.any((w) => w.isToday);
  }
  
  /// Check if there are workouts scheduled for future days
  bool _hasFutureWorkouts(List<_WorkoutItem> workouts) {
    final now = DateTime.now();
    int todayWeekday = now.weekday;
    
    return workouts.any((w) => w.weekday > todayWeekday);
  }
  
  /// Scroll to today's workout
  void _scrollToToday() {
    // Find the index of today's workout
    final now = DateTime.now();
    int scrollIndex = 0;
    
    // Find workout items visible in the list
    final visibleWorkoutItems = _buildWorkoutsForWeek(
      ref.read(gFProgramProvider).value!,
      List.generate(7, (index) => 
        DateTime.now().subtract(Duration(days: DateTime.now().weekday - index - 1))),
      now,
      false,
    );
    
    // Find index of today in visible items
    for (int i = 0; i < visibleWorkoutItems.length; i++) {
      if (visibleWorkoutItems[i].isToday) {
        scrollIndex = i;
        break;
      }
    }
    
    // Scroll to the item
    if (scrollIndex < visibleWorkoutItems.length) {
      _scrollController.animateTo(
        scrollIndex * 220.0, // Increased height for each item
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }
  
  /// Build the week progress section with stats
  Widget _buildWeekProgressSection(
    BuildContext context, 
    GFProgramRecord program, 
    AsyncValue<double> weekProgressAsync,
    int currentWeek,
    bool isSmallScreen,
  ) {
    final completedWorkouts = program.getCompletedDaysCount();
    final totalWorkouts = program.getTotalWorkoutDays();
    final viewingPreviousWeek = _weekSelection.first == 1;
    
    // Simplified version for previous week
    if (viewingPreviousWeek) {
      return Card(
        margin: const EdgeInsets.fromLTRB(12, 4, 12, 6),
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10), // Reduced padding
          child: Row(
            children: [
              Icon(
                Icons.history,
                size: 18, // Smaller icon
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8), // Less horizontal space
              Expanded(
                child: Text(
                  'Historical view of Week $currentWeek',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith( // Smaller text style
                    fontWeight: FontWeight.bold,
                    fontSize: 13, // Reduced font size
                  ),
                ),
              ),
              Text(
                '$completedWorkouts/$totalWorkouts',
                style: Theme.of(context).textTheme.titleSmall?.copyWith( // Smaller text style
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 13, // Reduced font size
                ),
              ),
              const SizedBox(width: 4), // Less horizontal space
              Text(
                'completed',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 12, // Reduced font size
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    // Responsive progress ring size
    final ringSize = isSmallScreen ? 80.0 : 90.0;
    final strokeWidth = isSmallScreen ? 6.0 : 8.0;
    final ringRadius = isSmallScreen ? 35.0 : 40.0;
    final centerTextSize = isSmallScreen ? 14.0 : 15.0;
    
    // Regular progress section for current week - completely restructured
    return Card(
      margin: const EdgeInsets.fromLTRB(12, 4, 12, 6),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Header with title
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "This Week's Progress",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: isSmallScreen ? 14 : 16,
                  ),
                ),
              ],
            ),
          ),
          
          // Divider
          Divider(
            height: 1,
            thickness: 1,
            indent: 16,
            endIndent: 16,
            color: Theme.of(context).colorScheme.outlineVariant.withAlpha(76),
          ),
          
          // Content area
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left side - Progress Ring
                weekProgressAsync.when(
                  data: (weekProgress) {
                    return SizedBox(
                      width: ringSize,
                      height: ringSize,
                      child: ProgressRing(
                        progress: weekProgress,
                        strokeWidth: strokeWidth,
                        radius: ringRadius,
                        gradientColors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.tertiary,
                        ],
                        centerText: '${(weekProgress * 100).toInt()}%',
                        centerTextStyle: TextStyle(
                          fontSize: centerTextSize,
                          fontWeight: FontWeight.bold,
                        ),
                        addShadow: !isSmallScreen,
                      ),
                    );
                  },
                  loading: () => SizedBox(
                    width: ringSize,
                    height: ringSize,
                    child: CircularProgressIndicator(strokeWidth: strokeWidth),
                  ),
                  error: (_, __) => SizedBox(
                    width: ringSize,
                    height: ringSize,
                    child: Icon(Icons.error, size: isSmallScreen ? 30 : 36),
                  ),
                ),
                
                // Middle - Spacer & Vertical Divider
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    height: ringSize * 0.7,
                    width: 1,
                    color: Theme.of(context).colorScheme.outlineVariant.withAlpha(128),
                  ),
                ),
                
                // Right side - Stats Column
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Workouts stat
                      _buildStatRow(
                        icon: Icons.fitness_center, 
                        label: 'Workouts', 
                        value: '$completedWorkouts/$totalWorkouts',
                        context: context,
                        isSmallScreen: isSmallScreen,
                      ),
                      SizedBox(height: isSmallScreen ? 8 : 12),
                      
                      // Week stat
                      _buildStatRow(
                        icon: Icons.calendar_today, 
                        label: 'Week', 
                        value: currentWeek.toString(),
                        context: context,
                        isSmallScreen: isSmallScreen,
                      ),
                      SizedBox(height: isSmallScreen ? 8 : 12),
                      
                      // Completion stat
                      _buildStatRow(
                        icon: Icons.percent, 
                        label: 'Complete', 
                        value: weekProgressAsync.when(
                          data: (progress) => '${(progress * 100).toInt()}%',
                          loading: () => '-%',
                          error: (_, __) => '-%',
                        ),
                        context: context,
                        isSmallScreen: isSmallScreen,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Day progress indicators
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: _buildDayProgressIndicators(context, program),
          ),
        ],
      ),
    );
  }
  
  /// Build day progress indicators showing a visual representation of the 7-day week
  Widget _buildDayProgressIndicators(BuildContext context, GFProgramRecord program) {
    final dayIndicators = <Widget>[];
    
    // Create indicators for all 7 days
    for (int i = 1; i <= 7; i++) {
      final hasRoutine = program.weekDays.containsKey(i);
      final isCompleted = program.isCompleted(i);
      final isRestDay = i == 7; // Sunday is rest day
      
      // Day indicator
      dayIndicators.add(
        Expanded(
          child: Column(
            children: [
              // Circle indicator
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted
                      ? Theme.of(context).colorScheme.primary.withAlpha(128)
                      : (isRestDay
                          ? Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(128)
                          : Theme.of(context).colorScheme.surfaceContainerHigh.withAlpha(128)),
                  border: Border.all(
                    color: hasRoutine
                        ? Theme.of(context).colorScheme.primary.withAlpha(128)
                        : Theme.of(context).colorScheme.outline.withAlpha(76),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: isCompleted
                      ? Icon(
                          Icons.check,
                          size: 14,
                          color: Theme.of(context).colorScheme.onPrimary,
                        )
                      : (isRestDay
                          ? Icon(
                              Icons.hotel_rounded,
                              size: 12,
                              color: Theme.of(context).colorScheme.outline,
                            )
                          : null),
                ),
              ),
              
              // Day initial
              Text(
                _getDayInitial(i),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
                  color: isCompleted
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    return Row(children: dayIndicators);
  }
  
  /// Get day initial from weekday index
  String _getDayInitial(int weekday) {
    switch (weekday) {
      case 1: return 'M';
      case 2: return 'T';
      case 3: return 'W';
      case 4: return 'T';
      case 5: return 'F';
      case 6: return 'S';
      case 7: return 'S';
      default: return '';
    }
  }
  
  /// Build a stat row with icon, label and value
  Widget _buildStatRow({
    required IconData icon,
    required String label,
    required String value,
    required BuildContext context,
    required bool isSmallScreen,
  }) {
    // Responsive sizing
    final iconSize = isSmallScreen ? 12.0 : 14.0;
    final iconPadding = isSmallScreen ? 4.0 : 5.0;
    final labelWidth = isSmallScreen ? 60.0 : 70.0;
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(iconPadding),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            size: iconSize,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(width: 6), // Less horizontal space
        SizedBox(
          width: labelWidth,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: isSmallScreen ? 11 : 12, // Responsive text size
            ),
          ),
        ),
        const Spacer(), // Push value to the right
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.bold,
            fontSize: isSmallScreen ? 12 : 13, // Responsive text size
          ),
          textAlign: TextAlign.right, // Right align text
        ),
        const SizedBox(width: 4), // Add some padding on the right
      ],
    );
  }
  
  /// Build a card for a day of the week
  Widget _buildDayCard(
    BuildContext context,
    WidgetRef ref,
    int weekday,
    RoutineRecord routine,
    bool isToday,
    bool isCompleted,
    bool viewingPreviousWeek,
  ) {
    final date = DateTime.now().subtract(Duration(days: DateTime.now().weekday - weekday));
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    
    // Determine if user can toggle completion (only today's workout in current week)
    final bool canToggleCompletion = isToday && !viewingPreviousWeek;
    
    // Check if this day is in the future
    final bool isFutureDay = weekday > DateTime.now().weekday;
    
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final String availableAt = DateFormat('EEEE').format(
      DateTime(tomorrow.year, tomorrow.month, tomorrow.day)
    );
    
    // If in previous week mode, show simplified card
    if (viewingPreviousWeek) {
      return Card(
        margin: const EdgeInsets.fromLTRB(12, 4, 12, 4), // Less margin
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10), // Less padding
          child: Row(
            children: [
              // Day info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          _getDayName(weekday),
                          style: Theme.of(context).textTheme.titleSmall?.copyWith( // Smaller text
                            fontWeight: FontWeight.bold,
                            fontSize: isSmallScreen ? 13 : 14,
                          ),
                        ),
                        const SizedBox(width: 6), // Less spacing
                        Text(
                          DateFormat('MMM d').format(date),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith( // Smaller text
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: isSmallScreen ? 11 : 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2), // Less spacing
                    Text(
                      routine.name,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith( // Smaller text
                        fontSize: isSmallScreen ? 11 : 12,
                      ),
                    ),
                  ],
                ),
              ),
              // Completion status - animated
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(4), // Less padding
                decoration: BoxDecoration(
                  color: isCompleted 
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                  boxShadow: isCompleted ? [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primary.withAlpha(51),
                      blurRadius: 4,
                      spreadRadius: 0.5,
                    ),
                  ] : null,
                ),
                child: Icon(
                  isCompleted ? Icons.check : Icons.close,
                  color: isCompleted
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 16, // Smaller icon
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    // Regular card for current week - with lighter animations
    return Card(
      margin: EdgeInsets.fromLTRB(
        12,
        isToday ? 2 : 4, // Slightly less space for today's card
        12, 
        isToday ? 4 : 4
      ),
      elevation: isToday ? 2 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Smaller radius
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day header with improved visual hierarchy
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12, // Less padding
              vertical: isSmallScreen ? 8 : 10, // Less padding on small screens
            ),
            decoration: BoxDecoration(
              color: isToday 
                ? Theme.of(context).colorScheme.primaryContainer.withAlpha(76)
                : null,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                // Day name with improved typography
                Text(
                  _getDayName(weekday),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isToday 
                        ? Theme.of(context).colorScheme.primary
                        : null,
                    fontSize: isSmallScreen ? 14 : 16, // Smaller on small screens
                  ),
                ),
                const SizedBox(width: 8), // Less spacing
                if (isToday)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8, // Less padding
                      vertical: 3, // Less padding
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(10), // Smaller radius
                    ),
                    child: Text(
                      'TODAY',
                      style: TextStyle(
                        fontSize: 10, // Smaller text
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                const Spacer(),
                Text(
                  DateFormat('MMM d').format(date),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                    fontSize: isSmallScreen ? 11 : 12, // Smaller on small screens
                  ),
                ),
              ],
            ),
          ),
          
          // Regular routine card (no hero animations)
          GFRoutineCard(
            routine: routine,
            isCompleted: isCompleted,
            onToggleCompletion: canToggleCompletion ? (completed) {
              ref.read(gFProgramProvider.notifier).toggleDayCompletion(weekday);
            } : null,
          ),
          
          // Show "Available tomorrow" message for future days - more compact
          if (isFutureDay && !viewingPreviousWeek)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Less padding
              child: Row(
                children: [
                  Icon(
                    Icons.access_time_outlined,
                    size: 14, // Smaller icon
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(width: 8), // Less spacing
                  Expanded(
                    child: Text(
                      'Available on $availableAt',
                      style: TextStyle(
                        fontSize: 12, // Smaller text
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
  
  /// Show information dialog about the program
  void _showInfoDialog(BuildContext context) {
    final dialogWidth = MediaQuery.of(context).size.width * 0.9;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'About GF Program',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
        content: Container(
          width: dialogWidth,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'The GF (Graduated Fitness) Program is a 6-day workout plan with Sunday as a rest day, designed to build strength and endurance through bodyweight exercises. The program incorporates a balanced approach to fitness with full-body workouts, cardio sessions, and dedicated recovery days.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              const Text(
                'Key Features:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _buildInfoPoint('Balance of strength, cardio, and recovery', isWorkoutDay: null),
              _buildInfoPoint('Progressive workouts with bodyweight exercises', isWorkoutDay: null),
              _buildInfoPoint('Dedicated rest day for proper recovery', isWorkoutDay: null),
              _buildInfoPoint('Track your completed workouts with progress metrics', isWorkoutDay: null),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Got it',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
  
  /// Build an information point with bullet
  Widget _buildInfoPoint(String text, {bool? isWorkoutDay}) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isWorkoutDay == null
              ? const Text('• ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))
              : Icon(
                  isWorkoutDay ? Icons.fitness_center : Icons.hotel_rounded,
                  size: 14,
                  color: Theme.of(context).colorScheme.primary,
                ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
  
  /// Get day name from weekday index
  String _getDayName(int weekday) {
    switch (weekday) {
      case 1: return 'Monday';
      case 2: return 'Tuesday';
      case 3: return 'Wednesday';
      case 4: return 'Thursday';
      case 5: return 'Friday';
      case 6: return 'Saturday';
      case 7: return 'Sunday';
      default: return '';
    }
  }
  
  /// Helper function to check if two dates are the same day
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
} 