import 'package:expense_tracker/feature/users/presentation/bloc/user_bloc.dart';
import 'package:expense_tracker/feature/users/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc(context.read<UserRepository>()),
      child: Users(),
    );
  }
}

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return ListView.builder(
          itemCount: state.users.length,
          itemBuilder: (context, index) {
            final user = state.users[index];
            return ListTile(
              contentPadding: EdgeInsets.all(14),
              title: Text(user.name),
              subtitle: Text(user.company.name),
            );
          },
        );
      },
    );
  }
}
