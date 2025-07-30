import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/types/auth_messages_ios.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> signInWithBiometric() => throw UnimplementedError('Stub');
  bool get isBiometricAuthenticated => throw UnimplementedError('Stub');
  Future<bool> signOut() => throw UnimplementedError('Stub');
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {

  static final String _isBiometricAuthenticated = 'isBiometricAuthenticated';

  bool _isAuthenticating = false;
  LocalAuthentication auth = LocalAuthentication();
  bool _authenticated = false;


  @override
  Future<void> signInWithBiometric() async {
    try {
      _isAuthenticating = true;
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
          biometricOnly: true
        )
      );
      debugPrint('check authenticated status: $_authenticated');
      prefs.setBool(_isBiometricAuthenticated, _authenticated);
      _isAuthenticating = false;
    } on PlatformException catch (e) {
      _isAuthenticating = false;
    }
  }

  @override
  bool get isBiometricAuthenticated => _authenticated;

  @override
  Future<bool> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_isBiometricAuthenticated, false);
    return true;
  }

}