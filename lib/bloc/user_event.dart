part of 'user_bloc.dart';

abstract class UserEvent {}

// Event for fetching user
class FetchUsers extends UserEvent {
  final int page;

  FetchUsers(this.page);
}


// Event for filtering 
class FilterUsers extends UserEvent {
  // final String? country;
  final String? gender;

  FilterUsers({ this.gender});
}
