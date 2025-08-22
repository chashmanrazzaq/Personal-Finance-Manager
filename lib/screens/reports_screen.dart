import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/expense_provider.dart';

class ReportsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);

    // Category totals
    final Map<String, double> categoryTotals = {};
    for (var exp in expenseProvider.expenses) {
      categoryTotals[exp.category] =
          (categoryTotals[exp.category] ?? 0) + exp.amount;
    }

    final total = categoryTotals.values.fold(0.0, (a, b) => a + b);

    final colors = [
      Colors.deepPurpleAccent,
      Colors.teal,
      Colors.orangeAccent,
      Colors.redAccent,
      Colors.blueAccent,
      Colors.greenAccent,
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Reports & Analytics",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            categoryTotals.isEmpty
                ? const Center(
                  child: Text(
                    "No expenses to show",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                )
                : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Pie Chart Card
                      Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                        shadowColor: Colors.deepPurple.withOpacity(0.3),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SizedBox(
                            height: 280,
                            child: PieChart(
                              PieChartData(
                                sections:
                                    categoryTotals.entries
                                        .toList()
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                          final index = entry.key;
                                          final category = entry.value.key;
                                          final amount = entry.value.value;
                                          final percentage =
                                              (amount / total) * 100;

                                          return PieChartSectionData(
                                            value: amount,
                                            color:
                                                colors[index % colors.length],
                                            radius: 80,
                                            title:
                                                "${percentage.toStringAsFixed(1)}%",
                                            titleStyle: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          );
                                        })
                                        .toList(),
                                centerSpaceRadius: 50,
                                sectionsSpace: 4,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Category Breakdown Card
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        shadowColor: Colors.deepPurple.withOpacity(0.2),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:
                                categoryTotals.entries
                                    .toList()
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                      final index = entry.key;
                                      final category = entry.value.key;
                                      final amount = entry.value.value;
                                      final percentage = (amount / total) * 100;

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8.0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 8,
                                                  backgroundColor:
                                                      colors[index %
                                                          colors.length],
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  category,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              "\$${amount.toStringAsFixed(2)} (${percentage.toStringAsFixed(1)}%)",
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    })
                                    .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
