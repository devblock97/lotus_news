import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:lotus_news/features/auth/data/models/user_model.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tUserModel = UserModel(
    avatar: 'User avatar',
    createdAt: "2025-09-21T16:15:50.458007Z",
    email: 'mobiletestingapp01@gmail.com',
    id: '95a7c9cf-a052-4bfe-bacc-940a0e56040e',
    username: 'mobile03',
  );

  test('should be a UserModel', () async {
    expect(tUserModel, isA<UserModel>());
  });

  test('should return valid model when JSON is a User', () async {
    // Arrange
    final Map<String, dynamic> mapJson = jsonDecode(fixture('user.json'));

    // Action
    final result = UserModel.fromJson(mapJson);

    // Assert
    expect(tUserModel, result);
  });

  test('should return valid model when toJson is a User', () async {
    // Arrange
    final Map<String, dynamic> toJson = tUserModel.toJson();

    // Action
    final result = {
      'avatar': 'User avatar',
      'created_at': "2025-09-21T16:15:50.458007Z",
      'email': 'mobiletestingapp01@gmail.com',
      'id': '95a7c9cf-a052-4bfe-bacc-940a0e56040e',
      'username': 'mobile03',
    };

    // Assert
    expect(toJson, result);
  });
}
