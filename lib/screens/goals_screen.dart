import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/goal.dart';
import '../providers/goal_provider.dart';

class GoalScreen extends StatefulWidget {
  @override
  _GoalScreenState createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  final _titleController = TextEditingController();
  final _targetController = TextEditingController();

  // Add goal function
  void _addGoal(BuildContext context) {
    if (_titleController.text.isEmpty || _targetController.text.isEmpty) return;

    final newGoal = Goal(
      id: Random().nextInt(10000).toString(),
      title: _titleController.text,
      targetAmount: double.tryParse(_targetController.text) ?? 0.0,
      currentAmount: 0,
    );

    Provider.of<GoalProvider>(context, listen: false).addGoal(newGoal);

    _titleController.clear();
    _targetController.clear();

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Goal added successfully! 🎯"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Open bottom sheet form
  void _startAddGoal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (_, controller) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    spreadRadius: 2,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                controller: controller,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 60,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple[200],
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Add New Goal",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: "Goal Title",
                        prefixIcon: Icon(Icons.flag, color: Colors.deepPurple),
                        filled: true,
                        fillColor: Colors.deepPurple[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: _targetController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Target Amount",
                        prefixIcon: Icon(
                          Icons.attach_money,
                          color: Colors.deepPurple,
                        ),
                        filled: true,
                        fillColor: Colors.deepPurple[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 40,
                        ),
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        "Add Goal",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      onPressed: () => _addGoal(context),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final goalProvider = Provider.of<GoalProvider>(context);
    final goals = goalProvider.goals;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("My Goals", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Colors.deepPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
        ),
      ),
      body:
          goals.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.flag_outlined,
                      size: 80,
                      color: Colors.deepPurple[200],
                    ),
                    SizedBox(height: 15),
                    Text(
                      "No goals added yet! 🎯",
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                itemCount: goals.length,
                itemBuilder: (ctx, i) {
                  final goal = goals[i];
                  final progress = (goal.currentAmount /
                          (goal.targetAmount == 0 ? 1 : goal.targetAmount))
                      .clamp(0.0, 1.0);
                  final isCompleted = goal.currentAmount >= goal.targetAmount;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              goal.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                            SizedBox(height: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 14,
                                backgroundColor: Colors.grey[300],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  isCompleted
                                      ? Colors.green
                                      : Colors.deepPurple,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Target: \$${goal.targetAmount.toStringAsFixed(2)}",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  "Saved: \$${goal.currentAmount.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    color:
                                        isCompleted
                                            ? Colors.green
                                            : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            if (isCompleted) ...[
                              SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    Icons.emoji_events,
                                    color: Colors.green,
                                    size: 20,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "Goal Achieved! 🎯",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _startAddGoal(context),
        child: Icon(Icons.add, size: 28),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}
