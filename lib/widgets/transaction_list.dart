import 'package:flutter/material.dart';
import 'package:flutter_application/models/transaction_model.dart';

class TransactionList extends StatelessWidget {
  final List<TransactionModel> transactions;
  final Function(String) onDelete;

  TransactionList({required this.transactions, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (ctx, index) {
        final tx = transactions[index];
        return ListTile(
          leading: Icon(tx.icon, color: Colors.teal[400]), // Icône avant le texte
          title: Text(tx.title),
          trailing: Text(
            '\$${tx.amount.toStringAsFixed(2)}', // Somme à la fin
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.teal[400],
            ),
          ),
          onLongPress: () => onDelete(tx.id), // Suppression via un appui long
        );
      },
    );
  }
}
