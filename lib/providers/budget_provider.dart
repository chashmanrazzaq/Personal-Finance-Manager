import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/budget.dart';

class BudgetProvider with ChangeNotifier {
  List<Budget> _budgets = [];
  Box<Budget>? _budgetBox;

  List<Budget> get budgets => _budgets;

  Future<void> init() async {
    _budgetBox = await Hive.openBox<Budget>('budgets');
    _budgets = _budgetBox!.values.toList();
    notifyListeners();
  }

  void setBudget(Budget budget) {
    final idx = _budgets.indexWhere((b) => b.category == budget.category);
    if (idx != -1) {
      _budgets[idx] = budget;
      _budgetBox!.putAt(idx, budget); // ✅ fixed
    } else {
      _budgets.add(budget);
      _budgetBox!.add(budget); // ✅ fixed
    }
    notifyListeners();
  }

  double getBudgetLimit(String category) {
    final budget = _budgets.firstWhere(
      (b) => b.category == category,
      orElse: () => Budget(category: category, limit: 0.0),
    );
    return budget.limit;
  }
}
