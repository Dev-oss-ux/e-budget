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
        title: Text('Détails des Dépenses'),
        backgroundColor: Colors.teal[400],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Catégorie',
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
                  alignment: BarChartAlignment.spaceAround,
                  maxY: budgetProvider.categories
                      .map((c) => c.amount)
                      .reduce((a, b) => a > b ? a : b) +
                      50, // maxY avec une petite marge
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipPadding: EdgeInsets.all(8),
                      tooltipMargin: 4,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final category = budgetProvider.categories[groupIndex];
                        return BarTooltipItem(
                          '${category.name}\n',
                          TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: '${rod.toY.toInt()}€',
                              style: TextStyle(
                                color: Colors.tealAccent[100],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
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
