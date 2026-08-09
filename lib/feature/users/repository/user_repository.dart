import 'package:expense_tracker/feature/users/model/user_model.dart';
import 'package:dartz/dartz.dart';

abstract class UserRepository {
  Future<Either<String, List<UserModel>>> getUsers();
}
