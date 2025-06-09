// main_screen.dart
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart'; // Импортируем provider
import 'features/profile/views/profile_screen.dart';
import 'features/diet/views/diet_screen.dart';
import 'features/tracker/views/tracker_screen.dart';
import 'features/workouts/views/workouts_screen.dart';
import 'features/home/views/home_screen.dart';
// import 'features/diet/models/diet_plan_provider.dart'; // Импортируем DietPlanProvider
// import 'features/workouts/models/workout_plan_provider.dart';

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
  void initState() {
    super.initState();
    // Откладываем вызов fetchDietPlan на следующий кадр
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Provider.of<DietPlanProvider>(context, listen: false).fetchDietPlan(context);
    //   Provider.of<WorkoutPlanProvider>(context, listen: false).fetchWorkoutPlan(context);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: 'Diet'),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Tracker',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Workouts',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}