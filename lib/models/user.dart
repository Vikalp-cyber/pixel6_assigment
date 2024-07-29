class User {
  final int id;
  final String firstName;
  final String lastName;
  final String image;
  final String gender;
  final String designation;
  final String location;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.image,
    required this.gender,
    required this.designation,
    required this.location,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      image: json['image'],
      gender: json['gender'],
      designation: json['company']['title'],
      location: json['address']['city'],
    );
  }
}
