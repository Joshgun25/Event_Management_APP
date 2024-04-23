class User {
  final int id;
  final String email;
  final String avatarUrl;

  User({
    required this.id,
    required this.email,
    required this.avatarUrl,

  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      avatarUrl: json['avatar_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'avatar_url': avatarUrl,
    };
  }
}
