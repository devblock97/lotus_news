class UserModel {
  final String avatar;
  final String createdAt;
  final String email;
  final String id;
  final String username;

  const UserModel({
    required this.avatar,
    required this.createdAt,
    required this.email,
    required this.id,
    required this.username,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      avatar: json['avatar'],
      createdAt: json['created_at'],
      email: json['email'],
      id: json['id'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() => {
    'avatar': avatar,
    'created': createdAt,
    'email': email,
    'id': id,
    'username': username,
  };
}
