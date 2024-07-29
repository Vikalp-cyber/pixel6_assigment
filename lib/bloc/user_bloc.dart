import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pixel6_assigment/models/user.dart';
import 'package:pixel6_assigment/services/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository; // Repository to fetch user data
  List<User> _allUsers = []; // Cache for all users fetched from the repository
  String? _selectedGender; // Cached gender filter value

  UserBloc(this.userRepository) : super(UserInitial()) {
    // Event handlers for fetching users and filtering users
    on<FetchUsers>(_onFetchUsers);
    on<FilterUsers>(_onFilterUsers);
  }

  // Event handler for fetching users
  Future<void> _onFetchUsers(FetchUsers event, Emitter<UserState> emit) async {
    emit(UserLoading()); // Emit loading state
    try {
      // Fetch users from the repository for the requested page
      final users = await userRepository.fetchUsers(event.page);
      _allUsers = users; // Cache the fetched users
      // Apply current filters to the newly fetched users
      final filteredUsers = _applyFilters(users);
      // Emit the loaded state with the full and filtered list of users
      emit(UserLoaded(_allUsers, filteredUsers, event.page));
    } catch (e) {
      // Emit error state if there's an exception
      emit(UserError(e.toString()));
    }
  }

  // Event handler for filtering users
  void _onFilterUsers(FilterUsers event, Emitter<UserState> emit) {
    final currentState = state;
    if (currentState is UserLoaded) {
      _selectedGender = event.gender; // Update the cached gender filter
      print(event.gender); // Debug print statement to check selected gender
      // Apply filters to the cached list of all users
      final filteredUsers = _applyFilters(_allUsers);
      // Emit the updated state with the full list and filtered list of users
      emit(UserLoaded(_allUsers, filteredUsers, currentState.currentPage));
    }
  }

  // Apply gender filter to the list of users
  List<User> _applyFilters(List<User> users) {
    return users.where((user) {
      // Check if the user's gender matches the selected gender filter
      final matchesGender =
          _selectedGender == null || user.gender == _selectedGender;
      return matchesGender; // Return true if the user matches the filter
    }).toList(); // Convert the filtered iterable to a list
  }
}
