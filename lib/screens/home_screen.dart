

import 'package:flutter/material.dart';
import '../widgets/transaction_form.dart';
import '../widgets/transaction_list.dart'; // ✅ Import this
import '../models/transaction.dart';
import '../auth_helper.dart';
import 'login_screen.dart';
import 'summary_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Transaction> _userTransactions = [];
  bool _isBalanceVisible = false;

  void _addTransaction(Transaction transaction) {
    setState(() {
      _userTransactions.add(transaction);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  void _navigateToSummaryScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SummaryScreen(transactions: _userTransactions),
      ),
    );
  }

  Future<void> _logout() async {
    await logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  double get totalIncome {
    return _userTransactions
        .where((tx) => tx.type == TransactionType.income)
        .fold(0.0, (sum, tx) => sum + tx.amount);
  }

  double get totalExpense {
    return _userTransactions
        .where((tx) => tx.type == TransactionType.expense)
        .fold(0.0, (sum, tx) => sum + tx.amount);
  }

  double get remainingBalance => totalIncome - totalExpense;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Finance Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
          IconButton(
            icon: Icon(Icons.bar_chart),
            onPressed: _navigateToSummaryScreen,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Toggle Button Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    _isBalanceVisible ? Icons.visibility_off : Icons.visibility,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    setState(() {
                      _isBalanceVisible = !_isBalanceVisible;
                    });
                  },
                ),
                Text(
                  _isBalanceVisible
                      ? "Hide Financial Summary"
                      : "Show Financial Summary",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),

            // Conditionally show card
            if (_isBalanceVisible)
              Card(
                margin: const EdgeInsets.all(12),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text("Total Income: ₹${totalIncome.toStringAsFixed(2)}",
                          style:
                              TextStyle(color: Colors.green, fontSize: 16)),
                      Text("Total Expense: ₹${totalExpense.toStringAsFixed(2)}",
                          style: TextStyle(color: Colors.red, fontSize: 16)),
                      Divider(),
                      Text(
                        "Remaining Balance: ₹${remainingBalance.toStringAsFixed(2)}",
                        style: TextStyle(
                          color: remainingBalance >= 0
                              ? Colors.blue
                              : Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Add transaction form
            TransactionForm(onSubmit: _addTransaction),

            // ✅ List of added transactions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                height: 400, // Adjust based on your needs
                child: TransactionList(
                  transactions: _userTransactions,
                  onDelete: _deleteTransaction,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
