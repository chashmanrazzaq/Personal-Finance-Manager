import 'package:flutter/material.dart';
import '../models/income.dart';

class IncomeTile extends StatelessWidget {
  final Income income;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const IncomeTile({
    super.key,
    required this.income,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        leading: const Icon(Icons.attach_money, color: Colors.green),
        title: Text(
          income.source,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "${income.amount} - ${income.date.toLocal().toString().split(' ')[0]}",
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
