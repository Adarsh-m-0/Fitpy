import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weight_entry.dart';

class WeightEntryForm extends StatefulWidget {
  final WeightEntry? initialEntry;
  final Function(WeightEntry) onSave;
  
  const WeightEntryForm({
    Key? key,
    this.initialEntry,
    required this.onSave,
  }) : super(key: key);

  @override
  State<WeightEntryForm> createState() => _WeightEntryFormState();
}

class _WeightEntryFormState extends State<WeightEntryForm> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _notesController = TextEditingController();
  late DateTime _selectedDate;
  
  @override
  void initState() {
    super.initState();
    
    if (widget.initialEntry != null) {
      _weightController.text = widget.initialEntry!.weight.toString();
      _notesController.text = widget.initialEntry!.notes ?? '';
      _selectedDate = widget.initialEntry!.date;
    } else {
      _selectedDate = DateTime.now();
    }
  }
  
  @override
  void dispose() {
    _weightController.dispose();
    _notesController.dispose();
    super.dispose();
  }
  
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
  
  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final weight = double.parse(_weightController.text);
      final notes = _notesController.text.trim().isEmpty ? null : _notesController.text.trim();
      
      final entry = WeightEntry(
        id: widget.initialEntry?.id,
        weight: weight,
        date: _selectedDate,
        notes: notes,
      );
      
      widget.onSave(entry);
      Navigator.of(context).pop();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialEntry != null;
    
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              isEditing ? 'Edit Weight Entry' : 'Add Weight Entry',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            // Date field
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                  ),
                  controller: TextEditingController(
                    text: DateFormat('EEEE, MMMM d, y').format(_selectedDate),
                  ),
                  readOnly: true,
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Weight field
            TextFormField(
              controller: _weightController,
              decoration: const InputDecoration(
                labelText: 'Weight (kg)',
                prefixIcon: Icon(Icons.monitor_weight),
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your weight';
                }
                
                final weight = double.tryParse(value);
                if (weight == null) {
                  return 'Please enter a valid number';
                }
                
                if (weight <= 0 || weight > 500) {
                  return 'Please enter a reasonable weight';
                }
                
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Notes field
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                prefixIcon: Icon(Icons.note),
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 16),
                FilledButton(
                  onPressed: _submitForm,
                  child: Text(isEditing ? 'Update' : 'Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 