// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$selectedDateWorkoutHash() =>
    r'2b3394f83c96845af0cd2fc40d2d960ec63189f5';

/// Provides workout for the selected date
///
/// Copied from [selectedDateWorkout].
@ProviderFor(selectedDateWorkout)
final selectedDateWorkoutProvider =
    AutoDisposeFutureProvider<WorkoutRecord?>.internal(
  selectedDateWorkout,
  name: r'selectedDateWorkoutProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedDateWorkoutHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SelectedDateWorkoutRef = AutoDisposeFutureProviderRef<WorkoutRecord?>;
String _$monthlyWorkoutStatsHash() =>
    r'143882ed6ede895bbedb0a10b2d89efa245f12b0';

/// Provides monthly workout statistics
///
/// Copied from [monthlyWorkoutStats].
@ProviderFor(monthlyWorkoutStats)
final monthlyWorkoutStatsProvider =
    AutoDisposeFutureProvider<Map<DateTime, int>>.internal(
  monthlyWorkoutStats,
  name: r'monthlyWorkoutStatsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$monthlyWorkoutStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MonthlyWorkoutStatsRef
    = AutoDisposeFutureProviderRef<Map<DateTime, int>>;
String _$muscleGroupStatsHash() => r'1ce84bf77b7516519cb9f8e62373761017ac5c08';

/// Provides statistics on muscle groups trained
///
/// Copied from [muscleGroupStats].
@ProviderFor(muscleGroupStats)
final muscleGroupStatsProvider =
    AutoDisposeFutureProvider<Map<MuscleGroup, int>>.internal(
  muscleGroupStats,
  name: r'muscleGroupStatsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$muscleGroupStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MuscleGroupStatsRef
    = AutoDisposeFutureProviderRef<Map<MuscleGroup, int>>;
String _$workoutRecordsHash() => r'bd4c17e1c89f63229126232a6aa8da7323e99a33';

/// Provides access to workout records stored in Hive
///
/// Copied from [WorkoutRecords].
@ProviderFor(WorkoutRecords)
final workoutRecordsProvider = AutoDisposeAsyncNotifierProvider<WorkoutRecords,
    List<WorkoutRecord>>.internal(
  WorkoutRecords.new,
  name: r'workoutRecordsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$workoutRecordsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$WorkoutRecords = AutoDisposeAsyncNotifier<List<WorkoutRecord>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
