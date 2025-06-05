import 'package:flutter/material.dart';
import '../../models/registration_data.dart';

class PersonalInfoStep extends StatefulWidget {
  final RegistrationData data;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final int currentStepIndex; // Добавляем параметр
  final VoidCallback onSaveAndContinue; // New callback for saving and continuing

  const PersonalInfoStep({
    super.key,
    required this.data,
    required this.onNext,
    required this.onBack,
    required this.currentStepIndex, // Получаем из родителя
    required this.onSaveAndContinue, // Initialize the new callback
  });

  @override
  State<PersonalInfoStep> createState() => _PersonalInfoStepState();
}

class _PersonalInfoStepState extends State<PersonalInfoStep> {
  final _formKey = GlobalKey<FormState>();

   @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.text,
              initialValue: widget.data.fullName, // Pre-fill if data exists
              decoration: const InputDecoration(
                labelText: 'Username',
                hintText: 'ssberry19',
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Enter name';
                setState(() => widget.data.fullName = value);
                return null;
              },
              onSaved: (value) => widget.data.fullName = value,
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<Gender>(
              value: widget.data.gender,
              items: Gender.values.map((gender) {
                return DropdownMenuItem(
                  value: gender,
                  child: Text(_genderToString(gender)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => widget.data.gender = value);
                widget.data.notify(); // Уведомляем об изменении
              },
              decoration: const InputDecoration(labelText: 'Gender'),
              validator: (value) {
                if (value == null) return 'Choose gender';
                return null;
              },
            ),
            const SizedBox(height: 20),
            ListTile(
              title: Text(
                widget.data.birthDate == null
                    ? 'Choose birth date'
                    : 'Birth Date: ${_formatDate(widget.data.birthDate!)}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() => widget.data.birthDate = date);
                }
              },
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
                      // Просто переходим к следующему шагу, данные уже в widget.data
                      widget.onNext();
                    }
                  },
                  child: const Text('Next'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _genderToString(Gender gender) {
    return {
      Gender.male: 'Male',
      Gender.female: 'Female',
    }[gender]!;
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}