import 'package:expense_tracker/data/models/expense_model.dart';
import 'package:hive/hive.dart';

class HiveService {
  Box<ExpenseModel> get box => Hive.box<ExpenseModel>("expense");

  Future<void> addExpense(ExpenseModel expense) async {
    await box.put(expense.id, expense);
  }

  List<ExpenseModel> getExpenses() {
    return box.values.toList();
  }

  Future<void> deleteExpense(String id) async {
    await box.delete(id);
  }

  Future<void> updateExpense(ExpenseModel expense) async {
    await box.put(expense.id, expense);
  }
}
