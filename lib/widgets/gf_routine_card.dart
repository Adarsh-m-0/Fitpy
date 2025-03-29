import 'package:flutter/material.dart';
import '../models/hive/routine_record.dart';
import '../models/hive/exercise_record.dart';

class GFRoutineCard extends StatelessWidget {
  final RoutineRecord? routine;
  final bool isCompleted;
  final Function(bool)? onToggleCompletion;

  const GFRoutineCard({
    Key? key,
    required this.routine,
    required this.isCompleted,
    this.onToggleCompletion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (routine == null) {
      return _buildRestDayCard(context);
    }

    final bool isInteractive = onToggleCompletion != null;
    // Get screen width to adjust UI based on available space
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isCompleted 
            ? Theme.of(context).colorScheme.primaryContainer.withAlpha(38)
            : Colors.transparent,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 10 : 14, 
          vertical: 6
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with name and completion checkbox
            Row(
              children: [
                Expanded(
                  child: Text(
                    routine!.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: isSmallScreen ? 16 : 18,
                        ),
                  ),
                ),
                // Duration pill - more compact
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 8 : 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        size: isSmallScreen ? 14 : 16,
                        color: Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                      SizedBox(width: isSmallScreen ? 4 : 6),
                      Text(
                        '${routine!.estimatedDuration} min',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 12 : 13,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Completion checkbox - more compact
                _buildCompletionCheckbox(context, isSmallScreen),
              ],
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 1,
              margin: const EdgeInsets.symmetric(vertical: 12),
              color: isCompleted 
                  ? Theme.of(context).colorScheme.primary.withAlpha(51)
                  : Theme.of(context).colorScheme.outlineVariant.withAlpha(128),
            ),
            
            // Simple list of exercises
            ...routine!.exercises.map((exercise) => 
              _buildExerciseItem(exercise, context, isSmallScreen)
            ),
            
            // Call to action with animation
            if (isInteractive) ...[
              const SizedBox(height: 10),
              Center(
                child: TextButton.icon(
                  onPressed: () => onToggleCompletion!(!isCompleted),
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: Icon(
                      isCompleted ? Icons.close_rounded : Icons.check_circle_outline_rounded,
                      key: ValueKey<bool>(isCompleted),
                      size: isSmallScreen ? 20 : 22,
                    ),
                  ),
                  label: Text(
                    isCompleted ? 'Mark as Incomplete' : 'Mark as Completed',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: isCompleted
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.primary,
                    padding: EdgeInsets.symmetric(
                      vertical: isSmallScreen ? 8 : 10,
                      horizontal: isSmallScreen ? 12 : 14,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCompletionCheckbox(BuildContext context, bool isSmallScreen) {
    final size = isSmallScreen ? 28.0 : 32.0;
    final iconSize = isSmallScreen ? 18.0 : 20.0;
    final borderWidth = isSmallScreen ? 2.0 : 2.5;
    
    return GestureDetector(
      onTap: onToggleCompletion != null ? () => onToggleCompletion!(!isCompleted) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isCompleted
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          border: Border.all(
            color: isCompleted
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
            width: borderWidth,
          ),
          boxShadow: isCompleted ? [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withAlpha(51),
              blurRadius: 4,
              spreadRadius: 0.5,
            )
          ] : null,
        ),
        child: isCompleted
            ? Icon(
                Icons.check_rounded,
                size: iconSize,
                color: Theme.of(context).colorScheme.onPrimary,
              )
            : null,
      ),
    );
  }

  Widget _buildExerciseItem(ExerciseRecord exercise, BuildContext context, bool isSmallScreen) {
    // Responsive sizing
    final iconContainerSize = isSmallScreen ? 34.0 : 40.0;
    final iconSize = isSmallScreen ? 16.0 : 20.0;
    final itemPadding = isSmallScreen ? 12.0 : 16.0;
    final bottomMargin = isSmallScreen ? 10.0 : 14.0;
    
    return Card(
      margin: EdgeInsets.only(bottom: bottomMargin),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(itemPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: iconContainerSize,
              height: iconContainerSize,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                exercise.muscleGroup.icon,
                size: iconSize,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            SizedBox(width: isSmallScreen ? 12 : 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isSmallScreen ? 14 : 16,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 4 : 6),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 8 : 10,
                      vertical: isSmallScreen ? 3 : 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiaryContainer.withAlpha(128),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${exercise.sets} sets × ${exercise.reps} reps',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 12 : 14,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onTertiaryContainer,
                      ),
                    ),
                  ),
                  if (exercise.notes != null && exercise.notes!.isNotEmpty) ...[
                    SizedBox(height: isSmallScreen ? 8 : 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.notes_outlined,
                          size: isSmallScreen ? 16 : 18,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        SizedBox(width: isSmallScreen ? 6 : 8),
                        Expanded(
                          child: Text(
                            exercise.notes!,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 12 : 14,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestDayCard(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    
    return Card(
      margin: EdgeInsets.symmetric(horizontal: isSmallScreen ? 10 : 16, vertical: 6),
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 16.0 : 20.0),
        child: Row(
          children: [
            Container(
              width: isSmallScreen ? 34 : 40,
              height: isSmallScreen ? 34 : 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.hotel_rounded,
                size: isSmallScreen ? 18 : 22,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            SizedBox(width: isSmallScreen ? 12 : 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rest Day',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isSmallScreen ? 15 : 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Take time to recover and recharge.',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 13 : 14,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 