import 'package:expense_tracker/features/expenses/data/datasources/expense_local_data_source.dart';
import 'package:expense_tracker/features/expenses/data/models/expense_model.dart';
import 'package:expense_tracker/features/expenses/domain/entities/expense_entity.dart';
import 'package:expense_tracker/features/expenses/domain/repositories/expense_repositories.dart';

class ExpenseRepositoryImpl extends ExpenseRepositories{
  final ExpenseLocalDataSource localDataSource;

  ExpenseRepositoryImpl({required this.localDataSource});

  @override
  Future<List<ExpenseEntity>> getExpenses() async {
    return await localDataSource.getExpenses();
  }

  @override
  Future<void> addExpenses(ExpenseEntity expense) async {
    final currentExpenses = await localDataSource.getExpenses();

    final newExpensesModel = ExpenseModel(
        id: expense.id,
        title: expense.title,
        amount: expense.amount,
        date: expense.date,
        category: expense.category,
    );

    currentExpenses.add(newExpensesModel);
    await localDataSource.cacheExpenses(currentExpenses);
  }
  @override
  Future<void> deleteExpense(String id) async {
    final currentExpenses = await localDataSource.getExpenses();

    currentExpenses.removeWhere((expense) => expense.id == id);

    await localDataSource.cacheExpenses(currentExpenses);
  }

  @override
  Future<List<ExpenseEntity>> getExpensesByCategory(ExpenseCategory category) async {
    final allExpenses = await localDataSource.getExpenses();

    return allExpenses.where((expense) => expense.category == category).toList();
  }
}