import 'package:expense_tracker/core/network/app.dart';
import 'package:expense_tracker/data/datasourse/hive_service.dart';
import 'package:expense_tracker/data/models/expense_model.dart';
import 'package:expense_tracker/data/repository/expense_repository_impl.dart';
import 'package:expense_tracker/domain/repository/expense_repository.dart';
import 'package:expense_tracker/presentation/error_app.dart';
import 'package:flutter/material.dart';
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
    runApp(await appBuilder(expenseRepository: repository));
  } else {
    runApp(ErrorApp(error: initError ?? 'Unknown initialization error'));
  }
}
