import 'package:expense_tracker/features/expenses/domain/entities/expense_entity.dart';

abstract class ExpenseRepositories {
// All Expense List
  Future<List<ExpenseEntity>> getExpenses();
// add expense
  Future<void> addExpenses(ExpenseEntity expense);
// delete expense
  Future<void> deleteExpense(String id);
// expense by category
  Future<List<ExpenseEntity>> getExpensesByCategory(ExpenseCategory category);
}