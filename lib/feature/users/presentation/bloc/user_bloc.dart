import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_tracker/feature/users/model/user_model.dart';
import 'package:expense_tracker/feature/users/repository/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _repository;

  UserBloc(this._repository) : super(UserState.initial()) {
    on<OnInit>(_onInitEvent);
    on<OnGetUsers>(_onGetUsersEvent);
    add(OnInit());
  }

  void _onInitEvent(OnInit event, Emitter<UserState> emit) {
    add(OnGetUsers());
  }

  Future<void> _onGetUsersEvent(
    OnGetUsers event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await _repository.getUsers();

    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, errorMessage: failure));
      },
      (users) {
        emit(state.copyWith(isLoading: false, users: users));
      },
    );
  }
}
