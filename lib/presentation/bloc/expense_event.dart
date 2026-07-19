part of 'expense_bloc.dart';

sealed class ExpenseEvent extends Equatable {
  const ExpenseEvent();
}

class LoadExpenses extends ExpenseEvent {
  @override
  List<Object?> get props => [];
}

class AddExpense extends ExpenseEvent {
  final ExpenseModel expense;

  const AddExpense(this.expense);

  @override
  List<Object?> get props => [expense];
}

class UpdateExpense extends ExpenseEvent {
  final ExpenseModel expense;

  const UpdateExpense(this.expense);

  @override
  List<Object?> get props => [expense];
}

class DeleteExpense extends ExpenseEvent {
  final String id;

  const DeleteExpense(this.id);

  @override
  List<Object?> get props => [id];
}

class SearchExpenses extends ExpenseEvent {
  final String query;

  const SearchExpenses(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterByDateRange extends ExpenseEvent {
  final DateTime from;
  final DateTime to;

  const FilterByDateRange({required this.from, required this.to});

  @override
  List<Object?> get props => [from, to];
}

class FilterByCategory extends ExpenseEvent {
  final String category;

  const FilterByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class ClearFilters extends ExpenseEvent {
  @override
  List<Object?> get props => [];
}
