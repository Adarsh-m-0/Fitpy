class BodyweightExercise {
  final String name;
  final int sets;
  final int reps;
  final String? demoLottie;
  final int? duration; // In seconds, for timed exercises (e.g. planks)
  final String? notes; // Optional notes for the exercise
  
  BodyweightExercise({
    required this.name,
    required this.sets,
    required this.reps,
    this.demoLottie,
    this.duration,
    this.notes,
  });
  
  BodyweightExercise copyWith({
    String? name,
    int? sets,
    int? reps,
    String? demoLottie,
    int? duration,
    String? notes,
  }) {
    return BodyweightExercise(
      name: name ?? this.name,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      demoLottie: demoLottie ?? this.demoLottie,
      duration: duration ?? this.duration,
      notes: notes ?? this.notes,
    );
  }
  
  // Convert to map for database storage
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'sets': sets,
      'reps': reps,
      'demoLottie': demoLottie,
      'duration': duration,
      'notes': notes,
    };
  }
  
  // Create from map for database retrieval
  factory BodyweightExercise.fromMap(Map<String, dynamic> map) {
    return BodyweightExercise(
      name: map['name'],
      sets: map['sets'],
      reps: map['reps'],
      demoLottie: map['demoLottie'],
      duration: map['duration'],
      notes: map['notes'],
    );
  }
} 