import 'package:intl/intl.dart';

class WeightEntry {
  final int? id;
  final double weight;
  final DateTime date;
  final String? notes;
  
  WeightEntry({
    this.id,
    required this.weight,
    required this.date,
    this.notes,
  });
  
  WeightEntry copyWith({
    int? id,
    double? weight,
    DateTime? date,
    String? notes,
  }) {
    return WeightEntry(
      id: id ?? this.id,
      weight: weight ?? this.weight,
      date: date ?? this.date,
      notes: notes ?? this.notes,
    );
  }
  
  // Convert to map for database storage
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'weight': weight,
      'date': DateFormat('yyyy-MM-dd').format(date),
      'notes': notes,
    };
  }
  
  // Create from map for database retrieval
  factory WeightEntry.fromMap(Map<String, dynamic> map) {
    return WeightEntry(
      id: map['id'],
      weight: map['weight'],
      date: DateFormat('yyyy-MM-dd').parse(map['date']),
      notes: map['notes'],
    );
  }
} 