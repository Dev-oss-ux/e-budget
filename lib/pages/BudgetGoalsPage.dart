import 'package:flutter/material.dart';

class BudgetGoalsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Objectifs budgétaires'),
        backgroundColor: Colors.teal[400],
        elevation: 0,
      ),
      body: Container(
        color: Colors.teal[50],
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            _buildGoalCard('Économies', 5000, 3000, Icons.savings),
            SizedBox(height: 16),
            _buildGoalCard('Vacances', 2000, 1500, Icons.beach_access),
            SizedBox(height: 16),
            _buildGoalCard('Nouveau téléphone', 1000, 800, Icons.phone_android),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Ajouter un nouvel objectif
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.teal[400],
      ),
    );
  }

  Widget _buildGoalCard(String title, double target, double current, IconData icon) {
    double progress = current / target;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Icon(icon, color: Colors.teal[400]),
              ],
            ),
            SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.teal[400]!),
            ),
            SizedBox(height: 8),
            Text('${(progress * 100).toStringAsFixed(1)}% - $current€ / $target€'),
          ],
        ),
      ),
    );
  }
}
