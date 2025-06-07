import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/registration_data.dart';

class PersonalInfoStep extends StatefulWidget {
  final RegistrationData data;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final int currentStepIndex;
  final VoidCallback onSaveAndContinue;

  const PersonalInfoStep({
    super.key,
    required this.data,
    required this.onNext,
    required this.onBack,
    required this.currentStepIndex,
    required this.onSaveAndContinue,
  });

  @override
  State<PersonalInfoStep> createState() => _PersonalInfoStepState();
}

class _PersonalInfoStepState extends State<PersonalInfoStep> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  // Gender is now directly managed by widget.data.gender via setState

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.data.username);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    super.dispose();
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
              controller: _fullNameController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Username',
                hintText: 'e.g. user123',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your username';
                }
                return null;
              },
              onChanged: (value) => widget.data.username = value,
            ),
            const SizedBox(height: 20),
            // Reverted gender selection to RadioListTile
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
                'Date of Birth: ${widget.data.birthDate == null ? 'Not selected' : DateFormat('dd.MM.yyyy').format(widget.data.birthDate!)}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: widget.data.birthDate ?? DateTime.now().subtract(const Duration(days: 365 * 18)),
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
                  Expanded(
                    child: ElevatedButton(
                      onPressed: widget.onBack,
                      child: const Text('Back'),
                    ),
                  ),
                if (widget.currentStepIndex > 0)
                  const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // Просто переходим к следующему шагу, данные уже в widget.data
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
  String _genderToString(Gender gender) {
    return {
      Gender.male: 'Male',
      Gender.female: 'Female',
    }[gender]!;
  }

}