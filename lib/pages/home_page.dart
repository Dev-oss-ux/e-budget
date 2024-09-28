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
      child: Container(
        color: Colors.teal[50],
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal[400]!, Colors.teal[200]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.teal[400], size: 30),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Nom d\'utilisateur',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    'utilisateur@email.com',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(Icons.home, 'Accueil', () => Navigator.pop(context)),
            _buildDrawerItem(Icons.list, 'Transactions', () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionsPage()));
            }),
            _buildDrawerItem(Icons.pie_chart, 'Rapports', () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => ReportPage()));
            }),
            _buildDrawerItem(Icons.flag, 'Objectifs budgétaires', () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => BudgetGoalsPage()));
            }),
            _buildDrawerItem(Icons.category, 'Catégories de dépenses', () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ExpenseCategoriesPage()));
            }),
            _buildDrawerItem(Icons.timeline, 'Planification financière', () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => FinancialPlanningPage()));
            }),
            _buildDrawerItem(Icons.settings, 'Paramètres', () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
            }),
            _buildDrawerItem(Icons.help, 'Aide et support', () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => HelpSupportPage()));
            }),
            Divider(color: Colors.teal[200]),
            _buildDrawerItem(Icons.exit_to_app, 'Déconnexion', () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthPage()));
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal[400]),
      title: Text(title, style: TextStyle(color: Colors.teal[800])),
      onTap: onTap,
    );
  }
}
