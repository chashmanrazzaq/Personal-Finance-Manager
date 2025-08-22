import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../providers/budget_provider.dart';
import '../models/budget.dart';

class BudgetScreen extends StatefulWidget {
  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final _amountController = TextEditingController();
  String _selectedCategory = "Food";

  final List<String> _categories = [
    "Food",
    "Transport",
    "Entertainment",
    "Bills",
    "Other",
  ];

  @override
  void initState() {
    super.initState();
    Provider.of<BudgetProvider>(context, listen: false).init();
  }

  void _saveBudget() {
    if (_amountController.text.isEmpty) return;
    final enteredAmount = double.tryParse(_amountController.text) ?? 0.0;

    final budget = Budget(category: _selectedCategory, limit: enteredAmount);
    Provider.of<BudgetProvider>(context, listen: false).setBudget(budget);

    _amountController.clear();
    Navigator.of(context).pop();
  }

  void _startAddBudget(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.55,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          builder: (ctx, scrollController) {
            return Container(
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
                controller: scrollController,
                padding: EdgeInsets.only(
                  top: 25,
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      "Add New Budget",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.category,
                          color: Colors.deepPurple,
                        ),
                        filled: true,
                        fillColor: Colors.deepPurple[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      items:
                          _categories
                              .map(
                                (cat) => DropdownMenuItem(
                                  value: cat,
                                  child: Text(cat),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Budget Amount",
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
                        padding: EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        "Save Budget",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: _saveBudget,
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
    final budgetProvider = Provider.of<BudgetProvider>(context);
    final expenseProvider = Provider.of<ExpenseProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Budgets", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Colors.deepPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
        ),
      ),
      body:
          budgetProvider.budgets.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.pie_chart_outline,
                      size: 80,
                      color: Colors.deepPurple[200],
                    ),
                    SizedBox(height: 15),
                    Text(
                      "No Budgets Set Yet",
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: budgetProvider.budgets.length,
                itemBuilder: (ctx, i) {
                  final b = budgetProvider.budgets[i];
                  final spent = expenseProvider.expenses
                      .where((e) => e.category == b.category)
                      .fold(0.0, (sum, e) => sum + e.amount);

                  final progress = (spent / (b.limit == 0 ? 1 : b.limit)).clamp(
                    0.0,
                    1.0,
                  );
                  final isExceeded = spent > b.limit;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(22),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        padding: EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${b.category} Budget",
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
                                  isExceeded ? Colors.red : Colors.green,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Limit: \$${b.limit.toStringAsFixed(2)}",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  "Spent: \$${spent.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    color:
                                        isExceeded ? Colors.red : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            if (isExceeded) ...[
                              SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    Icons.warning,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "Budget Exceeded!",
                                    style: TextStyle(
                                      color: Colors.red,
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
        backgroundColor: Colors.deepPurple,
        elevation: 6,
        child: Icon(Icons.add, size: 30),
        onPressed: () => _startAddBudget(context),
      ),
    );
  }
}
