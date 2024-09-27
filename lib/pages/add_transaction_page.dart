import 'package:flutter/material.dart';
import 'package:flutter_application/providers/budget_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application/models/transaction_model.dart';

class AddTransactionPage extends StatefulWidget {
  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isTitleValid = true;
  bool _isAmountValid = true;

  // Ajoutez cette variable pour stocker l'icône sélectionnée
  IconData _selectedIcon = Icons.attach_money;

  void _submitData() {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.tryParse(_amountController.text);

    setState(() {
      _isTitleValid = enteredTitle.isNotEmpty;
      _isAmountValid = enteredAmount != null && enteredAmount > 0;
    });

    if (!_isTitleValid || !_isAmountValid) {
      return;
    }

    Provider.of<BudgetProvider>(context, listen: false).addTransaction(
      TransactionModel(
        id: DateTime.now().toString(),
        amount: enteredAmount!,
        date: _selectedDate,
        title: enteredTitle,
        icon: _selectedIcon, // Utilisation de l'icône sélectionnée
      ),
    );

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  // Affichage de la boîte de dialogue pour sélectionner une icône
  void _selectIcon() async {
    IconData? selectedIcon = await showDialog<IconData>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choisir une icône'),
          content: Container(
            width: double.maxFinite,  // Assurez-vous que le conteneur occupe toute la largeur
            height: 300, // Hauteur fixe pour permettre le défilement
            child: GridView.count(
              crossAxisCount: 4,
              children: [
                Icons.attach_money,
                Icons.shopping_cart,
                Icons.restaurant,
                Icons.local_cafe,
                Icons.directions_car,
                Icons.flight,
                Icons.shopping_bag,
                Icons.fastfood,
                Icons.home,
                Icons.pool,
                Icons.business,
                Icons.local_hospital,
              ].map((iconData) {
                return IconButton(
                  icon: Icon(iconData),
                  onPressed: () => Navigator.of(context).pop(iconData),
                );
              }).toList(),
            ),
          ),
        );
      },
    );

    if (selectedIcon != null) {
      setState(() {
        _selectedIcon = selectedIcon;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter une transaction'),
        backgroundColor: Colors.teal[400],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildTitleInput(),
              SizedBox(height: 20),
              _buildAmountInput(),
              SizedBox(height: 20),
              _buildDateSelector(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _selectIcon,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_selectedIcon, color: Colors.teal[400]),
                    SizedBox(width: 10),
                    Text('Choisir une icône'),
                  ],
                ),
              ),
              SizedBox(height: 30),
              _buildAddButton(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleInput() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Titre',
        errorText: _isTitleValid ? null : 'Le titre ne doit pas être vide',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      controller: _titleController,
    );
  }

  Widget _buildAmountInput() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Montant',
        errorText: _isAmountValid ? null : 'Veuillez entrer un montant valide',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: Icon(Icons.attach_money),  // Icône ajoutée avant le montant
      ),
      controller: _amountController,
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildDateSelector() {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Date sélectionnée: ${_selectedDate.toLocal().toString().split(' ')[0]}',
            style: TextStyle(fontSize: 16),
          ),
        ),
        TextButton(
          onPressed: _presentDatePicker,
          child: Text(
            'Choisir une date',
            style: TextStyle(color: Colors.teal[400], fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton(ThemeData theme) {
    return ElevatedButton(
      onPressed: _submitData,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal[400],
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        'Ajouter',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
