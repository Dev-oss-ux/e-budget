import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class FinancialPlanningPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Planification financière'),
        backgroundColor: Colors.teal[400],
        elevation: 0,
      ),
      body: Container(
        color: Colors.teal[50],
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            _buildSummaryCard(),
            SizedBox(height: 16),
            _buildProjectionChart(),
            SizedBox(height: 16),
            _buildActionCard(
              'Définir un objectif d\'épargne',
              'Planifiez votre avenir financier',
              Icons.savings,
              () {
                // Ouvrir la page de définition d'objectif d'épargne
              },
            ),
            SizedBox(height: 16),
            _buildActionCard(
              'Analyser vos dépenses',
              'Identifiez les domaines d\'amélioration',
              Icons.analytics,
              () {
                // Ouvrir la page d'analyse des dépenses
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Résumé financier',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryItem('Revenus', '3000€', Colors.green),
                _buildSummaryItem('Dépenses', '2500€', Colors.red),
                _buildSummaryItem('Épargne', '500€', Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600])),
        SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _buildProjectionChart() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Projection d\'épargne sur 12 mois',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Container(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: 11,
                  minY: 0,
                  maxY: 6000,
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 500),
                        FlSpot(1, 1000),
                        FlSpot(2, 1500),
                        FlSpot(3, 2000),
                        FlSpot(4, 2500),
                        FlSpot(5, 3000),
                        FlSpot(6, 3500),
                        FlSpot(7, 4000),
                        FlSpot(8, 4500),
                        FlSpot(9, 5000),
                        FlSpot(10, 5500),
                        FlSpot(11, 6000),
                      ],
                      isCurved: true,
                      color: Colors.teal[400],
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.teal[200]!.withOpacity(0.3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.teal[400]),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.teal[400]),
            ],
          ),
        ),
      ),
    );
  }
}
