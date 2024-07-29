part of 'user_bloc.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<User> users;
  final List<User> filteredUsers;
  final int currentPage;

  UserLoaded(this.users, this.filteredUsers, this.currentPage);
}

class UserError extends UserState {
  final String message;

  UserError(this.message);
}
