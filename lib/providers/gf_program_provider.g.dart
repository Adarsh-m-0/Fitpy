// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gf_program_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dayRoutineHash() => r'd779ea97e5a26322f7a526cb7fe2dd43ddc26fb1';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Provider for a specific day's routine
///
/// Copied from [dayRoutine].
@ProviderFor(dayRoutine)
const dayRoutineProvider = DayRoutineFamily();

/// Provider for a specific day's routine
///
/// Copied from [dayRoutine].
class DayRoutineFamily extends Family<AsyncValue<RoutineRecord?>> {
  /// Provider for a specific day's routine
  ///
  /// Copied from [dayRoutine].
  const DayRoutineFamily();

  /// Provider for a specific day's routine
  ///
  /// Copied from [dayRoutine].
  DayRoutineProvider call(
    int day,
  ) {
    return DayRoutineProvider(
      day,
    );
  }

  @override
  DayRoutineProvider getProviderOverride(
    covariant DayRoutineProvider provider,
  ) {
    return call(
      provider.day,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'dayRoutineProvider';
}

/// Provider for a specific day's routine
///
/// Copied from [dayRoutine].
class DayRoutineProvider extends AutoDisposeFutureProvider<RoutineRecord?> {
  /// Provider for a specific day's routine
  ///
  /// Copied from [dayRoutine].
  DayRoutineProvider(
    int day,
  ) : this._internal(
          (ref) => dayRoutine(
            ref as DayRoutineRef,
            day,
          ),
          from: dayRoutineProvider,
          name: r'dayRoutineProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$dayRoutineHash,
          dependencies: DayRoutineFamily._dependencies,
          allTransitiveDependencies:
              DayRoutineFamily._allTransitiveDependencies,
          day: day,
        );

  DayRoutineProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.day,
  }) : super.internal();

  final int day;

  @override
  Override overrideWith(
    FutureOr<RoutineRecord?> Function(DayRoutineRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DayRoutineProvider._internal(
        (ref) => create(ref as DayRoutineRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        day: day,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<RoutineRecord?> createElement() {
    return _DayRoutineProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DayRoutineProvider && other.day == day;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, day.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DayRoutineRef on AutoDisposeFutureProviderRef<RoutineRecord?> {
  /// The parameter `day` of this provider.
  int get day;
}

class _DayRoutineProviderElement
    extends AutoDisposeFutureProviderElement<RoutineRecord?>
    with DayRoutineRef {
  _DayRoutineProviderElement(super.provider);

  @override
  int get day => (origin as DayRoutineProvider).day;
}

String _$isDayCompletedHash() => r'c3b84a111266ccfecb551c811ac2974ea636cdd0';

/// Provider to check if a day is completed
///
/// Copied from [isDayCompleted].
@ProviderFor(isDayCompleted)
const isDayCompletedProvider = IsDayCompletedFamily();

/// Provider to check if a day is completed
///
/// Copied from [isDayCompleted].
class IsDayCompletedFamily extends Family<AsyncValue<bool>> {
  /// Provider to check if a day is completed
  ///
  /// Copied from [isDayCompleted].
  const IsDayCompletedFamily();

  /// Provider to check if a day is completed
  ///
  /// Copied from [isDayCompleted].
  IsDayCompletedProvider call(
    int day,
  ) {
    return IsDayCompletedProvider(
      day,
    );
  }

  @override
  IsDayCompletedProvider getProviderOverride(
    covariant IsDayCompletedProvider provider,
  ) {
    return call(
      provider.day,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'isDayCompletedProvider';
}

/// Provider to check if a day is completed
///
/// Copied from [isDayCompleted].
class IsDayCompletedProvider extends AutoDisposeFutureProvider<bool> {
  /// Provider to check if a day is completed
  ///
  /// Copied from [isDayCompleted].
  IsDayCompletedProvider(
    int day,
  ) : this._internal(
          (ref) => isDayCompleted(
            ref as IsDayCompletedRef,
            day,
          ),
          from: isDayCompletedProvider,
          name: r'isDayCompletedProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$isDayCompletedHash,
          dependencies: IsDayCompletedFamily._dependencies,
          allTransitiveDependencies:
              IsDayCompletedFamily._allTransitiveDependencies,
          day: day,
        );

  IsDayCompletedProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.day,
  }) : super.internal();

  final int day;

  @override
  Override overrideWith(
    FutureOr<bool> Function(IsDayCompletedRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IsDayCompletedProvider._internal(
        (ref) => create(ref as IsDayCompletedRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        day: day,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _IsDayCompletedProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IsDayCompletedProvider && other.day == day;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, day.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin IsDayCompletedRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `day` of this provider.
  int get day;
}

class _IsDayCompletedProviderElement
    extends AutoDisposeFutureProviderElement<bool> with IsDayCompletedRef {
  _IsDayCompletedProviderElement(super.provider);

  @override
  int get day => (origin as IsDayCompletedProvider).day;
}

String _$weekProgressHash() => r'64f54e3552be2d651804d4751f3fcdb4fd44e11e';

/// Provider for week progress percentage
///
/// Copied from [weekProgress].
@ProviderFor(weekProgress)
final weekProgressProvider = AutoDisposeFutureProvider<double>.internal(
  weekProgress,
  name: r'weekProgressProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$weekProgressHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WeekProgressRef = AutoDisposeFutureProviderRef<double>;
String _$currentWeekHash() => r'a265b7d859917c1c3bd180693b10f52ce6662dde';

/// Provider for current week number
///
/// Copied from [currentWeek].
@ProviderFor(currentWeek)
final currentWeekProvider = AutoDisposeFutureProvider<int>.internal(
  currentWeek,
  name: r'currentWeekProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$currentWeekHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentWeekRef = AutoDisposeFutureProviderRef<int>;
String _$gFProgramHash() => r'8c3a409d96f2fa56b23e15fb70d5adb66f2ff431';

/// Provider for the GF Program
///
/// Copied from [GFProgram].
@ProviderFor(GFProgram)
final gFProgramProvider =
    AutoDisposeAsyncNotifierProvider<GFProgram, GFProgramRecord>.internal(
  GFProgram.new,
  name: r'gFProgramProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$gFProgramHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GFProgram = AutoDisposeAsyncNotifier<GFProgramRecord>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
