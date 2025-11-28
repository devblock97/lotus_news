import 'package:equatable/equatable.dart';

class PasswordUpdateModel extends Equatable {
  final String userId;
  final String message;

  const PasswordUpdateModel({required this.userId, required this.message});

  factory PasswordUpdateModel.fromJson(Map<String, dynamic> json) {
    return PasswordUpdateModel(
      userId: json['user_id'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() => {'user_id': userId, 'message': message};

  @override
  List<Object?> get props => [userId, message];
}
