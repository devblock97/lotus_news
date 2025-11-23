import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:lotus_news/features/auth/data/models/auth_model.dart';
import 'package:lotus_news/features/auth/data/models/user_model.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tUserModel = UserModel(
    avatar: 'https://avatar.com',
    createdAt: "2025-09-21T16:15:50.458007Z",
    email: 'mobiletestingapp01@gmail.com',
    id: '95a7c9cf-a052-4bfe-bacc-940a0e56040e',
    username: 'mobile03',
  );
  final tAuthModel = AuthModel(token: 'abc123', user: tUserModel);

  group('fromJson', () {
    test('should return valid model when JSON is a Auth', () {
      // Arrange
      final Map<String, dynamic> mapJson = jsonDecode(fixture('auth.json'));

      // Action
      final result = AuthModel.fromJson(mapJson);

      // Assert
      expect(tAuthModel, result);
    });
  });

  group('toJson', () {
    test('should return valid model when toJson is a Auth', () async {
      // Arrange
      final Map<String, dynamic> toJson = tAuthModel.toJson();

      // Action
      final result = {
        "token": "abc123",
        "user": {
          "avatar": "https://avatar.com",
          "created_at": "2025-09-21T16:15:50.458007Z",
          "email": "mobiletestingapp01@gmail.com",
          "id": "95a7c9cf-a052-4bfe-bacc-940a0e56040e",
          "username": "mobile03",
        },
      };

      // Assert
      expect(result, toJson);
    });
  });
}
