import 'package:flutter/material.dart';
import 'package:lotus_news/core/constants/app_constants.dart';
import 'package:lotus_news/core/network/client.dart';
import 'package:lotus_news/features/auth/data/models/auth_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthModel> signIn(String email, String password) =>
      throw UnimplementedError('Stub');
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Client _client;
  const AuthRemoteDataSourceImpl(this._client);

  @override
  Future<AuthModel> signIn(String email, String password) async {
    try {
      final response = await _client.post(
        AppConstants.login,
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final authModel = AuthModel.fromJson(response.data);
        return authModel;
      }

      throw Exception('Something went wrong. Please try again!');
    } catch (e, stackTrace) {
      debugPrint('AuthRemoteDataSourceImpl [signIn]: $stackTrace');
      throw Exception('Something went wrong. Please try again!');
    }
  }
}
