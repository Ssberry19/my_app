import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
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
  late DateTime _focusedDay;
  late CalendarFormat _calendarFormat;
  Set<DateTime> _selectedDays = {};

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _calendarFormat = CalendarFormat.month;
    _selectedDays = widget.data.menstrualCycles.toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'Enter three last dates of your menstrual cycles',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TableCalendar(
            firstDay: DateTime.now().subtract(const Duration(days: 365)),
            lastDay: DateTime.now(),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => _selectedDays.contains(day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                if (_selectedDays.contains(selectedDay)) {
                  _selectedDays.remove(selectedDay);
                } else {
                  _selectedDays.add(selectedDay);
                }
                widget.data.menstrualCycles = _selectedDays.toList();
              });
            },
            onFormatChanged: (format) {
              setState(() => _calendarFormat = format);
            },
            onPageChanged: (focusedDay) => _focusedDay = focusedDay,
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Colors.deepPurple,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.deepPurple[100],
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: widget.onBack,
                child: const Text('Back'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_selectedDays.length >= 3) {
                    widget.onNext();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select at least 3 dates.'),
                      ),
                    );
                  }
                },
                child: const Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}