// main.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'main_screen.dart';
import 'features/auth/views/registration_flow.dart';
import 'features/auth/views/welcome_screen.dart';
import 'features/auth/views/login_screen.dart';
import 'features/profile/models/profile_provider.dart';
import 'core/theme/theme.dart';
import 'features/diet/models/diet_plan_provider.dart';
import 'features/workouts/models/workout_plan_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider( // Используем MultiProvider для нескольких провайдеров
      providers: [
        ChangeNotifierProvider(create: (context) => ProfileData()),
        ChangeNotifierProvider(create: (context) => DietPlanProvider()), // Добавляем DietPlanProvider
        ChangeNotifierProvider(create: (context) => WorkoutPlanProvider()), 
      ],
      child: const MyApp(),
    ),
  );
}

final _router = GoRouter(
  initialLocation: '/welcome', // Изменил на /welcome для примера
  routes: [
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegistrationFlow(),
    ),
    GoRoute(path: '/main', builder: (context, state) => const MainScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
  ],
  errorBuilder: (context, state) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page Not Found'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'GoException: ${state.error.toString()}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.go('/welcome');
              },
              child: const Text('Home'),
            ),
          ],
        ),
      ),
    );
  },
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Fitness App',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}