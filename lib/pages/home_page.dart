import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application/providers/budget_provider.dart';
import 'package:flutter_application/pages/add_transaction_page.dart';
import 'package:flutter_application/pages/report_page.dart';
import 'package:flutter_application/pages/transactions_page.dart';
import 'package:flutter_application/pages/auth_page.dart';
import 'package:flutter_application/widgets/transaction_list.dart';  // Assurez-vous que ce fichier est correct
import 'package:flutter_application/pages/BudgetGoalsPage.dart';
import 'package:flutter_application/pages/ExpenseCategoriesPage.dart';
import 'package:flutter_application/pages/FinancialPlanningPage.dart';
import 'package:flutter_application/pages/SettingsPage.dart';
import 'package:flutter_application/pages/HelpSupportPage.dart';

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
      drawer: _buildDrawer(context),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTransactionPage()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.teal[400],
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

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.teal[400],
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Accueil'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Transactions'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TransactionsPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.pie_chart),
            title: Text('Rapports'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReportPage()),
              );
            },
          ),
          // Nouveaux boutons
          ListTile(
            leading: Icon(Icons.flag), // Changé de Icons.target à Icons.flag
            title: Text('Objectifs budgétaires'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BudgetGoalsPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.category),
            title: Text('Catégories de dépenses'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ExpenseCategoriesPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.timeline),
            title: Text('Planification financière'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FinancialPlanningPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Paramètres'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Aide et support'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelpSupportPage()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Déconnexion'),
            onTap: () {
              // Logique de déconnexion
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AuthPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
