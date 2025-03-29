// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'date_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$selectedDateHash() => r'6e717c8f58cbae43c28b346e2ce4aebd70393540';

/// Provider for the currently selected date in the calendar
///
/// Copied from [SelectedDate].
@ProviderFor(SelectedDate)
final selectedDateProvider =
    AutoDisposeNotifierProvider<SelectedDate, DateTime>.internal(
  SelectedDate.new,
  name: r'selectedDateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$selectedDateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedDate = AutoDisposeNotifier<DateTime>;
String _$focusedDateHash() => r'3274236c6ea06f02ecdb4eb255126f9afe9f4278';

/// Provider for the currently focused date in the calendar
///
/// Copied from [FocusedDate].
@ProviderFor(FocusedDate)
final focusedDateProvider =
    AutoDisposeNotifierProvider<FocusedDate, DateTime>.internal(
  FocusedDate.new,
  name: r'focusedDateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$focusedDateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FocusedDate = AutoDisposeNotifier<DateTime>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
