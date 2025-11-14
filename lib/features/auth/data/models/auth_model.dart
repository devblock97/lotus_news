import 'package:lotus_news/features/auth/data/models/user_model.dart';

class AuthModel {
  final String token;
  final UserModel user;

  const AuthModel({required this.token, required this.user});

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      token: json['token'],
      user: UserModel.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() => {'token': token, 'user': user.toJson()};
}
