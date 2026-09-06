import 'package:expense_tracker/features/expenses/domain/entities/expense_entity.dart';

class ExpenseModel extends ExpenseEntity{
  ExpenseModel({
    required super.id,
    required super.title,
    required super.amount,
    required super.date,
    required super.category,
});

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
        id: json['id'] as String,
        title: json['title'] as String,
        amount: (json['amount'] as num).toDouble(),
        date: DateTime.parse(json['date'] as String),
        category: ExpenseCategory.values.firstWhere(
            (e) => e.name == json['category'],
          orElse: () => ExpenseCategory.other,
        ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'title' : title,
      'amount' : amount,
      'date' : date.toIso8601String(),
      'category' : category.name,
    };
  }
}