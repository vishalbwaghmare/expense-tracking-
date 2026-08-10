part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();
}

final class OnInit extends UserEvent {
  @override
  List<Object?> get props => [];
}

final class OnGetUsers extends UserEvent {
  @override
  List<Object?> get props => [];
}
