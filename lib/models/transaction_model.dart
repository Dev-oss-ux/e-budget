import 'package:flutter/material.dart';

class TransactionModel {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final IconData icon;  // Ajoutez cette ligne pour l'icône

//Ajouter les differents élements du model
  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.icon,  // Assurez-vous d'initialiser cette propriété
  });
}
