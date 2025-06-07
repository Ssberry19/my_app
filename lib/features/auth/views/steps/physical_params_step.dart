import 'package:flutter/material.dart';
import '../../models/registration_data.dart';

class PhysicalParamsStep extends StatefulWidget {
  final RegistrationData data;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final int currentStepIndex;

  const PhysicalParamsStep({
    super.key,
    required this.data,
    required this.onNext,
    required this.onBack,
    required this.currentStepIndex,
  });

  @override
  State<PhysicalParamsStep> createState() => _PhysicalParamsStepState();
}

class _PhysicalParamsStepState extends State<PhysicalParamsStep> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _targetWeightController;
  double? _currentBMI;
  double? _targetBMI;

  @override
  void initState() {
    super.initState();
    _heightController = TextEditingController(text: widget.data.height?.toString());
    _weightController = TextEditingController(text: widget.data.weight?.toString());
    _targetWeightController = TextEditingController(text: widget.data.targetWeight?.toString());

    _calculateBMI();
    _calculateTargetBMI();
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _targetWeightController.dispose();
    super.dispose();
  }

  void _calculateBMI() {
    if (widget.data.height != null && widget.data.weight != null && widget.data.height! > 0) {
      final heightM = widget.data.height! / 100;
      setState(() {
        _currentBMI = widget.data.weight! / (heightM * heightM);
      });
    } else {
      setState(() {
        _currentBMI = null;
      });
    }
  }

  void _calculateTargetBMI() {
    if (widget.data.height != null && widget.data.targetWeight != null && widget.data.height! > 0) {
      final heightM = widget.data.height! / 100;
      setState(() {
        _targetBMI = widget.data.targetWeight! / (heightM * heightM);
      });
    } else {
      setState(() {
        _targetBMI = null;
      });
    }
  }

  Color _getBMIColor(double bmi) {
    if (bmi < 16) return Colors.deepPurple;
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 25) return Colors.green;
    if (bmi < 30) return Colors.orange;
    if (bmi < 35) return Colors.deepOrange;
    if (bmi < 40) return Colors.red;
    return Colors.red[900]!;
  }

  String _getBMICategory(double bmi) {
    if (bmi < 16) return 'Severe thinness';
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    if (bmi < 35) return 'Obese Class I';
    if (bmi < 40) return 'Obese Class II';
    return 'Obese Class III';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Height input
            TextFormField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Height (cm)',
                hintText: 'e.g. 170',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter your height';
                final parsed = double.tryParse(value);
                if (parsed == null || parsed <= 0 || parsed > 250) return 'Invalid height';
                return null;
              },
              onChanged: (value) {
                widget.data.height = double.tryParse(value);
                _calculateBMI();
                _calculateTargetBMI();
              },
            ),
            const SizedBox(height: 20),

            // Weight input
            TextFormField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Weight (kg)',
                hintText: 'e.g. 65.5',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter your weight';
                final parsed = double.tryParse(value);
                if (parsed == null || parsed <= 0 || parsed > 300) return 'Invalid weight';
                return null;
              },
              onChanged: (value) {
                widget.data.weight = double.tryParse(value);
                _calculateBMI();
              },
            ),
            const SizedBox(height: 20),

            // Current BMI slider
            if (_currentBMI != null) ...[
              Column(
                children: [
                  Text(
                    'Current BMI: ${_currentBMI!.toStringAsFixed(1)} (${_getBMICategory(_currentBMI!)})',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _getBMIColor(_currentBMI!),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildBMISlider(_currentBMI!),
                ],
              ),
              const SizedBox(height: 20),
            ],

            // Main goal dropdown
            DropdownButtonFormField<FitnessGoal>(
              value: widget.data.goal,
              decoration: const InputDecoration(
                labelText: 'Your main goal',
                border: OutlineInputBorder(),
              ),
              items: FitnessGoal.values.map((FitnessGoal goal) {
                return DropdownMenuItem<FitnessGoal>(
                  value: goal,
                  child: Text(_goalToString(goal)),
                );
              }).toList(),
              onChanged: (FitnessGoal? newValue) {
                setState(() {
                  widget.data.goal = newValue;
                });
              },
              validator: (value) => value == null ? 'Please select a goal' : null,
            ),
            const SizedBox(height: 20),

            // Target weight input
            TextFormField(
              controller: _targetWeightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Target Weight (kg)',
                hintText: 'e.g. 60',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter your target weight';
                final parsed = double.tryParse(value);
                if (parsed == null || parsed <= 0 || parsed > 300) return 'Invalid target weight';
                
                // Additional validation for target weight compared to current weight
                if (widget.data.weight != null && widget.data.goal != null) {
                  if (widget.data.goal == FitnessGoal.loseWeight && parsed >= widget.data.weight!) {
                    return 'Target weight should be less than current weight for weight loss';
                  }
                  if (widget.data.goal == FitnessGoal.gainWeight && parsed <= widget.data.weight!) {
                    return 'Target weight should be more than current weight for weight gain';
                  }
                  if (widget.data.goal == FitnessGoal.maintain && parsed != widget.data.weight!) {
                    return 'Target weight should match current weight for maintenance';
                  }
                }
                return null;
              },
              onChanged: (value) {
                widget.data.targetWeight = double.tryParse(value);
                _calculateTargetBMI();
              },
            ),
            const SizedBox(height: 20),

            // Target BMI slider
            if (_targetBMI != null) ...[
              Column(
                children: [
                  Text(
                    'Target BMI: ${_targetBMI!.toStringAsFixed(1)} (${_getBMICategory(_targetBMI!)})',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _getBMIColor(_targetBMI!),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildBMISlider(_targetBMI!),
                ],
              ),
              const SizedBox(height: 20),
            ],

            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.currentStepIndex > 0 ? widget.onBack : null,
                    child: const Text('Back'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Additional validation for BMI range
                        if (_currentBMI != null && (_currentBMI! < 10 || _currentBMI! > 50)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Current BMI is outside reasonable range (10-50)')),
                          );
                          return;
                        }
                        if (_targetBMI != null && (_targetBMI! < 10 || _targetBMI! > 50)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Target BMI is outside reasonable range (10-50)')),
                          );
                          return;
                        }
                        widget.onNext();
                      }
                    },
                    child: const Text('Next'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBMISlider(double bmi) {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: _getBMIColor(bmi),
            inactiveTrackColor: Colors.grey[300],
            thumbColor: _getBMIColor(bmi),
            overlayColor: _getBMIColor(bmi).withAlpha(0x29),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
            trackHeight: 4,
          ),
          child: Slider(
            value: bmi.clamp(10, 50).toDouble(),
            min: 10,
            max: 50,
            divisions: 40,
            label: bmi.toStringAsFixed(1),
            onChanged: null,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('10', style: TextStyle(color: Colors.deepPurple)),
            Text('16', style: TextStyle(color: Colors.blue)),
            Text('18.5', style: TextStyle(color: Colors.green)),
            Text('25', style: TextStyle(color: Colors.orange)),
            Text('30', style: TextStyle(color: Colors.red)),
            Text('35', style: TextStyle(color: Colors.red[900])),
            Text('40+', style: TextStyle(color: Colors.red[900])),
          ],
        ),
      ],
    );
  }

  String _goalToString(FitnessGoal goal) {
    switch (goal) {
      case FitnessGoal.loseWeight:
        return 'Lose Weight';
      case FitnessGoal.maintain:
        return 'Maintain Weight';
      case FitnessGoal.gainWeight:
        return 'Gain Weight';
    }
  }
}