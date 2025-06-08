// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import '../models/registration_data.dart';
import 'steps/personal_info_step.dart';
import 'steps/physical_params_step.dart';
import 'steps/goals_step.dart';
import 'steps/cycles_step.dart';
import 'steps/credentials_step.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http; // Добавляем импорт для HTTP
import 'dart:convert'; // Добавляем импорт для JSON
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart'; // shared_preferences

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

    // Добавляем слушатель для обновления шагов при изменении пола
    // Это важно, если CyclesStep опционален
    _userData.addListener(_updateStepsOnGenderChange);
  }

  // Метод для переинициализации списка шагов
  void _updateStepsOnGenderChange() {
    // Важно: проверяем, что пол был установлен, чтобы избежать лишних перестроек
    if (_userData.gender != null) {
      setState(() {
        final newSteps = <Widget>[
          PersonalInfoStep(
            data: _userData,
            onNext: _goNext,
            onBack: _goBack,
            currentStepIndex: 0,
            onSaveAndContinue: _saveCurrentStepData, // Можно удалить, если не используется
          ),
          PhysicalParamsStep(
            data: _userData,
            onNext: _goNext,
            onBack: _goBack,
            currentStepIndex: 1,
          ),
          GoalsStep(
            data: _userData,
            onNext: _goNext,
            onBack: _goBack,
            currentStepIndex: 2,
          ),
        ];

        // Добавляем CyclesStep только если пол женский
        if (_userData.gender == Gender.female) {
          newSteps.add(CyclesStep(
            data: _userData,
            onNext: _goNext,
            onBack: _goBack,
            currentStepIndex: newSteps.length, // Динамический индекс
          ));
        }

        // CredentialsStep всегда последний
        newSteps.add(CredentialsStep(
          data: _userData,
          onNext: _completeRegistration, // Привязываем _completeRegistration сюда
          onBack: _goBack,
          currentStepIndex: newSteps.length, // Динамический индекс
        ));

        _steps = newSteps;
        // Корректируем текущий индекс, если количество шагов изменилось
        _currentStepIndex = _currentStepIndex.clamp(0, _steps.length - 1);
      });
    }
  }

  void _initializeSteps() {
    // Первичная инициализация шагов (до того, как пол будет выбран)
    // Эта инициализация будет обновлена после выбора пола через слушатель
    _steps.addAll([
      PersonalInfoStep(
        data: _userData,
        onNext: _goNext,
        onBack: _goBack,
        currentStepIndex: 0,
        onSaveAndContinue: _saveCurrentStepData, // Можно удалить, если не используется
      ),
      PhysicalParamsStep(
        data: _userData,
        onNext: _goNext,
        onBack: _goBack,
        currentStepIndex: 1,
      ),
      GoalsStep(
        data: _userData,
        onNext: _goNext,
        onBack: _goBack,
        currentStepIndex: 2,
      ),
      // Пока что CyclesStep и CredentialsStep могут быть добавлены как заглушки
      // или вообще отсутствовать и быть добавлены только при updateStepsOnGenderChange.
      // Для простоты, здесь мы их не добавляем, так как _updateStepsOnGenderChange
      // будет вызвана сразу после выбора пола.
      // В production-приложениях, возможно, стоит добавить пустой placeholder или
      // сделать _steps динамическим с самого начала, без предварительного addAll.

      // Для начального запуска, можно добавить CredentialsStep, если он не зависит от пола
      // или если вы хотите, чтобы он был доступен на 3 или 4 шаге
      CredentialsStep(
        data: _userData,
        onNext: _completeRegistration,
        onBack: _goBack,
        currentStepIndex: 3, // Это временный индекс, будет пересчитан
      ),
    ]);
  }

  // Этот метод в PersonalInfoStep теперь не делает HTTP-запрос,
  // он просто переходит к следующему шагу после локального сохранения данных.
  void _saveCurrentStepData() {
    _goNext();
  }

  // Метод, который вызывается для отправки всех данных при завершении регистрации
  Future<void> _completeRegistration() async {
    // Собираем все данные из _userData

    // Получаем BACKEND_URL из .env или используем значение по умолчанию
    final backendUrl = dotenv.env['BACKEND_URL'];

    final Map<String, dynamic> registrationPayload = {
      'username': _userData.username,
      'gender': _userData.gender?.toString().split('.').last, // Преобразуем Enum в строку
      'birthDate': _userData.birthDate?.toIso8601String(), // ISO 8601 формат для даты
      'height': _userData.height,
      'weight': _userData.weight,
      'targetWeight': _userData.targetWeight,
      'goal': _userData.goal?.toString().split('.').last, // Преобразуем Enum в строку
      'activityLevel': _userData.activityLevel?.toString().split('.').last, // Преобразуем Enum в строку
      'allergens': _userData.allergens, // Список аллергенов
      'cycleLength': _userData.cycleLength, // Используем значение из _userData, если оно есть
      'lastPeriodDate':  _userData.lastPeriodDate?.toIso8601String().split('T').first,
      'cycleDay':  _userData.cycleDay,
      'email': _userData.email,
      'password': _userData.password,
      // 'confirmPassword' не включаем, так как это поле только для фронтенд-валидации
    };
    
    try {
      final response = await http.post(
        Uri.parse('$backendUrl/api/users/create/'), // Убедитесь, что это ваш реальный эндпоинт для регистрации
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'Authorization': 'Token $token'
        },
        body: jsonEncode(registrationPayload),
      );

      if (mounted) { // Проверяем, что виджет все еще находится в дереве
        if (response.statusCode == 200 || response.statusCode == 201) {
          print('Registration successful: ${response.body}');
          final responseData = jsonDecode(response.body);
          final String? token = responseData['token'];

          if (token != null) {
          // Save token to SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);

          if (mounted) { // Проверяем, что виджет все еще находится в дереве
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Token saved successfully!')),
          );
          }
          } else {
            throw Exception('Token not found in response');
          }
          
          if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration is done succesfully!')),
          );
          }
          context.go('/main'); // Переходим на главный экран после успешной регистрации
        } else {
          print('Registration failed: ${response.statusCode} - ${response.body}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration Error: ${response.body}')),
          );
        }
      }
    } catch (e) {
      print('Error during registration: $e');
      if (mounted) { // Проверяем, что виджет все еще находится в дереве
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('There is an error during the proccess of registration: $e')),
        );
      }
    }
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
    // В случае, если _steps еще не инициализировались или их длина 0
    // (например, при быстром старте или изменении пола до полной инициализации)
    if (_steps.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Шаг ${_currentStepIndex + 1}/${_steps.length}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          // Кнопка "назад" неактивна на первом шаге
          onPressed: _currentStepIndex > 0 ? _goBack : null,
        ),
      ),
      body: Column(
        children: [
          _buildProgressIndicator(), // Добавляем индикатор прогресса
          Expanded(child: _steps[_currentStepIndex]), // Отображаем текущий шаг
        ],
      ),
    );
  }

  @override
  void dispose() {
    _userData.removeListener(_updateStepsOnGenderChange);
    _userData.dispose(); // Важно для ChangeNotifier
    super.dispose();
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
                  ? Colors.deepPurple // Цвет активного шага
                  : Colors.grey[300], // Цвет неактивного шага
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}