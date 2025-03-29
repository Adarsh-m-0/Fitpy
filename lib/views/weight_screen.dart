import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// Enhanced weight entry model with height, age, gender, and BMI
class WeightEntry {
  final DateTime date;
  final double weight;
  final double? height; // in cm
  final int? age;
  final String? gender; // "male" or "female"
  final double? bmi;
  
  WeightEntry({
    required this.date,
    required this.weight,
    this.height,
    this.age,
    this.gender,
    this.bmi,
  });
  
  // BMI calculation method with age and gender consideration
  static double calculateBMI(double weightKg, double heightCm, {int? age, String? gender}) {
    // Standard BMI = weight(kg) / height(m)²
    final heightM = heightCm / 100;
    final standardBMI = weightKg / (heightM * heightM);
    
    // For basic calculation, we'll just return the standard BMI
    // In a real app, you might adjust based on age/gender with more complex formulas
    return standardBMI;
  }
  
  // Get BMI status based on gender and age
  static String getBMIStatus(double bmi, {String? gender, int? age}) {
    // Basic BMI categories
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi < 25) {
      return 'Healthy';
    } else if (bmi < 30) {
      return 'Overweight';
    } else {
      return 'Obese';
    }
    
    // Note: In a real app, you would have different thresholds based on age and gender
  }
  
  // Get BMI color
  static Color getBMIColor(double bmi, BuildContext context) {
    if (bmi < 18.5) {
      return Colors.blue;
    } else if (bmi < 25) {
      return Colors.green;
    } else if (bmi < 30) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}

// Provider for user's height
final userHeightProvider = StateProvider<double?>((ref) => null);

// Provider for user's age
final userAgeProvider = StateProvider<int?>((ref) => null);

// Provider for user's gender
final userGenderProvider = StateProvider<String?>((ref) => null);

// Provider for weight entries - starting with empty list
final weightEntriesProvider = StateProvider<List<WeightEntry>>((ref) => []);

class WeightScreen extends ConsumerStatefulWidget {
  const WeightScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends ConsumerState<WeightScreen> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  bool _calculateBMI = false;
  String? _selectedGender;
  
  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final weightEntries = ref.watch(weightEntriesProvider);
    final userHeight = ref.watch(userHeightProvider);
    
