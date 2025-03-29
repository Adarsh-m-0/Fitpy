import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';

import '../models/enum/muscle_group.dart';
import '../models/hive/exercise_record.dart';
import '../models/hive/workout_record.dart';
import '../providers/workout_provider.dart';

class WorkoutFormDialog extends ConsumerStatefulWidget {
  final DateTime selectedDate;
  final WorkoutRecord? existingWorkout;
  
  const WorkoutFormDialog({
    Key? key,
    required this.selectedDate,
    this.existingWorkout,
  }) : super(key: key);
  
  @override
  ConsumerState<WorkoutFormDialog> createState() => _WorkoutFormDialogState();
}

class _WorkoutFormDialogState extends ConsumerState<WorkoutFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _notesController;
  late final List<MuscleGroup> _selectedMuscleGroups;
  late final bool _isEditing;
  bool _isSaving = false;
  
  @override
  void initState() {
    super.initState();
    _isEditing = widget.existingWorkout != null;
    _selectedMuscleGroups = _isEditing 
        ? List<MuscleGroup>.from(widget.existingWorkout!.muscleGroups)
        : [];
    _notesController = TextEditingController(
      text: _isEditing ? widget.existingWorkout!.notes ?? '' : '',
    );
  }
  
  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      elevation: 2,
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
          maxWidth: 500,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date display (read only)
                      _buildDateSection(),
                      const SizedBox(height: 16),
                      
                      // Muscle group selection
                      _buildMuscleGroupSection(),
                      const SizedBox(height: 16),
                      
                      // Notes
                      _buildNotesSection(),
                    ],
                  ),
                ),
              ),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _isEditing ? 'Edit Workout' : 'Log Workout',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, size: 20),
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
  
  Widget _buildDateSection() {
    final dateStr = DateFormat('EEEE, MMMM d, y').format(widget.selectedDate);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: Theme.of(context).colorScheme.primary,
                size: 18,
              ),
              const SizedBox(width: 12),
              Text(
                dateStr,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildMuscleGroupSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Muscle Groups',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(' *', style: TextStyle(color: Colors.red)),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          'Select at least one muscle group worked',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: MuscleGroup.values.map((group) {
            final isSelected = _selectedMuscleGroups.contains(group);
            
            return FilterChip(
              label: Text(
                group.displayName,
                style: TextStyle(
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimaryContainer
                      : null,
                ),
              ),
              selected: isSelected,
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              selectedColor: Theme.of(context).colorScheme.primaryContainer,
              checkmarkColor: Theme.of(context).colorScheme.onPrimaryContainer,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedMuscleGroups.add(group);
                  } else {
                    _selectedMuscleGroups.remove(group);
                  }
                });
              },
            );
          }).toList(),
        ),
        if (_selectedMuscleGroups.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'Please select at least one muscle group',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
  
  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notes',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _notesController,
          decoration: InputDecoration(
            hintText: 'Add any notes about this workout',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          maxLines: 3,
        ),
      ],
    );
  }
  
  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withAlpha(51),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            child: const Text('Cancel'),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: _isSaving ? null : _validateAndSave,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            child: _isSaving
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  )
                : Text(_isEditing ? 'Update' : 'Save'),
          ),
        ],
      ),
    );
  }
  
  Future<void> _validateAndSave() async {
    // Basic validation
    if (_selectedMuscleGroups.isEmpty) {
      _showValidationError('Please select at least one muscle group');
      return;
    }
    
    // Set saving state
    setState(() {
      _isSaving = true;
    });
    
    try {
      debugPrint('💾 Creating workout record...');
      final notesText = _notesController.text.isNotEmpty ? _notesController.text : null;
      
      // Create workout record with default values for duration and exercises
      final workout = WorkoutRecord(
        id: _isEditing ? widget.existingWorkout!.id : const Uuid().v4(),
        date: widget.selectedDate,
        muscleGroups: _selectedMuscleGroups,
        duration: 30, // Set a default duration
        exercises: [], // Empty exercises list
        notes: notesText,
      );
      
      debugPrint('💾 Generated workout ID: ${workout.id}');
      debugPrint('💾 Selected date: ${workout.date}');
      debugPrint('💾 Selected muscle groups: ${workout.muscleGroups.map((g) => g.displayName).join(', ')}');
      
      // Verify Hive box is open
      final isBoxOpen = Hive.isBoxOpen('workouts');
      debugPrint('💾 Is workouts box open? $isBoxOpen');
      
      if (!isBoxOpen) {
        debugPrint('🔄 Attempting to open workouts box...');
        await Hive.openBox<WorkoutRecord>('workouts');
        debugPrint('✅ Workouts box opened successfully');
      }
      
      // Save using provider
      if (_isEditing) {
        debugPrint('✏️ Updating existing workout...');
        await ref.read(workoutRecordsProvider.notifier).updateWorkout(workout);
        _showSuccessMessage('Workout updated successfully');
      } else {
        debugPrint('➕ Adding new workout...');
        await ref.read(workoutRecordsProvider.notifier).addWorkout(workout);
        _showSuccessMessage('Workout saved successfully');
      }
      
      // Force refresh monthly stats to show new dot immediately
      debugPrint('🔄 Refreshing monthly stats...');
      ref.invalidate(monthlyWorkoutStatsProvider);
      
      // Small delay to show the success message
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Close dialog
      if (mounted) {
        debugPrint('✅ Save complete, closing dialog');
        Navigator.of(context).pop(true);
      }
    } catch (e, stack) {
      debugPrint('❌ Error saving workout: $e');
      debugPrint(stack.toString());
      
      // Reset saving state
      setState(() {
        _isSaving = false;
      });
      
      _showValidationError('Error saving workout: $e');
    }
  }
  
  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }
  
  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

