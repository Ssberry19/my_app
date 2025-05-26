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
  double? _currentBMI;

  @override
  void initState() {
    super.initState();
    _calculateBMI(); // Рассчитать ИМТ при инициализации
  }

  void _calculateBMI() {
    if (widget.data.height != null && widget.data.weight != null) {
      final heightM = widget.data.height! / 100;
      setState(() {
        _currentBMI = widget.data.weight! / (heightM * heightM);
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
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Height (cm)',
                hintText: '175',
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Enter height';
                final parsed = double.tryParse(value!);
                if (parsed == null || parsed <= 0) return 'Invalid format';
                return null;
              },
              onChanged: (value) {
                widget.data.height = double.tryParse(value);
                _calculateBMI();
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Weight (kg)',
                hintText: '65',
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Enter weight';
                final parsed = double.tryParse(value!);
                if (parsed == null || parsed <= 0) return 'Invalid format';
                return null;
              },
              onChanged: (value) {
                widget.data.weight = double.tryParse(value);
                _calculateBMI();
              },
            ),
            const SizedBox(height: 20),
            if (_currentBMI != null)
              Text(
                'Current BMI: ${_currentBMI!.toStringAsFixed(1)}',
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
                if (widget.currentStepIndex > 0)
                  ElevatedButton(
                    onPressed: widget.onBack,
                    child: const Text('Back'),
                  ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      widget.onNext();
                    }
                  },
                  child: const Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}