enum ExpenseCategory {food,transport, entertainment, work, other}

class ExpenseEntity {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final ExpenseCategory category;

  ExpenseEntity({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category
  });
  ExpenseEntity copyWith({
    String? id,
    String? title,
    double? amount,
    DateTime? date,
    ExpenseCategory? category,
  }) {
    return ExpenseEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
    );
  }
}