import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/transaction.dart';

class TransactionForm extends StatefulWidget {
  final Function(Transaction) onSubmit;

  TransactionForm({required this.onSubmit});

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _uuid = Uuid();

  TransactionType _selectedType = TransactionType.expense;
  String _selectedCategory = 'Food';

  final List<String> _categories = [
    'Food',
    'Travel',
    'Shopping',
    'Bills',
    'Entertainment',
    'Other',
  ];

  void _submitData() {
    try {
      final enteredTitle = _titleController.text.trim();
      final enteredAmount = double.parse(_amountController.text);

      if (enteredTitle.isEmpty || enteredAmount <= 0) return;

      final newTx = Transaction(
        id: _uuid.v4(),
        title: enteredTitle,
        amount: enteredAmount,
        date: DateTime.now(),
        category: _selectedType == TransactionType.income ? 'General' : _selectedCategory,
        type: _selectedType,
      );

      widget.onSubmit(newTx);
      _titleController.clear();
      _amountController.clear();
      setState(() {
        _selectedType = TransactionType.expense;
        _selectedCategory = 'Food';
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Error'),
          content: Text('Please enter valid data.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title (e.g. Salary, Groceries)'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<TransactionType>(
              value: _selectedType,
              decoration: InputDecoration(labelText: 'Type'),
              items: TransactionType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(
                    type == TransactionType.income ? 'Income' : 'Expense',
                  ),
                );
              }).toList(),
              onChanged: (type) {
                setState(() {
                  _selectedType = type!;
                });
              },
            ),
            if (_selectedType == TransactionType.expense)
              SizedBox(height: 10),
            if (_selectedType == TransactionType.expense)
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(labelText: 'Category'),
                items: _categories.map((cat) {
                  return DropdownMenuItem(
                    value: cat,
                    child: Text(cat),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedCategory = val!;
                  });
                },
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Add Transaction',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
