import 'dart:convert';
import 'package:pixel6_assigment/models/user.dart';
import 'package:http/http.dart' as http;

class UserRepository {
  final String apiUrl = 'https://dummyjson.com/users'; // Base URL for the user API

  // Fetch a list of users from the API for a specific page
  Future<List<User>> fetchUsers(int page) async {
    final int limit = 10; // Number of users per page
    final int skip = (page - 1) * limit; // Calculate the number of users to skip based on the current page

    // Send an HTTP GET request to fetch users with pagination
    final response = await http.get(Uri.parse('$apiUrl?skip=$skip&limit=$limit'));

    // Check if the HTTP response status code is 200 (OK)
    if (response.statusCode == 200) {
      // Decode the JSON response body
      List jsonResponse = json.decode(response.body)['users'];
      // Map each JSON object to a User model and return the list
      return jsonResponse.map((user) => User.fromJson(user)).toList();
    } else {
      // Throw an exception if the response status code is not 200
      throw Exception('Failed to load users');
    }
  }
}
