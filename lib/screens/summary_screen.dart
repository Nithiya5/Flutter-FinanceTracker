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

  List<Transaction> getRecentTransactions() {
    transactions.sort((a, b) => b.date.compareTo(a.date));
    return transactions.take(5).toList(); // show last 5
  }

  @override
  Widget build(BuildContext context) {
    final totalIncome = getTotalIncome();
    final totalExpense = getTotalExpense();
    final balance = totalIncome - totalExpense;

    return Scaffold(
      appBar: AppBar(
        title: Text("Monthly Summary"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Balance Overview Cards
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'Income',
                    amount: totalIncome,
                    icon: Icons.arrow_downward,
                    color: Colors.green,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    title: 'Expense',
                    amount: totalExpense,
                    icon: Icons.arrow_upward,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            StatCard(
              title: 'Balance',
              amount: balance,
              icon: Icons.account_balance_wallet,
              color: balance >= 0 ? Colors.teal : Colors.red,
            ),
            SizedBox(height: 30),

            // Recent Transactions Section
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Recent Transactions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 12),
            ...getRecentTransactions().map((tx) => RecentTransactionTile(tx)),
          ],
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final double amount;
  final IconData icon;
  final Color color;

  const StatCard({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color.withOpacity(0.8), color.withOpacity(0.5)]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.2), blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 30),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(color: Colors.white70, fontSize: 14)),
              Text(
                '₹${amount.toStringAsFixed(2)}',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RecentTransactionTile extends StatelessWidget {
  final Transaction transaction;

  const RecentTransactionTile(this.transaction);

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isIncome ? Colors.green : Colors.red,
          child: Icon(isIncome ? Icons.arrow_downward : Icons.arrow_upward, color: Colors.white),
        ),
        title: Text(transaction.title),
        subtitle: Text(
          '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
          style: TextStyle(fontSize: 12),
        ),
        trailing: Text(
          '₹${transaction.amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isIncome ? Colors.green : Colors.red,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
