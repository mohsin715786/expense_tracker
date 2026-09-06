import 'package:expense_tracker/features/expenses/domain/entities/expense_entity.dart';
import 'package:expense_tracker/features/expenses/presentation/state/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import 'add_expense_page.dart';

class ExpenseListPage extends ConsumerWidget{
  const ExpenseListPage({super.key});

  @override
  Widget build (BuildContext context, WidgetRef ref) {
    final expenseState = ref.watch(expenseNotifierProvider);

    final currentFilter = ref.watch(expenseFilterProvider);

    final  displayedExpenses = ref.watch(filteredExpensesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                FilterChip(
                    label: const Text('All'),
                    selected: currentFilter == null,
                    onSelected: (_) => ref.read(expenseFilterProvider.notifier).state = null,
                ),
                const SizedBox(width: 8,),
                ...ExpenseCategory.values.map((category) {
                  return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                        label: Text(category.name.toUpperCase()),
                        selected: currentFilter == category,
                        onSelected: (_) => ref.read(expenseFilterProvider.notifier).state = category,
                    ),
                  );
                }),
              ],
            ),
          ),
          Expanded(
            child: expenseState.when(
              data: (expenses) {
                if (expenses.isEmpty) {
                  return const Center(child: Text('No expenses yet. Add one!'),);
                }
                return ListView.builder(
                  itemCount: displayedExpenses.length,
                  itemBuilder: (context, index) {
                    final expense = displayedExpenses[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Icon(_getCategoryIcon(expense.category)),
                      ),
                      title: Text(expense.title),
                      subtitle: Text(expense.date.toString().split(' ')[0]),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '\$${expense.amount.toStringAsFixed(2)}',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          IconButton(
                            onPressed: () {
                              ref.read(expenseNotifierProvider.notifier).deleteExpense(expense.id);
                            },
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              error: (error, stack) => Center(child: Text('Error: $error'),),
              loading: () => const Center(child: CircularProgressIndicator(),),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddExpensePage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  IconData _getCategoryIcon(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food: return Icons.fastfood;
      case ExpenseCategory.transport: return Icons.directions_car;
      case ExpenseCategory.entertainment: return Icons.movie;
      case ExpenseCategory.work: return Icons.work;
      case ExpenseCategory.other: return Icons.receipt;
    }
  }
}