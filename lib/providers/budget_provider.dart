import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/transaction_model.dart'; // Assure-toi d'utiliser le bon modèle

class BudgetProvider with ChangeNotifier {
  List<Category> _categories = [
    Category(amount: 200, color: Colors.red, icon: Icons.fastfood, name: 'Alimentation'),
    Category(amount: 300, color: Colors.blue, icon: Icons.shopping_cart, name: 'Courses'),
    Category(amount: 150, color: Colors.green, icon: Icons.home, name: 'Logement'),
  ];

  List<TransactionModel> _transactions = [];

  double get totalExpenses => _transactions.fold(0, (sum, transaction) => sum + transaction.amount);

  List<Category> get categories => _categories;

  List<TransactionModel> get transactions => _transactions;

  void addTransaction(TransactionModel transaction) {
    _transactions.add(transaction);
    notifyListeners();
  }

  void deleteTransaction(String id) {
    _transactions.removeWhere((transaction) => transaction.id == id);
    notifyListeners();
  }
}
