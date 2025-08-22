import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/income.dart';
import '../providers/income_provider.dart';

class IncomeScreen extends StatefulWidget {
  @override
  _IncomeScreenState createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  final _sourceController = TextEditingController();
  final _amountController = TextEditingController();

  void _submitForm([String? existingId]) async {
    if (_sourceController.text.isEmpty || _amountController.text.isEmpty)
      return;

    final newIncome = Income(
      id: existingId ?? Random().nextInt(10000).toString(),
      source: _sourceController.text,
      amount: double.tryParse(_amountController.text) ?? 0.0,
      date: DateTime.now(),
    );

    if (existingId == null) {
      await Provider.of<IncomeProvider>(
        context,
        listen: false,
      ).addIncome(newIncome);
    } else {
      await Provider.of<IncomeProvider>(
        context,
        listen: false,
      ).updateIncome(existingId, newIncome);
    }

    _sourceController.clear();
    _amountController.clear();

    Navigator.of(context).pop();
  }

  void _startAddIncome(BuildContext context, [Income? income]) {
    if (income != null) {
      _sourceController.text = income.source;
      _amountController.text = income.amount.toString();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.55,
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
                      income == null ? "Add Income" : "Update Income",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _sourceController,
                      decoration: InputDecoration(
                        labelText: "Income Source",
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
                    SizedBox(height: 15),
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Amount",
                        prefixIcon: Icon(Icons.money, color: Colors.deepPurple),
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
                        income == null ? "Add Income" : "Update Income",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      onPressed: () => _submitForm(income?.id),
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
    final incomeProvider = Provider.of<IncomeProvider>(context);
    final incomes = incomeProvider.incomes;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          "Income Tracker",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Colors.deepPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
        ),
      ),
      body:
          incomes.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 80,
                      color: Colors.deepPurple[200],
                    ),
                    SizedBox(height: 15),
                    Text(
                      "No income added yet!",
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                itemCount: incomes.length,
                itemBuilder: (ctx, i) {
                  final inc = incomes[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(22),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.purple.shade200,
                              Colors.deepPurple.shade400,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        padding: EdgeInsets.all(18),
                        child: ListTile(
                          title: Text(
                            inc.source,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text(
                            "${inc.date.toLocal().toString().split(' ')[0]}",
                            style: TextStyle(color: Colors.white70),
                          ),
                          trailing: Text(
                            "\$${inc.amount.toStringAsFixed(2)}",
                            style: TextStyle(
                              color: Colors.greenAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          onTap: () => _startAddIncome(context, inc),
                        ),
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add, size: 28),
        onPressed: () => _startAddIncome(context),
      ),
    );
  }
}
