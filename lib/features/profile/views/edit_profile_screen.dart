import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart'; // Для форматирования дат
import 'package:http/http.dart' as http; // Для API запросов
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Для работы с JSON
import '../models/profile_provider.dart'; // Путь к вашему profile_data.dart
import '../models/user_profile.dart'; // Импортируем модель UserProfileData

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Глобальный ключ для формы - нужен для валидации
  final _formKey = GlobalKey<FormState>();

  // Контроллеры для текстовых полей
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _targetWeightController;
  late TextEditingController _cycleLengthController;

  // Переменные для выбранных значений
  ActivityLevel? _selectedActivityLevel;
  FitnessGoal? _selectedGoal;
  DateTime? _selectedLastPeriodDate;

  // Флаг загрузки для кнопки
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Инициализируем контроллеры при создании виджета
    final profileData = Provider.of<ProfileData>(context, listen: false);

    _usernameController = TextEditingController(
      text: profileData.username ?? '',
    );
    _emailController = TextEditingController(text: profileData.email ?? '');
    _heightController = TextEditingController(
      text: profileData.height?.toString() ?? '',
    );
    _weightController = TextEditingController(
      text: profileData.weight?.toString() ?? '',
    );
    _targetWeightController = TextEditingController(
      text: profileData.targetWeight?.toString() ?? '',
    );
    _cycleLengthController = TextEditingController(
      text: profileData.cycleLength?.toString() ?? '',
    );

    // Инициализируем выбранные значения
    _selectedActivityLevel = profileData.activityLevel;
    _selectedGoal = profileData.goal;
    _selectedLastPeriodDate = profileData.lastPeriodDate;
  }

  @override
  void dispose() {
    // Очищаем контроллеры при уничтожении виджета для освобождения памяти
    _usernameController.dispose();
    _emailController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _targetWeightController.dispose();
    _cycleLengthController.dispose();
    super.dispose();
  }

  // Метод для выбора даты последней менструации
  Future<void> _selectLastPeriodDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedLastPeriodDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(
        const Duration(days: 90),
      ), // 3 месяца назад
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedLastPeriodDate) {
      setState(() {
        _selectedLastPeriodDate = picked;
      });
    }
  }

  // Метод для обновления профиля через API
  Future<void> _updateProfile() async {
    final String baseUrl = dotenv.env['BACKEND_URL'] ?? 'http://127.0.0.1:8000';

    // Проверяем валидность формы
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {

        // Пример получения токена, если он сохранен в SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(
        'auth_token',
      ); // Ключ, по которому вы сохраняете токен


      // Получаем провайдер профиля
      final profileData = Provider.of<ProfileData>(context, listen: false);

      // Подготавливаем данные для отправки
      final Map<String, dynamic> requestBody = {
        'username': _usernameController.text,
        'email': _emailController.text,
        'height': double.tryParse(_heightController.text),
        'weight': double.tryParse(_weightController.text),
        'activity_level': _selectedActivityLevel?.toString().split('.').last,
        'target_weight': double.tryParse(_targetWeightController.text),
        'goal': _selectedGoal?.toString().split('.').last,
        'cycle_length': int.tryParse(_cycleLengthController.text),
        'last_period_date': _selectedLastPeriodDate?.toIso8601String(),
      };

      print("body");
      print(jsonEncode(requestBody));

      // Отправляем запрос на сервер
      // ВАЖНО: Замените URL на ваш реальный API endpoint
      final response = await http.post(
        Uri.parse('$baseUrl/api/users/update/'),
        headers: {
          'Content-Type': 'application/json',
          // Добавьте токен авторизации, если необходимо
          'Authorization': 'Token ${token}',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // Успешное обновление
        // Парсим ответ и обновляем локальные данные
        final responseData = jsonDecode(response.body);
        print("response data");
        print(responseData['data']);
        // Обновляем данные в провайдере
        // Предполагается, что сервер возвращает обновленные данные профиля
        if (responseData['data'] != null) {
          profileData.updateUserProfile(
            UserProfileData.fromJson(responseData['data']),
          );
        }

        // Показываем сообщение об успехе
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Профиль успешно обновлен!'),
            backgroundColor: Colors.green,
          ),
        );

        // Возвращаемся на предыдущий экран
        Navigator.pop(context, true);
      } else {
        // Ошибка на сервере
        throw Exception('Ошибка обновления профиля: ${response.statusCode}');
      }
    } catch (e) {
      // Обработка ошибок
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Метод для создания заголовка раздела
  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Получаем данные профиля из провайдера
    final profileData = Provider.of<ProfileData>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // РАЗДЕЛ TRACKING
              _buildSectionHeader('TRACKING'),
              SizedBox(height: 16),

              // Рост
              TextFormField(
                controller: _heightController,
                decoration: const InputDecoration(
                  labelText: 'Height (cm)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.height),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final height = double.tryParse(value);
                    if (height == null || height < 50 || height > 300) {
                      return 'Enter valid height (50-300 cm)';
                    }
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Вес (MAIN)
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(
                  labelText: 'Weight (kg) *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.fitness_center),
                  // helperText: '* Required field',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter weight';
                  }
                  final weight = double.tryParse(value);
                  if (weight == null || weight < 20 || weight > 500) {
                    return 'Enter valid weight (20-500 kg)';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Уровень активности (MAIN)
              DropdownButtonFormField<ActivityLevel>(
                value: _selectedActivityLevel,
                decoration: const InputDecoration(
                  labelText: 'Activity Level *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.directions_run),
                  // helperText: '* Required field',
                ),
                items: ActivityLevel.values.map((level) {
                  String displayText;
                  switch (level) {
                    case ActivityLevel.sedentary:
                      displayText = 'Sedentary';
                      break;
                    case ActivityLevel.light:
                      displayText = 'Light Activity';
                      break;
                    case ActivityLevel.moderate:
                      displayText = 'Moderate Activity';
                      break;
                    case ActivityLevel.active:
                      displayText = 'Active';
                      break;
                    case ActivityLevel.veryActive:
                      displayText = 'Very Active';
                      break;
                  }
                  return DropdownMenuItem(
                    value: level,
                    child: Text(displayText),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedActivityLevel = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select activity level';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Целевой вес
              TextFormField(
                controller: _targetWeightController,
                decoration: const InputDecoration(
                  labelText: 'Target Weight (kg)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.flag),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final weight = double.tryParse(value);
                    if (weight == null || weight < 20 || weight > 500) {
                      return 'Enter valid target weight (20-500 kg)';
                    }
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Цель
              DropdownButtonFormField<FitnessGoal>(
                value: _selectedGoal,
                decoration: const InputDecoration(
                  labelText: 'Fitness Goal',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.track_changes),
                ),
                items: FitnessGoal.values.map((goal) {
                  String displayText;
                  switch (goal) {
                    case FitnessGoal.loseWeight:
                      displayText = 'Lose Weight';
                      break;
                    case FitnessGoal.maintain:
                      displayText = 'Maintain Weight';
                      break;
                    case FitnessGoal.gainWeight:
                      displayText = 'Gain Weight';
                      break;
                    case FitnessGoal.cutting:
                      displayText = 'Cutting';
                      break;
                  }
                  return DropdownMenuItem(
                    value: goal,
                    child: Text(displayText),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGoal = value;
                  });
                },
              ),
              SizedBox(height: 24),

              // РАЗДЕЛ CYCLE (показываем только для женщин)
              if (profileData.gender == Gender.female) ...[
                _buildSectionHeader('CYCLE'),
                SizedBox(height: 16),

                // Длина цикла (MAIN)
                TextFormField(
                  controller: _cycleLengthController,
                  decoration: const InputDecoration(
                    labelText: 'Cycle Length (days) *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.repeat),
                    // helperText: '* Required field',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final length = int.tryParse(value);
                      if (length == null || length < 21 || length > 40) {
                        return 'Enter valid cycle length (21-40 days)';
                      }
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Дата последней менструации (MAIN)
                InkWell(
                  onTap: () => _selectLastPeriodDate(context),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Last Period Date *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_month),
                      // helperText: '* Required field',
                    ),
                    child: Text(
                      _selectedLastPeriodDate != null
                          ? DateFormat(
                              'dd.MM.yyyy',
                            ).format(_selectedLastPeriodDate!)
                          : 'Select date',
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // День цикла (NOT EDITABLE)
                _buildReadOnlyField(
                  'Cycle Day',
                  profileData.cycleDay?.toString() ?? 'Not calculated',
                  Icons.today,
                ),
                SizedBox(height: 16),

                // Фаза менструального цикла (NOT EDITABLE)
                _buildReadOnlyField(
                  'Menstrual Phase',
                  profileData.menstrualPhase ?? 'Not determined',
                  Icons.waves,
                ),
                SizedBox(height: 24),
              ],

              // РАЗДЕЛ PERSONAL
              _buildSectionHeader('PERSONAL'),
              SizedBox(height: 16),

              // Поле имени пользователя
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter username';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Поле email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Пол (NOT EDITABLE)
              _buildReadOnlyField(
                'Gender',
                profileData.gender?.toString().split('.').last ??
                    'Not specified',
                Icons.wc,
              ),
              SizedBox(height: 16),

              // Дата рождения (NOT EDITABLE)
              _buildReadOnlyField(
                'Birth Date',
                profileData.birthDate != null
                    ? DateFormat('dd.MM.yyyy').format(profileData.birthDate!)
                    : 'Not specified',
                Icons.cake,
              ),
              SizedBox(height: 16),

              // Возраст (NOT EDITABLE)
              _buildReadOnlyField(
                'Age',
                profileData.age?.toString() ?? 'Not specified',
                Icons.calendar_today,
              ),
              SizedBox(height: 24),

              // Кнопка сохранения
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _updateProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Вспомогательный метод для создания неизменяемых полей
  Widget _buildReadOnlyField(String label, String value, IconData icon) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
        // Делаем поле визуально отличающимся
        fillColor: Colors.grey[200],
        filled: true,
      ),
      child: Text(value, style: TextStyle(color: Colors.grey[700])),
    );
  }
}
