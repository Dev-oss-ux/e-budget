import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application/providers/budget_provider.dart';
import 'package:flutter_application/widgets/transaction_list.dart';

class TransactionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final budgetProvider = Provider.of<BudgetProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
        backgroundColor: Colors.teal[400],
      ),
      body: TransactionList(
        transactions: budgetProvider.transactions,
        onDelete: (String id) {
          budgetProvider.deleteTransaction(id);
        },
      ),
    );
  }
}
