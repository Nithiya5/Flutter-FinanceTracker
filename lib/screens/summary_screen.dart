import 'package:flutter/material.dart'; 
 import '../models/transaction.dart'; 

class SummaryScreen extends StatelessWidget {
  final List<Transaction> transactions;

  SummaryScreen({required this.transactions});

  double getTotalIncome() {
    return transactions
        .where((tx) => tx.type == TransactionType.income)
        .fold(0.0, (sum, tx) => sum + tx.amount);
  }

  double getTotalExpense() {
    return transactions
        .where((tx) => tx.type == TransactionType.expense)
        .fold(0.0, (sum, tx) => sum + tx.amount);
  }

  @override
  Widget build(BuildContext context) {
    final totalIncome = getTotalIncome();
    final totalExpense = getTotalExpense();

    return Scaffold(
      appBar: AppBar(
        title: Text('Monthly Summary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Monthly Summary',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Total Income: ₹${totalIncome.toStringAsFixed(2)}'),
            Text('Total Expense: ₹${totalExpense.toStringAsFixed(2)}'),
            SizedBox(height: 20),
            Text(
              'Remaining Balance: ₹${(totalIncome - totalExpense).toStringAsFixed(2)}',
              style: TextStyle(
                  color: (totalIncome - totalExpense) >= 0 ? Colors.green : Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
