import 'package:flutter/material.dart';
import '../models/goal.dart';

class GoalCard extends StatelessWidget {
  final Goal goal;
  final VoidCallback onDelete;

  const GoalCard({super.key, required this.goal, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    double progress = (goal.currentAmount / goal.targetAmount).clamp(0.0, 1.0);

    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              goal.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              color: Colors.green,
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(height: 8),
            Text("Saved: ${goal.currentAmount} / ${goal.targetAmount}"),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