    // Get screen width to adjust UI
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Weight Tracker',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(context),
            tooltip: 'Information',
          ),
        ],
      ),
      body: weightEntries.isEmpty 
          ? _buildEmptyState(context)
          : Column(
              children: [
                // Weight summary card
                _buildWeightSummaryCard(context, weightEntries, userHeight, isSmallScreen),
                
                // History section
                Expanded(
                  child: _buildWeightHistoryList(context, weightEntries, isSmallScreen),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddWeightDialog(context),
        backgroundColor: Theme.of(context).colorScheme.primary,
        mini: true,
        child: const Icon(Icons.add),
      ),
    );
  }
  
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withAlpha(76),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.monitor_weight,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Start Tracking Your Weight',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Record your weight and track your progress over time. You can also calculate your BMI for better health insights.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(204),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () => _showAddWeightDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Add First Entry'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildWeightSummaryCard(BuildContext context, List<WeightEntry> entries, double? userHeight, bool isSmallScreen) {
    // Calculate stats
    final latestEntry = entries.isNotEmpty ? entries.last : null;
    
    double weightChange = 0.0;
    String trend = "stable";
    
    if (entries.length >= 2) {
      weightChange = latestEntry!.weight - entries[entries.length - 2].weight;
      trend = weightChange < 0 ? "down" : (weightChange > 0 ? "up" : "stable");
    }
    
    // Icon and color based on trend
    IconData trendIcon;
    Color trendColor;
    
    if (trend == "down") {
      trendIcon = Icons.trending_down;
      trendColor = Colors.green;
    } else if (trend == "up") {
      trendIcon = Icons.trending_up;
      trendColor = Colors.red;
    } else {
      trendIcon = Icons.trending_flat;
      trendColor = Theme.of(context).colorScheme.primary;
    }
    
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.monitor_weight,
                    size: isSmallScreen ? 20 : 24,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Weight',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (latestEntry != null)
                      Text(
                        DateFormat('MMM d, yy').format(latestEntry.date),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                  ],
                ),
                const Spacer(),
                Text(
                  latestEntry != null ? '${latestEntry.weight.toStringAsFixed(1)} kg' : 'N/A',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            
            // Add BMI section if available
            if (latestEntry != null && latestEntry.bmi != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: WeightEntry.getBMIColor(latestEntry.bmi!, context).withAlpha(51),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.height,
                            size: 16,
                            color: WeightEntry.getBMIColor(latestEntry.bmi!, context),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'BMI: ${latestEntry.bmi!.toStringAsFixed(1)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: WeightEntry.getBMIColor(latestEntry.bmi!, context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '(${WeightEntry.getBMIStatus(latestEntry.bmi!, gender: latestEntry.gender, age: latestEntry.age)})',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface.withAlpha(179),
                      ),
                    ),
                  ],
                ),
              ),
            
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn(
                  context, 
                  'Trend',
                  Row(
                    children: [
                      Icon(trendIcon, color: trendColor, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        entries.length >= 2 ? '${weightChange.abs().toStringAsFixed(1)} kg' : 'N/A',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: entries.length >= 2 ? trendColor : Theme.of(context).colorScheme.onSurface.withAlpha(102),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatColumn(
                  context, 
                  'Total Entries',
                  Text(
                    entries.length.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                if (userHeight != null)
                  _buildStatColumn(
                    context, 
                    'Height',
                    Text(
                      '${userHeight.toStringAsFixed(1)} cm',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  _buildStatColumn(
                    context, 
                    'First Entry',
                    Text(
                      entries.isNotEmpty 
                          ? '${entries.first.weight.toStringAsFixed(1)} kg' 
                          : 'N/A',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatColumn(BuildContext context, String label, Widget value) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        const SizedBox(height: 4),
        value,
      ],
    );
  }
  
  Widget _buildWeightHistoryList(BuildContext context, List<WeightEntry> entries, bool isSmallScreen) {
    // Sort entries by date (newest first)
    final sortedEntries = [...entries];
    sortedEntries.sort((a, b) => b.date.compareTo(a.date));
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            children: [
              Text(
                'Weight History',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (sortedEntries.any((e) => e.bmi != null)) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'BMI Tracked',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: sortedEntries.length,
            itemBuilder: (context, index) {
              final entry = sortedEntries[index];
              final bool isLatest = index == 0;
              
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                elevation: isLatest ? 1 : 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: isLatest 
                    ? Theme.of(context).colorScheme.primaryContainer.withAlpha(51)
                    : Theme.of(context).colorScheme.surfaceContainerLowest,
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isLatest 
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(context).colorScheme.surfaceContainerHighest,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: isLatest
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  title: Row(
                    children: [
                      Text(
                        DateFormat('MMM d, yy').format(entry.date),
                        style: TextStyle(
                          fontWeight: isLatest ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      if (entry.bmi != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: WeightEntry.getBMIColor(entry.bmi!, context).withAlpha(51),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'BMI: ${entry.bmi!.toStringAsFixed(1)}',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: WeightEntry.getBMIColor(entry.bmi!, context),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  trailing: Text(
                    '${entry.weight.toStringAsFixed(1)} kg',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isLatest 
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  subtitle: entry.gender != null && entry.gender!.isNotEmpty
                      ? Text(
                          entry.gender == 'male' ? 'Male' : 'Female',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        )
                      : null,
                  onTap: () => _showViewWeightDialog(context, entry),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  
  void _showAddWeightDialog(BuildContext context) {
    // Pre-fill with existing data if available
    final userHeight = ref.read(userHeightProvider);
    final userAge = ref.read(userAgeProvider);
    final userGender = ref.read(userGenderProvider);
    
    _weightController.clear();
    
    if (userHeight != null) {
      _heightController.text = userHeight.toString();
    } else {
      _heightController.clear();
    }
    
    if (userAge != null) {
      _ageController.text = userAge.toString();
    } else {
      _ageController.clear();
    }
    
    _calculateBMI = userHeight != null;
    _selectedGender = userGender;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.98,
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.9,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.monitor_weight,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Add Weight Entry',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                
                const Divider(height: 24),
                
                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Main weight field
                        const Text(
                          'Weight (kg) *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _weightController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          autofocus: true,
                          decoration: InputDecoration(
                            hintText: 'Enter your weight',
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.surfaceContainerLow,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: const Icon(Icons.monitor_weight),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // BMI toggle
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.outline.withAlpha(51),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.calculate_outlined,
                                    size: 20,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Calculate BMI',
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  Switch(
                                    value: _calculateBMI,
                                    onChanged: (value) {
                                      setState(() {
                                        _calculateBMI = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              
                              if (_calculateBMI) ...[
                                const SizedBox(height: 16),
                                
                                // Height field
                                const Text(
                                  'Height (cm) *',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _heightController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: 'Enter your height',
                                    filled: true,
                                    fillColor: Theme.of(context).colorScheme.surface,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none,
                                    ),
                                    prefixIcon: const Icon(Icons.height),
                                  ),
                                ),
                                
                                const SizedBox(height: 16),
                                
                                // Age field
                                const Text(
                                  'Age *',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _ageController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: 'Enter your age',
                                    filled: true,
                                    fillColor: Theme.of(context).colorScheme.surface,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none,
                                    ),
                                    prefixIcon: const Icon(Icons.cake),
                                  ),
                                ),
                                
                                const SizedBox(height: 16),
                                
                                // Gender selection
                                Text(
                                  'Gender *',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildGenderOption(
                                        context,
                                        'Male',
                                        Icons.male,
                                        _selectedGender == 'male',
                                        () => setState(() => _selectedGender = 'male'),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildGenderOption(
                                        context,
                                        'Female',
                                        Icons.female,
                                        _selectedGender == 'female',
                                        () => setState(() => _selectedGender = 'female'),
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
                ),
                
                // Bottom actions
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(20),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 48,
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 52,
                        child: FilledButton(
                          onPressed: () {
                            // Validate and save
                            final weightText = _weightController.text.trim();
                            
                            if (weightText.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please enter your weight')),
                              );
                              return;
                            }
                            
                            try {
                              final weight = double.parse(weightText);
                              double? height;
                              int? age;
                              String? gender;
                              double? bmi;
                              
                              if (_calculateBMI) {
                                // Validate height
                                final heightText = _heightController.text.trim();
                                if (heightText.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Please enter your height')),
                                  );
                                  return;
                                }
                                
                                // Validate age
                                final ageText = _ageController.text.trim();
                                if (ageText.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Please enter your age')),
                                  );
                                  return;
                                }
                                
                                // Validate gender
                                if (_selectedGender == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Please select your gender')),
                                  );
                                  return;
                                }
                                
                                height = double.parse(heightText);
                                age = int.parse(ageText);
                                gender = _selectedGender;
                                
                                // Save user details for future use
                                ref.read(userHeightProvider.notifier).state = height;
                                ref.read(userAgeProvider.notifier).state = age;
                                ref.read(userGenderProvider.notifier).state = gender;
                                
                                // Calculate BMI with age and gender
                                bmi = WeightEntry.calculateBMI(
                                  weight, 
                                  height,
                                  age: age,
                                  gender: gender,
                                );
                              }
                              
                              final newEntry = WeightEntry(
                                date: DateTime.now(),
                                weight: weight,
                                height: height,
                                age: age,
                                gender: gender,
                                bmi: bmi,
                              );
                              
                              // Add to list
                              final entries = [...ref.read(weightEntriesProvider)];
                              entries.add(newEntry);
                              ref.read(weightEntriesProvider.notifier).state = entries;
                              
                              Navigator.of(context).pop();
                              
                              // Show BMI toast if calculated
                              if (bmi != null) {
                                final bmiStatus = WeightEntry.getBMIStatus(
                                  bmi, 
                                  gender: gender, 
                                  age: age
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('BMI: ${bmi.toStringAsFixed(1)} - $bmiStatus'),
                                    backgroundColor: WeightEntry.getBMIColor(bmi, context),
                                  ),
                                );
                              }
                            } catch (e) {
                              // Show error for invalid number
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please enter valid numbers')),
                              );
                            }
                          },
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Save'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildGenderOption(
    BuildContext context, 
    String label, 
    IconData icon, 
    bool isSelected, 
    VoidCallback onTap
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? Theme.of(context).colorScheme.primaryContainer 
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected 
                ? Theme.of(context).colorScheme.primary 
                : Theme.of(context).colorScheme.outline.withAlpha(128),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected 
                  ? Theme.of(context).colorScheme.primary 
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected 
                    ? Theme.of(context).colorScheme.primary 
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showViewWeightDialog(BuildContext context, WeightEntry entry) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Weight Details',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Date', DateFormat('MMM d, yy').format(entry.date)),
            const SizedBox(height: 12),
            _buildDetailRow('Weight', '${entry.weight.toStringAsFixed(1)} kg'),
            
            if (entry.height != null) ...[
              const SizedBox(height: 12),
              _buildDetailRow('Height', '${entry.height!.toStringAsFixed(1)} cm'),
            ],
            
            if (entry.age != null) ...[
              const SizedBox(height: 12),
              _buildDetailRow('Age', entry.age.toString()),
            ],
            
            if (entry.gender != null) ...[
              const SizedBox(height: 12),
              _buildDetailRow(
                'Gender', 
                entry.gender == 'male' ? 'Male' : 'Female',
              ),
            ],
            
            if (entry.bmi != null) ...[
              const SizedBox(height: 12),
              _buildDetailRow(
                'BMI', 
                '${entry.bmi!.toStringAsFixed(1)} (${WeightEntry.getBMIStatus(entry.bmi!, gender: entry.gender, age: entry.age)})',
                valueColor: WeightEntry.getBMIColor(entry.bmi!, context),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showDeleteConfirmation(context, entry);
            },
            child: Text(
              'Delete',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: valueColor != null ? TextStyle(
              fontWeight: FontWeight.bold,
              color: valueColor,
            ) : null,
          ),
        ),
      ],
    );
  }
  
  void _showDeleteConfirmation(BuildContext context, WeightEntry entry) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Entry'),
        content: const Text(
          'Are you sure you want to delete this weight entry? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () {
              // Remove from list
              final entries = [...ref.read(weightEntriesProvider)];
              entries.removeWhere((e) => 
                e.date.isAtSameMomentAs(entry.date) && e.weight == entry.weight
              );
              ref.read(weightEntriesProvider.notifier).state = entries;
              
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
  
  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Weight Tracker',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Track your weight and BMI progress over time.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            const Text(
              'Features:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildInfoPoint(context, 'Record weight entries'),
            _buildInfoPoint(context, 'Calculate and track BMI'),
            _buildInfoPoint(context, 'View weight history and trends'),
            _buildInfoPoint(context, 'Add notes to entries'),
            
            const SizedBox(height: 16),
            const Text(
              'BMI Categories:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildBMIInfoRow(context, 'Under 18.5', 'Underweight', Colors.blue),
            _buildBMIInfoRow(context, '18.5 - 24.9', 'Healthy', Colors.green),
            _buildBMIInfoRow(context, '25 - 29.9', 'Overweight', Colors.orange),
            _buildBMIInfoRow(context, '30 and over', 'Obese', Colors.red),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoPoint(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
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
  
  Widget _buildBMIInfoRow(BuildContext context, String range, String category, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            range,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '- $category',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
} 