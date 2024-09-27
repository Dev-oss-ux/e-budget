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
        final transaction = transactions[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.teal[100],
                child: Icon(transaction.icon, color: Colors.teal[700]),
              ),
              title: Text(transaction.title),
              subtitle: Text(transaction.date.toString().split(' ')[0]),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${transaction.amount.toStringAsFixed(2)} €'),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => onDelete(transaction.id),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
