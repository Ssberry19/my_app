import 'package:flutter/material.dart';
import '../../models/registration_data.dart'; // Assuming this path

class GoalsStep extends StatefulWidget {
  final RegistrationData data;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final int currentStepIndex;

  const GoalsStep({
    super.key,
    required this.data,
    required this.onNext,
    required this.onBack,
    required this.currentStepIndex,
  });

  @override
  State<GoalsStep> createState() => _GoalsStepState();
}

class _GoalsStepState extends State<GoalsStep> {
  final _formKey = GlobalKey<FormState>();
  double? _targetBMI;

  @override
  void initState() {
    super.initState();
    _calculateTargetBMI();
  }

  void _calculateTargetBMI() {
    if (widget.data.height != null && widget.data.targetWeight != null) {
      final heightM = widget.data.height! / 100;
      setState(() {
        _targetBMI = widget.data.targetWeight! / (heightM * heightM);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            DropdownButtonFormField<FitnessGoal>(
              value: widget.data.goal,
              items: FitnessGoal.values.map((goal) {
                return DropdownMenuItem(
                  value: goal,
                  child: Text(_goalToString(goal)),
                );
              }).toList(),
              onChanged: (value) => setState(() => widget.data.goal = value),
              decoration: const InputDecoration(labelText: 'Цель'),
              validator: (value) {
                if (value == null) return 'Выберите цель';
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Целевой вес (кг)',
                hintText: '60',
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Введите вес';
                final parsed = double.tryParse(value!);
                if (parsed == null || parsed <= 0) return 'Неверный формат';
                return null;
              },
              onChanged: (value) {
                widget.data.targetWeight = double.tryParse(value);
                _calculateTargetBMI();
                
              },
            ),
            const SizedBox(height: 20),
            // New Dropdown for Activity Level
            DropdownButtonFormField<ActivityLevel>(
              value: widget.data.activityLevel,
              items: ActivityLevel.values.map((level) {
                return DropdownMenuItem(
                  value: level,
                  child: Text(_activityLevelToString(level)),
                );
              }).toList(),
              onChanged: (value) => setState(() => widget.data.activityLevel = value),
              decoration: const InputDecoration(labelText: 'Уровень активности'),
              validator: (value) {
                if (value == null) return 'Выберите уровень активности';
                return null;
              },
            ),
            const SizedBox(height: 20),
            if (_targetBMI != null)
              Text(
                'ИМТ при целевом весе: ${_targetBMI!.toStringAsFixed(1)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: widget.onBack,
                  child: const Text('Назад'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      widget.onNext();
                    }
                  },
                  child: const Text('Далее'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _goalToString(FitnessGoal goal) {
    return {
      FitnessGoal.loseWeight: 'Похудение',
      FitnessGoal.maintain: 'Поддержание веса',
      FitnessGoal.gainWeight: 'Набор массы',
      FitnessGoal.cutting: 'Сушка',
    }[goal]!;
  }

  // Helper method to convert ActivityLevel enum to a display string
  String _activityLevelToString(ActivityLevel level) {
    return {
      ActivityLevel.sedentary: 'Сидячий (минимум или отсутствие упражнений)',
      ActivityLevel.light: 'Легкая активность (1-3 дня в неделю легких упражнений)',
      ActivityLevel.moderate: 'Умеренная активность (3-5 дней в неделю умеренных упражнений)',
      ActivityLevel.active: 'Очень активный (6-7 дней в неделю интенсивных упражнений)',
    }[level]!;
  }
}