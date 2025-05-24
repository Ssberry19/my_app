import 'package:flutter/material.dart';
import '../models/registration_data.dart';
import 'steps/personal_info_step.dart';
import 'steps/physical_params_step.dart';
import 'steps/goals_step.dart';
import 'steps/cycles_step.dart';
import 'steps/credentials_step.dart';
import 'package:my_app/features/home/views/home_screen.dart';

class RegistrationFlow extends StatefulWidget {
  const RegistrationFlow({super.key});

  @override
  State<RegistrationFlow> createState() => _RegistrationFlowState();
}


class _RegistrationFlowState extends State<RegistrationFlow> {
  final RegistrationData _userData = RegistrationData();
  int _currentStepIndex = 0;
  late List<Widget> _steps = [];

  @override
  void initState() {
    super.initState();
    _initializeSteps();
  }

  void _initializeSteps() {
    _steps.addAll([
      PersonalInfoStep(
        data: _userData,
        onNext: _goNext,
        onBack: _goBack,
        currentStepIndex: 0, // Указываем индекс шага
      ),
      PhysicalParamsStep(
        data: _userData,
        onNext: _goNext,
        onBack: _goBack,
        currentStepIndex: 1, // Указываем индекс шага
      ),
      GoalsStep(
      data: _userData,
      onNext: _goNext,
      onBack: _goBack,
      currentStepIndex: 2,
      ),
      // if (_userData.gender == Gender.female)
      CyclesStep(
        data: _userData,
        onNext: _goNext,
        onBack: _goBack,
        currentStepIndex: 3,
      ),
      CredentialsStep(
        data: _userData,
        onNext: _completeRegistration,
        onBack: _goBack,
        currentStepIndex: 4,
        // _userData.gender == Gender.female ? 4 : 3,
      ),
      // Остальные шаги...
    ]);

    // Добавьте слушатель для обновления шагов при изменении пола
    _userData.addListener(() {
      if (_userData.gender != null) {
        setState(() {
          _steps = [];
          _initializeSteps();
          _currentStepIndex = _currentStepIndex.clamp(0, _steps.length - 1);
        });
      }
    });
}

  void _completeRegistration() {
    // Здесь должна быть логика отправки данных на сервер
  // После успешной регистрации переходим на главный экран
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => HomeScreen2(), // Ваш существующий HomeScreen
    ),
  );
  }

  void _goNext() {
    if (_currentStepIndex < _steps.length - 1) {
      setState(() => _currentStepIndex++);
    }
  }

  void _goBack() {
    if (_currentStepIndex > 0) {
      setState(() => _currentStepIndex--);
    }
  }

  @override
   Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Шаг ${_currentStepIndex + 1}/${_steps.length}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _currentStepIndex > 0 ? _goBack : null,
        ),
      ),
      body: Column(
        children: [
          _buildProgressIndicator(), // Добавляем индикатор
          Expanded(child: _steps[_currentStepIndex]), // Основной контент
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goNext,
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          _steps.length,
          (index) => Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: index == _currentStepIndex
                  ? Colors.deepPurple
                  : Colors.grey[300],
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}