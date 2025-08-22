import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../providers/expense_provider.dart';
import 'dart:math';
import '../widgets/expense_tile.dart';

class ExpensesScreen extends StatefulWidget {
  @override
  _ExpensesScreenState createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedCategory = "Food";
  String? _editingId;

  final List<String> _categories = [
    "Food",
    "Transport",
    "Entertainment",
    "Bills",
    "Other",
  ];

  void _submitForm() {
    if (_titleController.text.isEmpty || _amountController.text.isEmpty) return;

    final enteredTitle = _titleController.text;
    final enteredAmount = double.tryParse(_amountController.text) ?? 0.0;

    if (_editingId == null) {
      final newExpense = Expense(
        id: Random().nextInt(10000).toString(),
        title: enteredTitle,
        amount: enteredAmount,
        category: _selectedCategory,
        date: DateTime.now(),
      );
      Provider.of<ExpenseProvider>(
        context,
        listen: false,
      ).addExpense(newExpense);
    } else {
      Provider.of<ExpenseProvider>(context, listen: false).editExpense(
        _editingId!,
        enteredTitle,
        enteredAmount,
        _selectedCategory,
      );
    }

    _titleController.clear();
    _amountController.clear();
    _editingId = null;
    Navigator.of(context).pop();
  }

  void _startAddExpense(BuildContext context, [Expense? expense]) {
    if (expense != null) {
      _editingId = expense.id;
      _titleController.text = expense.title;
      _amountController.text = expense.amount.toString();
      _selectedCategory = expense.category;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.only(
                top: 25,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                controller: scrollController,
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
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: "Title",
                        prefixIcon: Icon(Icons.title, color: Colors.deepPurple),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        filled: true,
                        fillColor: Colors.deepPurple[50],
                      ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Amount",
                        prefixIcon: Icon(
                          Icons.attach_money,
                          color: Colors.deepPurple,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        filled: true,
                        fillColor: Colors.deepPurple[50],
                      ),
                    ),
                    SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.category,
                          color: Colors.deepPurple,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        filled: true,
                        fillColor: Colors.deepPurple[50],
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
                    SizedBox(height: 25),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 50,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor:
                            _editingId == null
                                ? Colors.deepPurple
                                : Colors.blueAccent,
                        elevation: 5,
                      ),
                      child: Text(
                        _editingId == null ? "Add Expense" : "Update Expense",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      onPressed: _submitForm,
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
    final expenseProvider = Provider.of<ExpenseProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Expenses"),
        backgroundColor: Colors.deepPurple,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
        ),
      ),
      body:
          expenseProvider.expenses.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.wallet_outlined,
                      size: 80,
                      color: Colors.deepPurple[200],
                    ),
                    SizedBox(height: 15),
                    Text(
                      "No Expenses Added Yet",
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                itemCount: expenseProvider.expenses.length,
                itemBuilder: (ctx, i) {
                  final exp = expenseProvider.expenses[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(20),
                      child: ExpenseTile(
                        expense: exp,
                        onEdit: () => _startAddExpense(context, exp),
                        onDelete:
                            () => Provider.of<ExpenseProvider>(
                              context,
                              listen: false,
                            ).deleteExpense(exp.id),
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add, size: 30),
        onPressed: () => _startAddExpense(context),
      ),
    );
  }
}
