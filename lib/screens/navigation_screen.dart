import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'expenses_screen.dart';
import 'income_screen.dart';
import 'reports_screen.dart';
import 'goals_screen.dart';
import 'budgets_screen.dart';

class NavigationScreen extends StatefulWidget {
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    DashboardScreen(),
    ExpensesScreen(),
    IncomeScreen(),
    GoalScreen(),
    BudgetScreen(),
    ReportsScreen(),
  ];

  final List<String> _titles = [
    "Dashboard",
    "Expenses",
    "Income",
    "Goals",
    "Budget",
    "Reports",
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          title: Text(
            _titles[_selectedIndex],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              letterSpacing: 1,
            ),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          centerTitle: true,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
          ),
        ),
      ),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade600, Colors.purpleAccent.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 12,
              spreadRadius: 2,
              offset: Offset(0, -3),
            ),
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            selectedItemColor: Colors.tealAccent,
            unselectedItemColor: Colors.white70,
            selectedFontSize: 14,
            unselectedFontSize: 12,
            showUnselectedLabels: true,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: "Dashboard",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.money_off),
                label: "Expenses",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.attach_money),
                label: "Income",
              ),
              BottomNavigationBarItem(icon: Icon(Icons.flag), label: "Goals"),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet),
                label: "Budget",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart),
                label: "Reports",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
