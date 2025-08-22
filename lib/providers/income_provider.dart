import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/income.dart';

class IncomeProvider with ChangeNotifier {
  static const String _boxName = "incomesBox";
  List<Income> _incomes = [];

  List<Income> get incomes => _incomes;

  IncomeProvider() {
    loadIncomes();
  }

  Future<void> init() async {
    await loadIncomes(); // ✅ ab init available hai
  }

  Future<void> loadIncomes() async {
    final box = await Hive.openBox<Income>(_boxName);
    _incomes = box.values.toList();
    notifyListeners();
  }

  Future<void> addIncome(Income income) async {
    final box = await Hive.openBox<Income>(_boxName);
    await box.put(income.id, income);
    _incomes = box.values.toList();
    notifyListeners();
  }

  Future<void> deleteIncome(String id) async {
    final box = await Hive.openBox<Income>(_boxName);
    await box.delete(id);
    _incomes = box.values.toList();
    notifyListeners();
  }

  Future<void> updateIncome(String id, Income updatedIncome) async {
    final box = await Hive.openBox<Income>(_boxName);
    await box.put(id, updatedIncome);
    _incomes = box.values.toList();
    notifyListeners();
  }

  double get totalIncome {
    return _incomes.fold(0.0, (sum, item) => sum + item.amount);
  }
}
