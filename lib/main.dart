import 'package:expense_tracker/core/theme/app_theme.dart';
import 'package:expense_tracker/data/datasourse/hive_service.dart';
import 'package:expense_tracker/data/models/expense_model.dart';
import 'package:expense_tracker/data/repository/expense_repository_impl.dart';
import 'package:expense_tracker/domain/repository/expense_repository.dart';
import 'package:expense_tracker/presentation/error_app.dart';
import 'package:expense_tracker/presentation/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  ExpenseRepository? repository;
  String? initError;

  try {
    await Hive.initFlutter();

    Hive.registerAdapter(ExpenseModelAdapter());

    await Hive.openBox<ExpenseModel>("expense");

    repository = ExpenseRepositoryImpl(HiveService());
  } catch (e) {
    initError = e.toString();
  }

  if (repository != null) {
    runApp(MyApp(repository: repository));
  } else {
    runApp(ErrorApp(error: initError ?? 'Unknown initialization error'));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({required this.repository, super.key});

  final ExpenseRepository repository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: repository,
      child: MaterialApp(
        title: 'Expense Tracker',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: const Scaffold(body: HomeContainer()),
      ),
    );
  }
}
