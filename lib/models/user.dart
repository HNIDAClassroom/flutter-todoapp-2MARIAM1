class User {
  final String username;
  final String password;
  final String fullName;

  User({
    required this.username,
    required this.password,
    required this.fullName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      password: json['password'],
      fullName: json['fullName'],
    );
  }
}
