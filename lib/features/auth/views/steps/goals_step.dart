import 'package:flutter/material.dart';
import '../../models/registration_data.dart';

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
  final List<String> allergens = ["nuts", "eggs", "seafood", "dairy", "gluten"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Activity Level Dropdown
                          DropdownButtonFormField<ActivityLevel>(
                            value: widget.data.activityLevel,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              labelText: 'Activity Level',
                              border: OutlineInputBorder(),
                            ),
                            items: ActivityLevel.values.map((ActivityLevel level) {
                              return DropdownMenuItem<ActivityLevel>(
                                value: level,
                                child: Text(
                                  _activityLevelToString(level),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            onChanged: (ActivityLevel? newValue) {
                              setState(() {
                                widget.data.activityLevel = newValue;
                              });
                            },
                            validator: (value) => 
                                value == null ? 'Please select an activity level' : null,
                          ),
                          const SizedBox(height: 20),

                          // Allergens selection
                          const Text(
                            'Select your allergens:',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: allergens.map((allergen) {
                              return FilterChip(
                                label: Text(allergen),
                                selected: widget.data.allergens?.contains(allergen) ?? false,
                                onSelected: (bool selected) {
                                  setState(() {
                                    widget.data.allergens ??= [];
                                    if (selected) {
                                      widget.data.allergens!.add(allergen);
                                    } else {
                                      widget.data.allergens!.remove(allergen);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 20),

                          // Кнопки навигации - теперь без Spacer()
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Row(
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
                                        widget.onNext();
                                      }
                                    },
                                    child: const Text('Next'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  String _activityLevelToString(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.sedentary:
        return 'Sedentary (little or no exercise)';
      case ActivityLevel.light:
        return 'Lightly active (1-3 days a week of light exercise)';
      case ActivityLevel.moderate:
        return 'Moderately active (3-5 days a week of moderate exercise)';
      case ActivityLevel.high:
        return 'Active (6-7 days a week of vigorous exercise)';
      case ActivityLevel.extreme:
        return 'Very active (twice a day or heavy physical job)';
    }
  }
}