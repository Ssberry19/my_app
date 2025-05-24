import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'features/profile/views/profile_screen.dart';
import 'features/diet/views/diet_screen.dart';
import 'features/tracker/views/tracker_screen.dart';
import 'features/workouts/views/workouts_screen.dart';
import 'features/home/views/home_screen.dart';
import 'main_screen.dart';
import 'features/auth/views/registration_flow.dart';
import 'features/auth/views/welcome_screen.dart';

void main() => runApp(const MyApp());

final _router = GoRouter(
  initialLocation: '/welcome',
  routes: [
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
      routes: [
        GoRoute(
          path: 'register',
          builder: (context, state) => const RegistrationFlow(),
        ),
        ShellRoute(
          builder: (context, state, child) => MainScreen(child: child),
          routes: [
            GoRoute(
              path: 'main',
              redirect: (context, state) => '/main/home',
              routes: [
                GoRoute(
                  path: 'home',
                  pageBuilder: (context, state) => 
                    const MaterialPage(child: HomeScreen()),
                ),
                GoRoute(
                  path: 'diet',
                  pageBuilder: (context, state) => 
                    const MaterialPage(child: DietScreen()),
                ),
                GoRoute(
                  path: 'tracker',
                  pageBuilder: (context, state) => 
                    const MaterialPage(child: TrackerScreen()),
                ),
                GoRoute(
                  path: 'workouts',
                  pageBuilder: (context, state) => 
                    const MaterialPage(child: WorkoutsScreen()),
                ),
                GoRoute(
                  path: 'profile',
                  pageBuilder: (context, state) => 
                    const MaterialPage(child: ProfileScreen()),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Fitness App',
      theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(fontFamily: 'Roboto'),
          ),
        ),
      debugShowCheckedModeBanner: false,
    );
  }
}