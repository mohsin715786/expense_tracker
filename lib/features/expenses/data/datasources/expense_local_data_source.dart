import 'dart:convert';

import 'package:expense_tracker/features/expenses/data/models/expense_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpenseLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String _storageKey = 'CACHED_EXPENSES';

  ExpenseLocalDataSource({required this.sharedPreferences});

  Future<List<ExpenseModel>> getExpenses() async {
    final jsonStringList = sharedPreferences.getStringList(_storageKey);

    if(jsonStringList != null ) {
      return jsonStringList
          .map((jsonString) => ExpenseModel.fromJson(json.decode(jsonString)))
          .toList();
    } else {
      return [];
    }
  }
  Future<void> cacheExpenses(List<ExpenseModel> expenses) async {
    final jsonStringList = expenses
        .map((expenses) => json.encode(expenses.toJson()))
        .toList();

    await sharedPreferences.setStringList(_storageKey, jsonStringList);
  }
}