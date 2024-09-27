import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application/providers/budget_provider.dart';
import 'package:flutter_application/pages/add_transaction_page.dart';
import 'package:flutter_application/pages/report_page.dart';
import 'package:flutter_application/widgets/transaction_list.dart';  // Assurez-vous que ce fichier est correct

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? _touchedIndex;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 1: // Rapports
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ReportPage()),
        );
        break;
      case 2: // Ajouter
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddTransactionPage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final budgetProvider = Provider.of<BudgetProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion de Budget', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal[400],
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[100],
        child: Column(
          children: [
            _buildBudgetOverview(context, budgetProvider),
            SizedBox(height: 20),
            Expanded(
              child: TransactionList(
                transactions: budgetProvider.transactions,
                onDelete: (id) {
                  budgetProvider.deleteTransaction(id);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Rapports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Ajouter',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal[400],
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        elevation: 10,
      ),
    );
  }

  Widget _buildBudgetOverview(BuildContext context, BudgetProvider provider) {
    final totalExpenses = provider.totalExpenses;
    final totalIncome = 5000; // Exemple de revenu total
    final remainingBudget = totalIncome - totalExpenses;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal[500]!, Colors.teal[300]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Solde Restant',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          Text(
            '${remainingBudget.toStringAsFixed(2)} €',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: _generatePieChartSections(provider),
                centerSpaceRadius: 50,
                sectionsSpace: 6,
                borderData: FlBorderData(show: false),
                startDegreeOffset: 270,
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, PieTouchResponse? response) {
                    if (response != null && response.touchedSection != null) {
                      setState(() {
                        _touchedIndex = response.touchedSection!.touchedSectionIndex;
                      });
                    } else {
                      setState(() {
                        _touchedIndex = null;
                      });
                    }
                  },
                ),
              ),
              swapAnimationDuration: Duration(milliseconds: 800),
              swapAnimationCurve: Curves.easeInOut,
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  List<PieChartSectionData> _generatePieChartSections(BudgetProvider provider) {
    final totalExpenses = provider.totalExpenses;

    if (totalExpenses == 0 || provider.categories.isEmpty) {
      return [
        PieChartSectionData(
          color: Colors.grey[400]!,
          value: 100,
          title: '',
          radius: 60,
          titleStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ];
    }

    return provider.categories.asMap().entries.map((entry) {
      int index = entry.key;
      var category = entry.value;
      final percentage = (category.amount / totalExpenses) * 100;

      return PieChartSectionData(
        color: _touchedIndex == index ? category.color.withOpacity(0.7) : category.color,
        value: percentage,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: _touchedIndex == index ? 70 : 60,
        titleStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        badgeWidget: _buildBadge(category.icon),
        badgePositionPercentageOffset: .98,
      );
    }).toList();
  }

  // Widget qui affiche l'icône dans un badge
  Widget _buildBadge(IconData icon) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 5),
        ],
      ),
      child: Icon(icon, size: 18, color: Colors.teal[400]),
    );
  }
}
