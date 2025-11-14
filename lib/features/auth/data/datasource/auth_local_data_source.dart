import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/types/auth_messages_ios.dart';
import 'package:lotus_news/features/auth/data/models/auth_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> signInWithBiometric() => throw UnimplementedError('Stub');
  Future<bool> isAuthenticated() => throw UnimplementedError('Stub');
  Future<bool> signOut() => throw UnimplementedError('Stub');
  Future<String?> getAccessToken() => throw UnimplementedError('Stub');
  Future<String?> getAuthorizationHeader() => throw UnimplementedError('Stub');
  Future<void> saveAuthUser(AuthModel auth) => throw UnimplementedError('Stub');
  Future<void> saveToken(String token) => throw UnimplementedError('Stub');
  Future<void> clearUser() => throw UnimplementedError('Stub');
  Future<void> clearToken() => throw UnimplementedError('Stub');
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static final String _isAuthenticated = 'isBiometricAuthenticated';
  static final String _accessToken = 'accessToken';
  static final String _authUser = 'authUser';

  LocalAuthentication auth = LocalAuthentication();
  bool _authenticated = false;

  @override
  Future<void> signInWithBiometric() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _authenticated = await auth.authenticate(
        localizedReason: 'Quét vân tay của bạn hoặc FaceID để xác thực',
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: 'Xác thực bằng vân tay',
            cancelButton: 'Cancel',
            biometricHint: 'Đặt ngón tay của bạn trên nút cảm biến vân tay',
            // Add other Android-specific messages as needed
          ),
          IOSAuthMessages(
            cancelButton: 'Dismiss',
            // Add other iOS-specific messages as needed
          ),
        ],
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      debugPrint('check authenticated status: $_authenticated');
      prefs.setBool(_isAuthenticated, _authenticated);
    } on PlatformException {
      throw Exception('Something went wrong');
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await getAccessToken();
    debugPrint('token here: $token');
    return token != null;
  }

  @override
  Future<bool> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_isAuthenticated, false);
    await clearToken();
    await clearUser();
    return true;
  }

  @override
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_accessToken);
    return token;
  }

  @override
  Future<String?> getAuthorizationHeader() async {
    final token = await getAccessToken();
    if (token != null && token.isNotEmpty) {
      return 'Bearer $token';
    }
    return null;
  }

  @override
  Future<void> saveAuthUser(AuthModel auth) async {
    final prefs = await SharedPreferences.getInstance();
    final userString = jsonEncode(auth.toJson());
    await prefs.setString(_authUser, userString);
  }

  @override
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessToken, token);
  }

  @override
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessToken);
  }

  @override
  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authUser);
  }
}
