import 'package:flutter/material.dart';
import 'features/profile/views/profile_screen.dart';
import 'features/diet/views/diet_screen.dart';
import 'features/tracker/views/tracker_screen.dart';
import 'features/workouts/views/workouts_screen.dart';
import 'features/home/views/home_screen.dart';

// Экран с нижней навигацией
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final _screens = [
    const HomeScreen(),
    const DietScreen(),
    const TrackerScreen(),
    const WorkoutPlanPage(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        // Убраны selectedItemColor и unselectedItemColor,
        // чтобы они брались из BottomNavigationBarThemeData в theme.dart
        // selectedItemColor: Colors.deepPurple, // Удалить эту строку
        // unselectedItemColor: Colors.blueGrey, // Удалить эту строку
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Диета',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Трекер',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Тренировки',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}