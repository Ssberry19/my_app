import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Import go_router

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'), // Стиль берется из темы
        // backgroundColor: Colors.deepPurple, // Удаляем
        // elevation: 0, // Удаляем
      ),
      // Убираем Container с градиентом
      // body: Container(
      //   decoration: const BoxDecoration(
      //     gradient: LinearGradient(
      //       begin: Alignment.topCenter,
      //       end: Alignment.bottomCenter,
      //       colors: [
      //         Color(0xFFE6E6FA), // Лавандовый
      //         Color(0xFFD8BFD8), // Тёмно-лавандовый
      //       ],
      //     ),
      //   ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildAccountSection(context), // Передаем context
            const SizedBox(height: 20),
            _buildDietSection(context), // Передаем context
            const SizedBox(height: 20),
            _buildSettingsSection(context), // Pass context to settings section
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement logout logic
                context.go('/welcome'); // Example navigation to WelcomeScreen
              },
              // Стиль берется из ElevatedButtonThemeData в theme.dart
              child: const Text('Log out'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    return _buildSectionCard(
      context,
      title: 'Account',
      children: [
        _buildProfileRow(
          context,
          'Username',
          'tami_insa',
          Icons.account_circle,
        ), // Иконка человека/аккаунта
        _buildProfileRow(
          context,
          'Email',
          'tahinii@mail.ru',
          Icons.email,
        ), // Иконка конверта
        _buildProfileRow(
          context,
          'Date of Birth',
          '30/10/2003',
          Icons.calendar_today,
        ), // Иконка календаря
        _buildProfileRow(
          context,
          'Gender',
          'Female',
          Icons.wc,
        ), // Иконка мужского/женского туалета (или generic 'person_2' если wc не подходит)
        _buildProfileRow(context, 'Weight', '75', Icons.scale), // Иконка весов
        _buildProfileRow(
          context,
          'Height',
          '175',
          Icons.height,
        ), // Иконка роста/линейки
        _buildProfileRow(
          context,
          'Activity Level',
          'Sedentary',
          Icons.directions_run,
        ), // Иконка бегущего человека
        _buildProfileRow(
          context,
          'Goal Weight',
          '65',
          Icons.track_changes,
        ), // Иконка цели/мишени
      ],
    );
  }

  Widget _buildDietSection(BuildContext context) {
    return _buildSectionCard(
      context,
      title: 'Diet',
      children: [
        _buildProfileRow(context, 'Goal', 'Weigh Loss', Icons.flag),
        _buildProfileRow(
          context,
          'Daily calories',
          '2056 kcal',
          Icons.local_fire_department,
        ),
        _buildProfileRow(
          context,
          'Restrictions/Allergies',
          'none',
          Icons.restaurant,
        ),
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return _buildSectionCard(
      context,
      title: 'Settings',
      children: [
        _buildListTile(context, 'Notifications', Icons.notifications, () {
          // TODO: Navigate to notification settings
        }),
        _buildListTile(context, 'Language', Icons.language, () {
          // TODO: Change language
        }),
        _buildListTile(context, 'Support', Icons.help_outline, () {
          // TODO: Open help section
        }),
      ],
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    // Card автоматически возьмет стиль из theme.dart
    return Card(
      // color: Colors.white.withOpacity(0.9), // Удаляем, берется из темы
      // elevation: 4, // Удаляем, берется из темы
      // shape: RoundedRectangleBorder( // Удаляем, берется из темы
      //   borderRadius: BorderRadius.circular(15),
      // ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge, // Использование стиля из темы
            ),
            const Divider(color: Colors.deepPurple), // Цвет из темы
            ...children,
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
      ), // Цвет иконки из темы
      title: Text(
        label,
        style: Theme.of(context).textTheme.bodyLarge,
      ), // Стиль из темы
      trailing: Text(
        value,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: Theme.of(context).primaryColor, // Цвет из темы
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // Modified to accept a void callback for onTap
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
      ), // Цвет иконки из темы
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge,
      ), // Стиль из темы
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Theme.of(context).iconTheme.color,
      ), // Цвет иконки из темы
      onTap: onTap,
    );
  }
}
