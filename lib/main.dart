import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'main_screen.dart';
import 'features/auth/views/registration_flow.dart';
import 'features/auth/views/welcome_screen.dart';
import 'core/theme/theme.dart';

void main() => runApp(const MyApp());

final _router = GoRouter(
  initialLocation: '/welcome', // Стартуем с Welcome Screen
  routes: [
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegistrationFlow(),
    ),
    GoRoute(
      path: '/main',
      builder: (context, state) => const MainScreen(),
    ),
    // ... другие экраны
  ],
  errorBuilder: (context, state) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('GoException: ${state.error.toString()}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.go('/welcome'); // Переходим на страницу Welcome
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