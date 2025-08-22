import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/expense.dart';

class ExpenseProvider with ChangeNotifier {
  List<Expense> _expenses = [];
  Box<Expense>? _expenseBox;

  List<Expense> get expenses => _expenses;

  /// Init hive
  Future<void> init() async {
    _expenseBox = Hive.box<Expense>('expenses');
    _expenses = _expenseBox!.values.toList();
    notifyListeners();
  }

  /// Add new expense
  Future<void> addExpense(Expense expense) async {
    await _expenseBox!.put(expense.id, expense); // ✅ id ko key banaya
    _expenses.add(expense);
    notifyListeners();
  }

  /// Delete expense
  Future<void> deleteExpense(String id) async {
    await _expenseBox!.delete(id); // ✅ id se delete
    _expenses.removeWhere((exp) => exp.id == id);
    notifyListeners();
  }

  /// Edit expense
  Future<void> editExpense(
    String id,
    String title,
    double amount,
    String category,
  ) async {
    final idx = _expenses.indexWhere((exp) => exp.id == id);
    if (idx != -1) {
      final updated = Expense(
        id: id,
        title: title,
        amount: amount,
        category: category,
        date: DateTime.now(),
      );
      await _expenseBox!.put(id, updated); // ✅ update by id
      _expenses[idx] = updated;
      notifyListeners();
    }
  }

  double get totalExpense {
    return _expenses.fold(0.0, (sum, item) => sum + item.amount);
  }
}
