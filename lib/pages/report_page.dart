import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/budget_provider.dart';

class ReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final budgetProvider = Provider.of<BudgetProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Rapport financier'),
        backgroundColor: Colors.teal[400],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Évolution des dépenses',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: const Color(0xff37434d), width: 1),
                  ),
                  minX: 0,
                  maxX: 6,
                  minY: 0,
                  maxY: 6,
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 3),
                        FlSpot(1, 1),
                        FlSpot(2, 4),
                        FlSpot(3, 2),
                        FlSpot(4, 5),
                        FlSpot(5, 1),
                        FlSpot(6, 4),
                      ],
                      isCurved: true,
                      color: Colors.teal,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.teal.withOpacity(0.3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Détails des dépenses par catégorie',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: BarChart(
                BarChartData(
                  barGroups: _generateBarGroups(budgetProvider),
                  titlesData: _buildTitles(budgetProvider),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Génère les groupes de barres pour chaque catégorie.
  List<BarChartGroupData> _generateBarGroups(BudgetProvider provider) {
    return provider.categories.asMap().entries.map((entry) {
      int index = entry.key;
      final category = entry.value;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: category.amount,
            color: category.color,
            width: 20,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();
  }

  /// Génère les titres des axes (catégories en bas, montant à gauche).
  FlTitlesData _buildTitles(BudgetProvider provider) {
    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (double value, TitleMeta meta) {
            final index = value.toInt();
            if (index < 0 || index >= provider.categories.length) {
              return Container();
            }
            final category = provider.categories[index];
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                category.name,
                style: TextStyle(color: Colors.black, fontSize: 12),
              ),
            );
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 50, // Intervalle entre les montants affichés
          getTitlesWidget: (double value, TitleMeta meta) {
            return Text('${value.toInt()}€', style: TextStyle(fontSize: 12));
          },
        ),
      ),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }
}
