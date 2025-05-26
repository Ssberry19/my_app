import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'main_screen.dart';
import 'features/auth/views/registration_flow.dart';
import 'features/auth/views/welcome_screen.dart';
import 'features/auth/views/login_screen.dart';
import 'core/theme/theme.dart'; // Убедитесь, что это правильный путь к вашему theme.dart

void main() => runApp(const MyApp());

final _router = GoRouter(
  initialLocation: '/main', // Стартуем с MainScreen
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
    // ... другие экраны
  ],
  errorBuilder: (context, state) {
    // Используем Scaffold, AppBar и ElevatedButton из темы
    return Scaffold(
      appBar: AppBar(
        // Стиль AppBar берется из темы
        title: Text(
          'Page Not Found',
          // Не нужно устанавливать style: TextStyle(color: Colors.white) здесь,
          // так как titleTextStyle уже определен в theme.dart
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'GoException: ${state.error.toString()}',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge, // Используем стиль из темы
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              // Стиль ElevatedButton берется из темы
              onPressed: () {
                context.go('/welcome'); // Переходим на страницу Welcome
              },
              child: const Text(
                'Home',
              ), // Текст кнопки стилизуется из theme.dart
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
      theme: appTheme, // <-- Здесь применяется ваша тема
      debugShowCheckedModeBanner: false,
    );
  }
}
