import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../models/hive/exercise_record.dart';
import '../models/hive/gf_program_record.dart';
import '../models/hive/routine_record.dart';
import '../models/hive/workout_record.dart';
import '../models/enum/muscle_group.dart';

/// Class to initialize app components
class AppInit {
  static bool _isInitialized = false;
  
  /// Initialize Hive and register adapters
  static Future<void> initialize() async {
    try {
      if (_isInitialized) {
        debugPrint('🔥 Hive already initialized, skipping...');
        return;
      }
      
      debugPrint('🔄 Initializing Hive and registering adapters...');
      WidgetsFlutterBinding.ensureInitialized();
      
      // Initialize Hive
      final appDocDir = await getApplicationDocumentsDirectory();
      debugPrint('📁 App directory: ${appDocDir.path}');
      await Hive.initFlutter(appDocDir.path);
      
      // Register adapters
      _registerAdapters();
      
      // Open boxes with retry logic
      await _openBoxes();
      
      _isInitialized = true;
      debugPrint('✅ Hive initialization complete!');
    } catch (e, stack) {
      debugPrint('❌ Error initializing Hive: $e');
      debugPrint(stack.toString());
      // Re-throw to make the error visible in the UI
      rethrow;
    }
  }
  
  /// Register all Hive adapters
  static void _registerAdapters() {
    try {
      if (!Hive.isAdapterRegistered(0)) {
        debugPrint('📦 Registering MuscleGroupAdapter (0)');
        Hive.registerAdapter(MuscleGroupAdapter());
      }
      
      if (!Hive.isAdapterRegistered(1)) {
        debugPrint('📦 Registering ExerciseRecordAdapter (1)');
        Hive.registerAdapter(ExerciseRecordAdapter());
      }
      
      if (!Hive.isAdapterRegistered(2)) {
        debugPrint('📦 Registering WorkoutRecordAdapter (2)');
        Hive.registerAdapter(WorkoutRecordAdapter());
      }
      
      if (!Hive.isAdapterRegistered(3)) {
        debugPrint('📦 Registering RoutineRecordAdapter (3)');
        Hive.registerAdapter(RoutineRecordAdapter());
      }
      
      if (!Hive.isAdapterRegistered(4)) {
        debugPrint('📦 Registering GFProgramRecordAdapter (4)');
        Hive.registerAdapter(GFProgramRecordAdapter());
      }
    } catch (e) {
      debugPrint('❌ Error registering adapters: $e');
      rethrow;
    }
  }
  
  /// Open Hive boxes with retry logic
  static Future<void> _openBoxes() async {
    const maxRetries = 3;
    
    // Open workout records box
    for (int i = 0; i < maxRetries; i++) {
      try {
        debugPrint('📂 Opening workouts box (attempt ${i+1})');
        if (!Hive.isBoxOpen('workouts')) {
          await Hive.openBox<WorkoutRecord>('workouts');
        }
        debugPrint('✅ Workouts box opened successfully');
        break;
      } catch (e) {
        debugPrint('❌ Error opening workouts box: $e');
        if (i == maxRetries - 1) rethrow;
        await Future.delayed(Duration(milliseconds: 500 * (i + 1)));
      }
    }
    
    // Open GF program box
    for (int i = 0; i < maxRetries; i++) {
      try {
        debugPrint('📂 Opening gf_program box (attempt ${i+1})');
        if (!Hive.isBoxOpen('gf_program')) {
          await Hive.openBox<GFProgramRecord>('gf_program');
        }
        debugPrint('✅ GF Program box opened successfully');
        break;
      } catch (e) {
        debugPrint('❌ Error opening gf_program box: $e');
        if (i == maxRetries - 1) rethrow;
        await Future.delayed(Duration(milliseconds: 500 * (i + 1)));
      }
    }
  }
  
  /// Check if boxes are initialized and open
  static bool areBoxesOpen() {
    final workoutsOpen = Hive.isBoxOpen('workouts');
    final gfProgramOpen = Hive.isBoxOpen('gf_program');
    
    debugPrint('📊 Box status - workouts: ${workoutsOpen ? '✅' : '❌'}, gf_program: ${gfProgramOpen ? '✅' : '❌'}');
    
    return workoutsOpen && gfProgramOpen;
  }
  
  /// Close Hive boxes
  static Future<void> dispose() async {
    try {
      debugPrint('🔄 Closing Hive boxes');
      await Hive.close();
      _isInitialized = false;
      debugPrint('✅ Hive boxes closed successfully');
    } catch (e) {
      debugPrint('❌ Error closing Hive boxes: $e');
    }
  }
} 