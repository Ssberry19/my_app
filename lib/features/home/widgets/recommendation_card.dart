import 'package:flutter/material.dart';

class RecommendationCard extends StatelessWidget {
  final String text;
  final String emoji;

  const RecommendationCard({
    super.key,
    required this.text,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 16),
            Expanded(child: Text(text)),
          ],
        ),
      ),
    );
  }
} 
