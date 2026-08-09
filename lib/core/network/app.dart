import 'package:expense_tracker/core/app_routes.dart';
import 'package:expense_tracker/core/network/api_clent.dart';
import 'package:expense_tracker/domain/repository/expense_repository.dart';
import 'package:expense_tracker/feature/users/repository/user_repository.dart';
import 'package:expense_tracker/feature/users/repository/user_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class App extends StatelessWidget {
  const App({super.key, required this.initialLocation});

  final String initialLocation;

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: initialLocation,
      routes: AppRoutes.routes,
      errorBuilder: (context, state) => Scaffold(
        appBar: AppBar(title: const Text('Page not found')),
        body: Center(child: Text(state.error.toString())),
      ),
    );

    return MaterialApp.router(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      routerConfig: router,
    );
  }
}

Future<Widget> appBuilder({
  required ExpenseRepository expenseRepository,
  UserRepository? userRepository,
}) async {
  final apiClient = ApiClient();

  final userRepositoryInstance =
      userRepository ?? UserRepositoryImpl(apiClient: apiClient);

  return MultiRepositoryProvider(
    providers: [
      RepositoryProvider<ExpenseRepository>.value(value: expenseRepository),
      RepositoryProvider<UserRepository>.value(value: userRepositoryInstance),
    ],
    child: App(initialLocation: AppRoutes.launch.path),
  );
}
