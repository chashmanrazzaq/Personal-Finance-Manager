import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'providers/expense_provider.dart';
import 'providers/income_provider.dart';
import 'providers/goal_provider.dart';
import 'screens/navigation_screen.dart';
import 'providers/budget_provider.dart';
import 'models/budget.dart';
import 'models/expense.dart';
import 'models/goal.dart';
import 'models/income.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(BudgetAdapter());
  Hive.registerAdapter(ExpenseAdapter());
  Hive.registerAdapter(GoalAdapter());
  Hive.registerAdapter(IncomeAdapter());

  // Boxes open karo
  await Hive.openBox<Expense>('expenses');
  await Hive.openBox<Income>('incomes');
  await Hive.openBox<Goal>('goals');
  await Hive.openBox<Budget>('budgets');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final provider = ExpenseProvider();
            provider.init(); // ✅ data restore hoga
            return provider;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final provider = IncomeProvider();
            provider.init();
            return provider;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final provider = GoalProvider();
            provider.init();
            return provider;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final provider = BudgetProvider();
            provider.init();
            return provider;
          },
        ),
      ],
      child: MaterialApp(
        title: 'Personal Finance Manager',
        theme: ThemeData(primarySwatch: Colors.teal),
        home: NavigationScreen(),
      ),
    );
  }
}
