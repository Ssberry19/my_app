import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Для форматирования даты
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
  int _cycleLength = 28; // По умолчанию 28 дней
  DateTime? _lastPeriodDate;

  // Рассчитываемый день цикла
  int? get _cycleDay {
    if (_lastPeriodDate == null) return null;
    final today = DateTime.now();
    final difference = today.difference(_lastPeriodDate!).inDays;
    // Если разница отрицательна (дата последней менструации в будущем), или разница очень большая
    if (difference < 0) return 1; // Или выбросить ошибку
    return (difference % _cycleLength) + 1; // День цикла
  }

  @override
  void initState() {
    super.initState();
    // Инициализируем значения из RegistrationData, если они есть
    if (widget.data.cycleLength != null) {
      _cycleLength = widget.data.cycleLength!;
    }
    if (widget.data.lastPeriodDate != null) {
      _lastPeriodDate = widget.data.lastPeriodDate;
    }
  }

  // Метод для сохранения данных и перехода к следующему шагу
  void _saveAndProceed() {
    if (_lastPeriodDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select the last period date.'),
        ),
      );
      return;
    }

    if (_cycleDay != null && _cycleDay! > _cycleLength) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Внимание"),
          content: const Text("Возможно, начался новый цикл. Проверьте дату последней менструации."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    widget.data.cycleLength = _cycleLength;
    widget.data.lastPeriodDate = _lastPeriodDate;
    widget.data.cycleDay = _cycleDay; // Сохраняем рассчитанный день цикла

    widget.onNext(); // Переходим к следующему шагу
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Длина цикла
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Длина менструального цикла",
                    style: Theme.of(context).textTheme.titleLarge, // Использовал titleLarge вместо headline6
                  ),
                  const Text(
                      "От первого дня одной менструации до первого дня следующей"),
                  const SizedBox(height: 16),
                  Slider(
                    value: _cycleLength.toDouble(),
                    min: 21,
                    max: 38,
                    divisions: 14,
                    label: "$_cycleLength дней",
                    onChanged: (value) {
                      setState(() {
                        _cycleLength = value.round();
                      });
                    },
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "$_cycleLength дней",
                      style: Theme.of(context).textTheme.headlineSmall, // Использовал headlineSmall вместо headline5
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Дата последней менструации
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Последняя менструация",
                    style: Theme.of(context).textTheme.titleLarge, // Использовал titleLarge вместо headline6
                  ),
                  const Text("Выберите первый день последней менструации"),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _lastPeriodDate ?? DateTime.now().subtract(const Duration(days: 14)),
                        firstDate: DateTime.now().subtract(const Duration(days: 365)), // Можно ограничить год назад
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setState(() {
                          _lastPeriodDate = date;
                        });
                      }
                    },
                    child: Text(_lastPeriodDate == null
                        ? "Выбрать дату"
                        : DateFormat('dd.MM.yyyy').format(_lastPeriodDate!)),
                  ),
                  if (_lastPeriodDate != null && _cycleDay != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      "Сегодня $_cycleDay день цикла",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ],
              ),
            ),
          ),

          const Spacer(), // Занимает все доступное вертикальное пространство
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
                  onPressed: _saveAndProceed, // Используем новую функцию
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