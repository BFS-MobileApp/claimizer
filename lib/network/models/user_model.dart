class User {
  final String userId;
  final String name;
  final String email;
  final String photo;
  final String phone;

  User({
    required this.userId,
    required this.name,
    required this.email,
    required this.photo,
    required this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      photo: json['photo'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userid': userId,
      'name': name,
      'email': email,
      'photo': photo,
      'phone': phone,
    };
  }
}