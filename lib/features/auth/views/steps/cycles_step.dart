import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/registration_data.dart';

class CyclesStep extends StatefulWidget {
  final RegistrationData data;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final int currentStepIndex;

  const CyclesStep({
    super.key,
    required this.data,
    required this.onNext,
    required this.onBack,
    required this.currentStepIndex,
  });

  @override
  State<CyclesStep> createState() => _CyclesStepState();
}

class _CyclesStepState extends State<CyclesStep> {
  int _cycleLength = 28;
  DateTime? _lastPeriodDate;
  bool _showCycleDayWarning = false;

  int? get _cycleDay {
    if (_lastPeriodDate == null) return null;
    final today = DateTime.now();
    final difference = today.difference(_lastPeriodDate!).inDays;
    return difference + 1; // День цикла = количество дней с первого дня менструации + 1
  }

  @override
  void initState() {
    super.initState();
    if (widget.data.cycleLength != null) {
      _cycleLength = widget.data.cycleLength!;
    }
    if (widget.data.lastPeriodDate != null) {
      _lastPeriodDate = widget.data.lastPeriodDate;
    }
  }

  Future<void> _saveAndProceed() async {
    if (_lastPeriodDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select the last period date.'),
        ),
      );
      return;
    }

    // Проверяем, не превышает ли текущий день цикла его длину
    if (_cycleDay != null && _cycleDay! > _cycleLength) {
      setState(() {
        _showCycleDayWarning = true;
      });
      
      final bool? shouldProceed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Attention"),
          content: const Text("It seems a new cycle might have started. Would you like to adjust your cycle length or continue anyway?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Adjust"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Continue"),
            ),
          ],
        ),
      );

      if (shouldProceed != true) {
        return;
      }
    }

    widget.data.cycleLength = _cycleLength;
    widget.data.lastPeriodDate = _lastPeriodDate;
    widget.data.cycleDay = _cycleDay;

    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Menstrual Cycle Length",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Text("From the first day of one menstruation to the first day of the next"),
                  const SizedBox(height: 16),
                  Slider(
                    value: _cycleLength.toDouble(),
                    min: 21,
                    max: 38,
                    divisions: 14,
                    label: "$_cycleLength days",
                    onChanged: (value) {
                      setState(() {
                        _cycleLength = value.round();
                        _showCycleDayWarning = false;
                      });
                    },
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "$_cycleLength days",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Last Menstruation",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Text("Select the first day of your last menstruation"),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _lastPeriodDate ?? DateTime.now().subtract(const Duration(days: 14)),
                        firstDate: DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setState(() {
                          _lastPeriodDate = date;
                          _showCycleDayWarning = false;
                        });
                      }
                    },
                    child: Text(_lastPeriodDate == null
                        ? "Select Date"
                        : DateFormat('dd.MM.yyyy').format(_lastPeriodDate!)),
                  ),
                  if (_lastPeriodDate != null && _cycleDay != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      "Today is day $_cycleDay of your $_cycleLength-day cycle",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _showCycleDayWarning ? Colors.red : null,
                      ),
                    ),
                    if (_showCycleDayWarning)
                      const Text(
                        "This exceeds your defined cycle length",
                        style: TextStyle(color: Colors.red),
                      ),
                  ],
                ],
              ),
            ),
          ),
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
                  onPressed: _saveAndProceed,
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}