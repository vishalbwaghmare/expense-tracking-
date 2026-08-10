import 'package:expense_tracker/core/theme/app_theme.dart';
import 'package:expense_tracker/core/utils/app_utils.dart';
import 'package:expense_tracker/data/models/expense_model.dart';
import 'package:expense_tracker/domain/repository/expense_repository.dart';
import 'package:expense_tracker/feature/users/presentation/users.dart';
import 'package:expense_tracker/presentation/bloc/expense_bloc.dart';
import 'package:expense_tracker/presentation/widgets/add_edit_expense_dialog.dart';
import 'package:expense_tracker/presentation/widgets/dashboard_widget.dart';
import 'package:expense_tracker/presentation/widgets/expense_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeContainer extends StatelessWidget {
  const HomeContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = ExpenseBloc(context.read<ExpenseRepository>());
        bloc.add(LoadExpenses());
        return bloc;
      },
      child: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();
  bool showDashboard = true;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _showAddExpenseDialog() async {
    final result = await showDialog<ExpenseModel>(
      context: context,
      builder: (context) => const AddEditExpenseDialog(),
    );

    if (result != null && mounted) {
      // ignore: use_build_context_synchronously
      context.read<ExpenseBloc>().add(AddExpense(result));
      _showSuccessSnackBar('Expense added successfully');
    }
  }

  void _showEditExpenseDialog(ExpenseModel expense) async {
    final result = await showDialog<ExpenseModel>(
      context: context,
      builder: (context) => AddEditExpenseDialog(expense: expense),
    );

    if (result != null && mounted) {
      // ignore: use_build_context_synchronously
      context.read<ExpenseBloc>().add(UpdateExpense(result));
      _showSuccessSnackBar('Expense updated successfully');
    }
  }

  void _showDeleteConfirmation(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Expense?'),
        content: const Text('Are you sure you want to delete this expense?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<ExpenseBloc>().add(DeleteExpense(id));
              Navigator.pop(context);
              _showSuccessSnackBar('Expense deleted successfully');
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppTheme.dangerColor),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.successColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UsersScreen()),
                  );
                },
                child: Text(
                  'Balance',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (context, state) {
          switch (state.status) {
            case ExpenseStatus.initial:
              return const SizedBox();

            case ExpenseStatus.loading:
              return const Center(child: CircularProgressIndicator());

            case ExpenseStatus.success:
              return _buildSuccessBody(context, state);

            case ExpenseStatus.failure:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: AppTheme.dangerColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.errorMessage ?? "Something went wrong",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ExpenseBloc>().add(LoadExpenses());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddExpenseDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Add Expense'),
      ),
    );
  }

  Widget _buildSuccessBody(BuildContext context, ExpenseState state) {
    if (state.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 64,
              color: AppTheme.primaryColor.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No expenses yet',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first expense to get started',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _showAddExpenseDialog(),
              icon: const Icon(Icons.add),
              label: const Text('Add First Expense'),
            ),
          ],
        ),
      );
    }

    final displayExpenses = state.filteredExpenses.isNotEmpty
        ? state.filteredExpenses
        : state.expenses;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Dashboard Section
          if (showDashboard) const DashboardWidget(),

          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onChanged: (query) {
                if (query.isEmpty) {
                  context.read<ExpenseBloc>().add(ClearFilters());
                } else {
                  context.read<ExpenseBloc>().add(SearchExpenses(query));
                }
              },
              decoration: InputDecoration(
                hintText: 'Search expenses...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          searchController.clear();
                          context.read<ExpenseBloc>().add(ClearFilters());
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // Expense List Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Transactions',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                if (state.hasActiveFilters && state.filteredExpenses.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      context.read<ExpenseBloc>().add(ClearFilters());
                      searchController.clear();
                    },
                    child: Text(
                      'Clear filters',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Expense List
          if (displayExpenses.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Icon(
                    Icons.search_off,
                    size: 48,
                    color: AppTheme.primaryColor.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No expenses found',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: displayExpenses.length,
                itemBuilder: (context, index) {
                  final expense = displayExpenses[index];
                  return ExpenseCard(
                    expense: expense,
                    onTap: () {
                      // Show expense details
                      _showExpenseDetails(context, expense);
                    },
                    onEdit: () {
                      _showEditExpenseDialog(expense);
                    },
                    onDelete: () {
                      _showDeleteConfirmation(context, expense.id);
                    },
                  );
                },
              ),
            ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  void _showExpenseDetails(BuildContext context, ExpenseModel expense) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.only(top: 5, right: 24, left: 24, bottom: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                alignment: Alignment.center,
                child: Divider(color: AppTheme.dividerColor, thickness: 3),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Expense Details',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _DetailRow(label: 'Title', value: expense.title),
            const SizedBox(height: 12),
            _DetailRow(
              label: 'Amount',
              value: AppUtils.formatCurrency(expense.amount),
            ),
            const SizedBox(height: 12),
            _DetailRow(label: 'Category', value: expense.category),
            const SizedBox(height: 12),
            _DetailRow(label: 'Date', value: AppUtils.formatDate(expense.date)),
            const SizedBox(height: 12),
            _DetailRow(label: 'Time', value: AppUtils.formatTime(expense.date)),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showEditExpenseDialog(expense);
                    },
                    child: const Text('Edit'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
