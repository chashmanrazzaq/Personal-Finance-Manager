import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/goal.dart';

class GoalProvider with ChangeNotifier {
  List<Goal> _goals = [];
  Box<Goal>? _goalBox;

  List<Goal> get goals => _goals;

  Future<void> init() async {
    _goalBox = await Hive.openBox<Goal>('goals');
    _goals = _goalBox!.values.toList();
    notifyListeners();
  }

  void addGoal(Goal goal) {
    _goals.add(goal);
    _goalBox!.add(goal);
    notifyListeners();
  }

  void updateGoal(String id, double saved) {
    final idx = _goals.indexWhere((g) => g.id == id);
    if (idx != -1) {
      _goals[idx].savedAmount += saved;
      _goalBox!.putAt(idx, _goals[idx]); // ✅ Hive update
      notifyListeners();
    }
  }

  void deleteGoal(String id) {
    final idx = _goals.indexWhere((g) => g.id == id);
    if (idx != -1) {
      _goalBox!.deleteAt(idx); // ✅ Hive se delete
      _goals.removeAt(idx);
      notifyListeners();
    }
  }
}
