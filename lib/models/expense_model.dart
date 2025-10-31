class Expense {
  final String id;
  final String category;
  final double amount;
  final String description;
  final DateTime date;
  final String type; // expense or income
  final String? receipt;

  Expense({
    required this.id,
    required this.category,
    required this.amount,
    required this.description,
    required this.date,
    required this.type,
    this.receipt,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] ?? '',
      category: json['category'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      description: json['description'] ?? '',
      date: DateTime.parse(json['date']),
      type: json['type'] ?? 'expense',
      receipt: json['receipt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'amount': amount,
      'description': description,
      'date': date.toIso8601String(),
      'type': type,
      'receipt': receipt,
    };
  }
}

class FinancialSummary {
  final double totalIncome;
  final double totalExpense;
  final double netProfit;
  final Map<String, double> expenseByCategory;
  final Map<String, double> incomeBySource;
  final List<MonthlyData> monthlyData;

  FinancialSummary({
    required this.totalIncome,
    required this.totalExpense,
    required this.netProfit,
    required this.expenseByCategory,
    required this.incomeBySource,
    required this.monthlyData,
  });
}

class MonthlyData {
  final String month;
  final double income;
  final double expense;

  MonthlyData({
    required this.month,
    required this.income,
    required this.expense,
  });
}
