import 'package:expense_tracker/features/expenses/data/datasources/expense_local_data_source.dart';
import 'package:expense_tracker/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:expense_tracker/features/expenses/domain/entities/expense_entity.dart';
import 'package:expense_tracker/features/expenses/domain/repositories/expense_repositories.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPrefrencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialized in main.dart');
});

final expenseLocalDataSourceProvider = Provider<ExpenseLocalDataSource>((ref) {
   final prefs = ref.watch(sharedPrefrencesProvider);
   return ExpenseLocalDataSource(sharedPreferences: prefs);
});

final expenseRepositoryProvider = Provider<ExpenseRepositories>((ref) {
  final dataSource = ref.watch(expenseLocalDataSourceProvider);
  return ExpenseRepositoryImpl(localDataSource: dataSource);
});

class ExpenseNotifier extends AsyncNotifier<List<ExpenseEntity>> {
  @override
  Future<List<ExpenseEntity>> build() async {
    final repository = ref.read(expenseRepositoryProvider);
    return await repository.getExpenses();
  }

  Future<void> addExpense(ExpenseEntity expense) async {
    final repository = ref.read(expenseRepositoryProvider);
    await repository.addExpenses(expense);

    ref.invalidateSelf();
  }

  Future<void> deleteExpense(String id) async {
    final repository = ref.read(expenseRepositoryProvider);
    await repository.deleteExpense(id);

    ref.invalidateSelf();
  }
}

final expenseNotifierProvider = AsyncNotifierProvider<ExpenseNotifier, List<ExpenseEntity>>(() {
  return ExpenseNotifier();
});

final expenseFilterProvider = StateProvider<ExpenseCategory?>((ref) => null);

final filteredExpensesProvider = Provider<List<ExpenseEntity>>((ref) {
  final asyncExpenses = ref.watch(expenseNotifierProvider);
  final currentFilter = ref.watch(expenseFilterProvider);

  return asyncExpenses.maybeWhen(
    data: (expenses) {
      if (currentFilter == null) return expenses;
      return expenses.where((e) => e.category == currentFilter).toList();
    },
      orElse: () => [],
  );
});