// Dialog for adding/editing exercises
class ExerciseFormDialog extends StatefulWidget {
  final ExerciseRecord? existingExercise;
  final MuscleGroup? initialMuscleGroup;
  final Function(ExerciseRecord) onSave;
  
  const ExerciseFormDialog({
    Key? key,
    this.existingExercise,
    this.initialMuscleGroup,
    required this.onSave,
  }) : super(key: key);
  
  @override
  State<ExerciseFormDialog> createState() => _ExerciseFormDialogState();
}

class _ExerciseFormDialogState extends State<ExerciseFormDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _setsController;
  late final TextEditingController _repsController;
  late final TextEditingController _notesController;
  late MuscleGroup _selectedMuscleGroup;
  late final bool _isEditing;
  
  @override
  void initState() {
    super.initState();
    _isEditing = widget.existingExercise != null;
    
    _nameController = TextEditingController(
      text: _isEditing ? widget.existingExercise!.name : '',
    );
    _setsController = TextEditingController(
      text: _isEditing ? widget.existingExercise!.sets.toString() : '3',
    );
    _repsController = TextEditingController(
      text: _isEditing ? widget.existingExercise!.reps.toString() : '10',
    );
    _notesController = TextEditingController(
      text: _isEditing ? widget.existingExercise!.notes ?? '' : '',
    );
    
    _selectedMuscleGroup = _isEditing 
        ? widget.existingExercise!.muscleGroup
        : widget.initialMuscleGroup ?? MuscleGroup.chest;
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _setsController.dispose();
    _repsController.dispose();
    _notesController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEditing ? 'Edit Exercise' : 'Add Exercise',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            
            // Exercise name
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Exercise Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            
            // Muscle group dropdown
            DropdownButtonFormField<MuscleGroup>(
              value: _selectedMuscleGroup,
              decoration: InputDecoration(
                labelText: 'Muscle Group',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: MuscleGroup.values.map((group) {
                return DropdownMenuItem(
                  value: group,
                  child: Text(group.displayName),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedMuscleGroup = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            
            // Sets and reps
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _setsController,
                    decoration: InputDecoration(
                      labelText: 'Sets',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _repsController,
                    decoration: InputDecoration(
                      labelText: 'Reps',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Notes
            TextField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: 'Notes (optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _validateAndSave,
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  void _validateAndSave() {
    // Basic validation
    if (_nameController.text.isEmpty) {
      _showValidationError('Please enter exercise name');
      return;
    }
    
    try {
      final sets = int.parse(_setsController.text);
      final reps = int.parse(_repsController.text);
      final notesText = _notesController.text.isNotEmpty ? _notesController.text : null;
      
      if (sets <= 0 || reps <= 0) {
        _showValidationError('Sets and reps must be greater than 0');
        return;
      }
      
      // Create exercise record
      final exercise = ExerciseRecord(
        id: _isEditing ? widget.existingExercise!.id : const Uuid().v4(),
        name: _nameController.text,
        sets: sets,
        reps: reps,
        muscleGroup: _selectedMuscleGroup,
        notes: notesText,
      );
      
      // Call the save callback
      widget.onSave(exercise);
      
      // Close dialog
      Navigator.of(context).pop();
    } catch (e) {
      _showValidationError('Invalid sets or reps. Please enter valid numbers.');
    }
  }
  
  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
} 