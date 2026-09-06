import 'package:expense_tracker/features/expenses/domain/entities/expense_entity.dart';
import 'package:expense_tracker/features/expenses/presentation/state/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddExpensePage extends ConsumerStatefulWidget{
  const AddExpensePage({super.key});

  @override
  ConsumerState<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends ConsumerState<AddExpensePage> {
  final  _titleController = TextEditingController();
  final  _amountController = TextEditingController();

  ExpenseCategory _selectedCategory = ExpenseCategory.food;
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveExpense() {
    final title = _titleController.text.trim();
    final amount = double.tryParse(_amountController.text) ?? 0.0 ;

    if (title.isEmpty || amount <= 0 ) return;

    final newExpense = ExpenseEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        amount: amount,
        date: _selectedDate,
        category: _selectedCategory,
    );

    ref.read(expenseNotifierProvider.notifier).addExpense(newExpense);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title (e.g., Coffee)'
              ),
            ),
            const SizedBox(height: 16,),
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Amount',
              ),
            ),
            const SizedBox(height: 16,),
            Row(
              children: [
                Expanded(
                    child: Text('Date: ${_selectedDate.toString().split(' ')[0]}'),
                ),
                TextButton(
                    onPressed: _pickDate,
                    child: const Text('Pick Date'),
                ),
              ],
            ),
            const SizedBox(height: 16,),
            DropdownButtonFormField<ExpenseCategory>(
                value: _selectedCategory,
                items: ExpenseCategory.values.map((category) {
                  return DropdownMenuItem(
                      value: category,
                      child: Text(category.name.toUpperCase()),);
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  }
                },
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: _saveExpense,
                  child: const Text('Save Expense'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}