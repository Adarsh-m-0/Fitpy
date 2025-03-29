import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'date_provider.g.dart';

/// Provider for the currently selected date in the calendar
@riverpod
class SelectedDate extends _$SelectedDate {
  @override
  DateTime build() {
    // Start with today as the default selected date
    return DateTime.now();
  }

  /// Select a specific date
  void updateSelectedDate(DateTime date) {
    state = date;
  }

  /// Go to the previous day
  void previousDay() {
    state = DateTime(state.year, state.month, state.day - 1);
  }

  /// Go to the next day
  void nextDay() {
    state = DateTime(state.year, state.month, state.day + 1);
  }

  /// Reset to today's date
  void resetToToday() {
    state = DateTime.now();
  }
}

/// Provider for the currently focused date in the calendar
@riverpod
class FocusedDate extends _$FocusedDate {
  @override
  DateTime build() {
    // Start with today as the default focused date
    return DateTime.now();
  }

  /// Update the focused date
  void updateFocusedDate(DateTime date) {
    state = date;
  }
} 