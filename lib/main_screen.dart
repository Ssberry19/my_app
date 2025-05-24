import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatelessWidget {
  final Widget child;
  const MainScreen({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final String location = GoRouter.of(context).location;

    int currentIndex = 0;
    switch (location) {
      case '/main/home':
        currentIndex = 0;
        break;
      case '/main/diet':
        currentIndex = 1;
        break;
      case '/main/tracker':
        currentIndex = 2;
        break;
      case '/main/workouts':
        currentIndex = 3;
        break;
      case '/main/profile':
        currentIndex = 4;
        break;
    }

    return Scaffold(
      body: child, // Используем переданный child
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => _onItemTapped(index, context),
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.blueGrey,
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

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/main/home');
        break;
      case 1:
        context.go('/main/diet');
        break;
      case 2:
        context.go('/main/tracker');
        break;
      case 3:
        context.go('/main/workouts');
        break;
      case 4:
        context.go('/main/profile');
        break;
    }
  }
}