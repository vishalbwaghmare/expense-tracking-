part of 'expense_bloc.dart';

enum ExpenseStatus { initial, loading, success, failure }

class ExpenseState extends Equatable {
  final ExpenseStatus status;
  final List<ExpenseModel> expenses;
  final List<ExpenseModel> filteredExpenses;
  final String? errorMessage;
  final DateTime? selectedDateFrom;
  final DateTime? selectedDateTo;
  final String? selectedCategory;
  final String searchQuery;

  const ExpenseState({
    required this.status,
    required this.expenses,
    required this.filteredExpenses,
    this.errorMessage,
    this.selectedDateFrom,
    this.selectedDateTo,
    this.selectedCategory,
    this.searchQuery = '',
  });

  /// Initial State
  factory ExpenseState.initial() {
    return const ExpenseState(
      status: ExpenseStatus.initial,
      expenses: [],
      filteredExpenses: [],
      errorMessage: null,
    );
  }

  // Calculated properties (all logic in BLoC state)
  double get totalExpenses => expenses.fold(0, (total, e) => total + e.amount);
  
  double get filteredTotal => filteredExpenses.fold(0, (total, e) => total + e.amount);
  
  double get averageExpense {
    if (expenses.isEmpty) return 0;
    return totalExpenses / expenses.length;
  }
  
  double get filteredAverage {
    if (filteredExpenses.isEmpty) return 0;
    return filteredTotal / filteredExpenses.length;
  }
  
  int get transactionCount => expenses.length;
  
  int get filteredTransactionCount => filteredExpenses.length;
  
  int get thisMonthTransactions {
    final now = DateTime.now();
    return expenses
        .where((e) => e.date.year == now.year && e.date.month == now.month)
        .length;
  }
  
  String get highestExpenseCategory {
    if (expenses.isEmpty) return 'N/A';
    final categoryMap = _getCategoryWiseTotal();
    if (categoryMap.isEmpty) return 'N/A';
    final highest = categoryMap.entries
        .reduce((a, b) => a.value > b.value ? a : b);
    return highest.key;
  }
  
  double get highestCategoryAmount {
    if (expenses.isEmpty) return 0;
    final categoryMap = _getCategoryWiseTotal();
    if (categoryMap.isEmpty) return 0;
    return categoryMap.values.reduce((a, b) => a > b ? a : b);
  }
  
  Map<String, double> get categoryWiseTotal => _getCategoryWiseTotal();
  
  Map<String, int> get categoryWiseCount {
    final countMap = <String, int>{};
    for (var expense in expenses) {
      countMap[expense.category] = (countMap[expense.category] ?? 0) + 1;
    }
    return countMap;
  }
  
  Map<String, double> get filteredCategoryWiseTotal {
    final categoryMap = <String, double>{};
    for (var expense in filteredExpenses) {
      categoryMap[expense.category] =
          (categoryMap[expense.category] ?? 0) + expense.amount;
    }
    return categoryMap;
  }
  
  bool get hasActiveFilters =>
      selectedCategory != null ||
      selectedDateFrom != null ||
      searchQuery.isNotEmpty;
  
  bool get isEmpty => expenses.isEmpty;
  
  bool get isFilteredEmpty => filteredExpenses.isEmpty;

  Map<String, double> _getCategoryWiseTotal() {
    final categoryMap = <String, double>{};
    for (var expense in expenses) {
      categoryMap[expense.category] =
          (categoryMap[expense.category] ?? 0) + expense.amount;
    }
    return categoryMap;
  }

  ExpenseState copyWith({
    ExpenseStatus? status,
    List<ExpenseModel>? expenses,
    List<ExpenseModel>? filteredExpenses,
    String? errorMessage,
    DateTime? selectedDateFrom,
    DateTime? selectedDateTo,
    String? selectedCategory,
    String? searchQuery,
    bool clearDateFrom = false,
    bool clearDateTo = false,
    bool clearCategory = false,
  }) {
    return ExpenseState(
      status: status ?? this.status,
      expenses: expenses ?? this.expenses,
      filteredExpenses: filteredExpenses ?? this.filteredExpenses,
      errorMessage: errorMessage,
      selectedDateFrom:
          clearDateFrom ? null : (selectedDateFrom ?? this.selectedDateFrom),
      selectedDateTo:
          clearDateTo ? null : (selectedDateTo ?? this.selectedDateTo),
      selectedCategory:
          clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
        status,
        expenses,
        filteredExpenses,
        errorMessage,
        selectedDateFrom,
        selectedDateTo,
        selectedCategory,
        searchQuery,
      ];
}
