import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/network/api_clent.dart';
import 'package:expense_tracker/core/network/api_exception.dart';
import 'package:expense_tracker/feature/users/model/user_model.dart';
import 'package:expense_tracker/feature/users/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final ApiClient _apiClient;

  const UserRepositoryImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<Either<String, List<UserModel>>> getUsers() async {
    try {
      const url = '/users';

      final response = await _apiClient.get<List<dynamic>>(url);

      final data = response.data;

      if (data == null) {
        return const Left('No users found');
      }

      final users = data
          .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return Right(users);
    } on ApiException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
