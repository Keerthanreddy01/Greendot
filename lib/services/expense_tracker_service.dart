import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/expense_model.dart';

class ExpenseTrackerService {
  static final ExpenseTrackerService _instance = ExpenseTrackerService._internal();
  factory ExpenseTrackerService() => _instance;
  ExpenseTrackerService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'expenses.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE expenses(
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            amount REAL NOT NULL,
            category TEXT NOT NULL,
            type TEXT NOT NULL,
            date TEXT NOT NULL,
            description TEXT,
            cropRelated TEXT,
            receiptUrl TEXT,
            createdAt TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> addExpense(Expense expense) async {
    final db = await database;
    await db.insert(
      'expenses',
      expense.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateExpense(Expense expense) async {
    final db = await database;
    await db.update(
      'expenses',
      expense.toJson(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  Future<void> deleteExpense(String id) async {
    final db = await database;
    await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Expense>> getAllExpenses() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'expenses',
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => Expense.fromJson(maps[i]));
  }

  Future<List<Expense>> getExpensesByDateRange(DateTime start, DateTime end) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'expenses',
      where: 'date >= ? AND date <= ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => Expense.fromJson(maps[i]));
  }

  Future<List<Expense>> getExpensesByCategory(String category) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'expenses',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => Expense.fromJson(maps[i]));
  }

  Future<FinancialSummary> getFinancialSummary(DateTime start, DateTime end) async {
    final expenses = await getExpensesByDateRange(start, end);

    double totalExpenses = 0;
    double totalIncome = 0;
    Map<String, double> categoryExpenses = {};
    Map<String, double> monthlyExpenses = {};
    Map<String, double> monthlyIncome = {};

    for (var expense in expenses) {
      if (expense.type == 'expense') {
        totalExpenses += expense.amount;
        categoryExpenses[expense.category] = 
            (categoryExpenses[expense.category] ?? 0) + expense.amount;

        final monthKey = '${expense.date.year}-${expense.date.month.toString().padLeft(2, '0')}';
        monthlyExpenses[monthKey] = (monthlyExpenses[monthKey] ?? 0) + expense.amount;
      } else {
        totalIncome += expense.amount;
        final monthKey = '${expense.date.year}-${expense.date.month.toString().padLeft(2, '0')}';
        monthlyIncome[monthKey] = (monthlyIncome[monthKey] ?? 0) + expense.amount;
      }
    }

    final profit = totalIncome - totalExpenses;
    final profitMargin = totalIncome > 0 ? (profit / totalIncome) * 100 : 0;

    // Convert monthly data
    List<MonthlyData> monthlyDataList = [];
    Set<String> allMonths = {...monthlyExpenses.keys, ...monthlyIncome.keys};

    for (var month in allMonths) {
      final parts = month.split('-');
      monthlyDataList.add(MonthlyData(
        month: month,
        year: int.parse(parts[0]),
        monthNumber: int.parse(parts[1]),
        income: monthlyIncome[month] ?? 0,
        expenses: monthlyExpenses[month] ?? 0,
        profit: (monthlyIncome[month] ?? 0) - (monthlyExpenses[month] ?? 0),
      ));
    }

    monthlyDataList.sort((a, b) => 
        a.year != b.year ? a.year.compareTo(b.year) : a.monthNumber.compareTo(b.monthNumber));

    return FinancialSummary(
      totalIncome: totalIncome,
      totalExpenses: totalExpenses,
      profit: profit,
      profitMargin: profitMargin,
      categoryBreakdown: categoryExpenses,
      monthlyData: monthlyDataList,
      transactionCount: expenses.length,
    );
  }

  Future<Map<String, double>> getCategoryWiseExpenses(DateTime start, DateTime end) async {
    final expenses = await getExpensesByDateRange(start, end);
    Map<String, double> categoryExpenses = {};

    for (var expense in expenses) {
      if (expense.type == 'expense') {
        categoryExpenses[expense.category] = 
            (categoryExpenses[expense.category] ?? 0) + expense.amount;
      }
    }

    return categoryExpenses;
  }

  List<String> getExpenseCategories() {
    return [
      'Seeds & Plants',
      'Fertilizers',
      'Pesticides',
      'Labor',
      'Equipment',
      'Irrigation',
      'Transportation',
      'Marketing',
      'Storage',
      'Electricity',
      'Fuel',
      'Maintenance',
      'Others',
    ];
  }

  String getDefaultCropForCategory(String category) {
    // Helper to suggest crop relation
    return '';
  }
}
