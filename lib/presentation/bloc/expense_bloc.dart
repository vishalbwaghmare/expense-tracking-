import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_tracker/data/models/expense_model.dart';
import 'package:expense_tracker/domain/repository/expense_repository.dart';

part 'expense_event.dart';
part 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseRepository repository;
  ExpenseBloc(this.repository) : super(ExpenseState.initial()) {
    on<LoadExpenses>(_onLoadExpenses);
    on<AddExpense>(_onAddExpense);
    on<UpdateExpense>(_onUpdateExpense);
    on<DeleteExpense>(_onDeleteExpense);
    on<SearchExpenses>(_onSearchExpenses);
    on<FilterByDateRange>(_onFilterByDateRange);
    on<FilterByCategory>(_onFilterByCategory);
    on<ClearFilters>(_onClearFilters);
  }

  Future<void> _onLoadExpenses(
    LoadExpenses event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(state.copyWith(status: ExpenseStatus.loading));

    try {
      final expenses = repository.getExpense();

      emit(
        state.copyWith(
          status: ExpenseStatus.success,
          expenses: expenses,
          filteredExpenses: expenses,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ExpenseStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onAddExpense(
    AddExpense event,
    Emitter<ExpenseState> emit,
  ) async {
    await repository.addExpense(event.expense);
    add(LoadExpenses());
  }

  Future<void> _onUpdateExpense(
    UpdateExpense event,
    Emitter<ExpenseState> emit,
  ) async {
    await repository.updateExpense(event.expense);
    add(LoadExpenses());
  }

  Future<void> _onDeleteExpense(
    DeleteExpense event,
    Emitter<ExpenseState> emit,
  ) async {
    await repository.deleteExpense(event.id);
    add(LoadExpenses());
  }

  void _onSearchExpenses(
    SearchExpenses event,
    Emitter<ExpenseState> emit,
  ) {
    final query = event.query.toLowerCase();
    final filtered = state.expenses.where((expense) {
      return expense.title.toLowerCase().contains(query) ||
          expense.category.toLowerCase().contains(query);
    }).toList();

    emit(state.copyWith(
      searchQuery: event.query,
      filteredExpenses: filtered,
    ));
  }

  void _onFilterByDateRange(
    FilterByDateRange event,
    Emitter<ExpenseState> emit,
  ) {
    final filtered = state.expenses.where((expense) {
      return expense.date.isAfter(event.from) &&
          expense.date.isBefore(event.to.add(const Duration(days: 1)));
    }).toList();

    emit(state.copyWith(
      selectedDateFrom: event.from,
      selectedDateTo: event.to,
      filteredExpenses: filtered,
    ));
  }

  void _onFilterByCategory(
    FilterByCategory event,
    Emitter<ExpenseState> emit,
  ) {
    final filtered = state.expenses.where((expense) {
      return expense.category == event.category;
    }).toList();

    emit(state.copyWith(
      selectedCategory: event.category,
      filteredExpenses: filtered,
    ));
  }

  void _onClearFilters(
    ClearFilters event,
    Emitter<ExpenseState> emit,
  ) {
    emit(state.copyWith(
      filteredExpenses: state.expenses,
      searchQuery: '',
      clearDateFrom: true,
      clearDateTo: true,
      clearCategory: true,
    ));
  }
}
