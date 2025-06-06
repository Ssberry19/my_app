import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/register'),
              child: const Text('Create Account'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => context.go('/login'),
              child: const Text('Log in'),
            ),
          ],
        ),
      ),
    );
  }
}