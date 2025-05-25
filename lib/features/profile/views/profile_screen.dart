import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Import go_router

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE6E6FA), // Лавандовый
              Color(0xFFD8BFD8), // Тёмно-лавандовый
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildAccountSection(),
              const SizedBox(height: 20),
              _buildDietSection(),
              const SizedBox(height: 20),
              _buildSettingsSection(context), // Pass context to settings section
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountSection() {
    return _buildSectionCard(
      title: 'Аккаунт',
      children: [
        _buildProfileRow('Имя', 'Соня', Icons.person),
        _buildProfileRow('Возраст', '21', Icons.cake),
        _buildProfileRow('Пол', 'Женщина', Icons.transgender),
        _buildProfileRow('Рост', '170 cm', Icons.height),
        _buildProfileRow('Вес', '71 kg', Icons.monitor_weight),
      ],
    );
  }

  Widget _buildDietSection() {
    return _buildSectionCard(
      title: 'Диета',
      children: [
        _buildProfileRow('Цель', 'Похудение', Icons.flag),
        _buildProfileRow('Уровень активности', 'Легкая активность', Icons.directions_run),
        _buildProfileRow('Ограничения', 'Религиозные ограничения', Icons.warning),
      ],
    );
  }

  // Modified to accept BuildContext
  Widget _buildSettingsSection(BuildContext context) {
    return _buildSectionCard(
      title: 'Настройки',
      children: [
        _buildListTile('О нас', Icons.info, () => context.go('/welcome')), // Redirect to /welcome
        _buildListTile('Оцените нас', Icons.star, () {}),
        _buildListTile('Свяжитесь с нами', Icons.mail, () {}),
        _buildListTile('Управление подписками', Icons.subscriptions, () {}),
        _buildListTile('Условия использования', Icons.description, () {}),
        _buildListTile('Политика конфиденциальности', Icons.security, () {}),
      ],
    );
  }

  Widget _buildSectionCard({required String title, required List<Widget> children}) {
    return Card(
      // ignore: deprecated_member_use
      color: Colors.white.withOpacity(0.9),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple[800],
              ),
            ),
            const Divider(color: Colors.deepPurple),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildProfileRow(String label, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(label, style: TextStyle(color: Colors.grey[700])),
      trailing: Text(value, style: TextStyle(
        color: Colors.deepPurple[800],
        fontWeight: FontWeight.w500,
      )),
    );
  }

  // Modified to accept a void callback for onTap
  Widget _buildListTile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(title, style: TextStyle(color: Colors.grey[700])),
      trailing: Icon(Icons.arrow_forward_ios,
        size: 16,
        color: Colors.deepPurple[300]
      ),
      onTap: onTap, // Assign the passed onTap callback
    );
  }
}