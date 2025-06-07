// screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Для управления состоянием
import 'package:http/http.dart' as http; // Для HTTP-запросов
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Для доступа к .env переменным
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/profile_data.dart'; // Путь к вашему profile_data.dart
import '../models/user_profile.dart'; // Путь к вашему user_profile.dart

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Загружаем данные профиля при инициализации экрана
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Получаем экземпляр ProfileData через Provider, listen: false, так как мы только изменяем его.
    final profileData = Provider.of<ProfileData>(context, listen: false);

    final baseUrl = dotenv.env['BACKEND_URL'];
    // Предполагаем, что у вас есть эндпоинт для получения профиля пользователя,
    // например, /user/profile или /users/me. Подставьте свой эндпоинт.
    const String endpoint = '/api/users/profile/'; // ИЛИ другой эндпоинт
    final String apiUrl = '$baseUrl$endpoint';

    print('Attempting to fetch profile from: $apiUrl');

    try {
      // Пример получения токена, если он сохранен в SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token'); // Ключ, по которому вы сохраняете токен
      
      // bla bla bla

      // Вам может потребоваться токен аутентификации здесь,
      // если ваш FastAPI эндпоинт защищен (например, 'Authorization': 'Bearer YOUR_AUTH_TOKEN').
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Token $token',
          // Пример, если нужен токен: 'Authorization': 'Bearer ВАШ_ТОКЕН',
        },
      );

      if (response.statusCode == 200) {
        print('Successful profile API response body: ${response.body}');
        final UserProfileResponse userProfileResponse = userProfileResponseFromJson(response.body);
        // Обновляем данные в ProfileData (который является ChangeNotifier)
        profileData.updateUserProfile(userProfileResponse.data);
      } else {
        print('Profile fetch error status code: ${response.statusCode}');
        print('Profile fetch error response body: ${response.body}');
        setState(() {
          _errorMessage =
              'Failed to load profile: ${response.statusCode} - ${response.reasonPhrase}\n${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Could not connect to server to fetch profile: $e';
      });
      print('Network/Connection error fetching profile: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

    // Новая функция для выполнения выхода из системы
  Future<void> _performLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token'); // Удаляем токен аутентификации
    // Возможно, очистите другие данные пользователя, если они хранятся в SharedPreferences

    // Очищаем данные профиля в провайдере
    Provider.of<ProfileData>(context, listen: false).clearUserProfile();

    // Перенаправляем на страницу Welcome
    if (mounted) {
      context.go('/welcome');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    // Подписываемся на изменения в ProfileData с помощью Consumer
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.deepPurple,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Показываем индикатор загрузки
          : _errorMessage != null
              ? Center( // Показываем сообщение об ошибке
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 60),
                        const SizedBox(height: 10),
                        Text(
                          'Loading error: $_errorMessage',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red, fontSize: 16),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _fetchUserProfile, // Кнопка повторной попытки загрузки
                          child: const Text('Retry Loading Profile'),
                        ),
                      ],
                    ),
                  ),
                )
              : Consumer<ProfileData>( // Используем Consumer для доступа к ProfileData
                  builder: (context, profileData, child) {
                    final userProfile = profileData.userProfile;

                    if (userProfile == null) {
                      return const Center(child: Text('Profile data is empty.'));
                    }

                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader(context, 'Personal info'),
                          // Используем оператор ?? для предоставления значения по умолчанию, если поле null
                          _buildProfileRow(context, 'Nickname', userProfile.fullName ?? 'Empty', Icons.person),
                          _buildProfileRow(context, 'Email', userProfile.email ?? 'Empty', Icons.email),
                          _buildProfileRow(context, 'Gender', userProfile.gender ?? 'Empty', Icons.transgender),
                          _buildProfileRow(context, 'Birth Date', userProfile.birthDate?.toIso8601String().split('T').first ?? 'Empty', Icons.calendar_today),
                          _buildProfileRow(context, 'Height', '${userProfile.height ?? 'Empty'} cm', Icons.height),
                          _buildProfileRow(context, 'Weight', '${userProfile.weight ?? 'Empty'} kg', Icons.fitness_center),
                          _buildProfileRow(context, 'Goal Weight', '${userProfile.targetWeight ?? 'Empty'} kg', Icons.flag),
                          
                          const SizedBox(height: 20),
                          _buildSectionHeader(context, 'Additional info'),
                          _buildProfileRow(context, 'Goal', userProfile.goal ?? 'Empty', Icons.track_changes),
                          _buildProfileRow(context, 'Activity level', userProfile.activityLevel ?? 'Empty', Icons.directions_run),
                          
                          // Правильная обработка menstrualCycles:
                          // Проверяем, что пол женский, и что список циклов не null и не пуст.
                          if (userProfile.gender == 'female' && userProfile.menstrualCycles != null && userProfile.menstrualCycles!.isNotEmpty) ...[
                            const SizedBox(height: 20),
                            _buildSectionHeader(context, 'Menstrual Cycles'),
                            // Используем .map для преобразования каждого элемента списка и отображения
                            ...userProfile.menstrualCycles!.map((date) => _buildProfileRow(context, 'Cycle date', date.toIso8601String().split('T').first, Icons.calendar_month)),
                          ] else if (userProfile.gender == 'female') ...[
                             // Если пол женский, но данные о циклах отсутствуют или пусты
                            const SizedBox(height: 20),
                            _buildProfileRow(context, 'Menstrual Cycles', 'Cycle data is empty', Icons.calendar_month),
                          ],

                          const SizedBox(height: 30),
                          _buildListTile(context, 'Edit Profile', Icons.edit, () {
                            // TODO: Реализовать навигацию на экран редактирования профиля
                            print('Edit Profile is tapped');
                          }),
                          _buildListTile(context, 'Edit Password', Icons.lock, () {
                            // TODO: Реализовать навигацию на экран изменения пароля
                            print('Edit Password is tapped');
                          }),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  // Вспомогательные виджеты (адаптированы)
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: Colors.deepPurple[50],
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Theme.of(context).primaryColor),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).iconTheme.color,
      ),
      title: Text(
        label,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      trailing: Text(
        value,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).iconTheme.color,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Theme.of(context).iconTheme.color,
      ),
      onTap: onTap,
    );
  }
}