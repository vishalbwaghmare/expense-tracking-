import 'package:expense_tracker/data/datasourse/hive_service.dart';
import 'package:expense_tracker/data/models/expense_model.dart';
import 'package:expense_tracker/data/repository/expense_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeHiveService extends HiveService {
  final List<ExpenseModel> storedExpenses = [];

  @override
  Future<void> addExpense(ExpenseModel expense) async {
    storedExpenses.add(expense);
  }

  @override
  List<ExpenseModel> getExpenses() {
    return storedExpenses;
  }
}

void main() {
  test('addExpense initializes cache when it is null', () async {
    final fakeHiveService = FakeHiveService();
    final repository = ExpenseRepositoryImpl(fakeHiveService);

    final expense = ExpenseModel(
      id: '1',
      title: 'Groceries',
      amount: 123.45,
      date: DateTime(2026, 7, 16),
      category: 'Food',
    );

    await repository.addExpense(expense);

    expect(repository.getExpense(), contains(expense));
  });
}
