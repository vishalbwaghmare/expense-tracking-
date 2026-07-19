import 'package:expense_tracker/data/datasourse/hive_service.dart';
import 'package:expense_tracker/data/models/expense_model.dart';
import 'package:expense_tracker/domain/repository/expense_repository.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final HiveService hiveService;

  ExpenseRepositoryImpl(this.hiveService);

  List<ExpenseModel>? _cache;

  @override
  Future<void> addExpense(ExpenseModel expense) async {
    await hiveService.addExpense(expense);

    _cache ??= hiveService.getExpenses();
    _cache!.add(expense);
  }

  @override
  Future<void> deleteExpense(String id) async {
    await hiveService.deleteExpense(id);

    _cache ??= hiveService.getExpenses();
    _cache!.removeWhere((expense) => expense.id == id);
  }

  @override
  List<ExpenseModel> getExpense() {
    _cache ??= hiveService.getExpenses();
    return _cache!;
  }

  @override
  Future<void> updateExpense(ExpenseModel expense) async {
    await hiveService.updateExpense(expense);

    _cache ??= hiveService.getExpenses();

    final index = _cache!.indexWhere((e) => e.id == expense.id);

    if (index != -1) {
      _cache![index] = expense;
    }
  }
}
