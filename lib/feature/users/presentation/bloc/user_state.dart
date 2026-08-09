part of 'user_bloc.dart';

class UserState extends Equatable {
  final List<UserModel> users;
  final bool isLoading;
  final String? errorMessage;

  const UserState({
    required this.users,
    this.isLoading = false,
    this.errorMessage,
  });

  factory UserState.initial() {
    return const UserState(users: [], isLoading: false, errorMessage: null);
  }

  UserState copyWith({
    List<UserModel>? users,
    bool? isLoading,
    String? errorMessage,
  }) {
    return UserState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [users, isLoading, errorMessage];
}
