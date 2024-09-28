import 'package:flutter/material.dart';
import 'package:flutter_application/pages/auth_page.dart';
import 'package:flutter_application/providers/budget_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BudgetProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Gestion de Budget',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AuthPage(),
      ),
    );
  }
}
