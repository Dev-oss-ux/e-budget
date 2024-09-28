import 'package:flutter/material.dart';

class ExpenseCategoriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catégories de dépenses'),
        backgroundColor: Colors.teal[400],
        elevation: 0,
      ),
      body: Container(
        color: Colors.teal[50],
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            _buildCategoryCard('Alimentation', 500, Colors.orange),
            SizedBox(height: 16),
            _buildCategoryCard('Transport', 300, Colors.blue),
            SizedBox(height: 16),
            _buildCategoryCard('Loisirs', 200, Colors.purple),
            SizedBox(height: 16),
            _buildCategoryCard('Logement', 800, Colors.green),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Ajouter une nouvelle catégorie
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.teal[400],
      ),
    );
  }

  Widget _buildCategoryCard(String title, double amount, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(Icons.category, color: Colors.white),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Budget: $amount€'),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.teal[400]),
        onTap: () {
          // Ouvrir les détails de la catégorie
        },
      ),
    );
  }
}
