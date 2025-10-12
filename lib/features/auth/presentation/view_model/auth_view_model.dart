import 'package:flutter/widgets.dart';
import 'package:lotus_news/core/usecases/usecase.dart';
import 'package:lotus_news/features/auth/domain/usecases/authenticated_usecase.dart';
import 'package:lotus_news/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:lotus_news/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:lotus_news/injector.dart';

class AuthViewModel extends ChangeNotifier {
  AuthState _state = AuthInitialize();

  AuthState get state => _state;

  bool get isAuthenticated => authenticated.isAuthenticated();

  SignInUseCase signInUseCase = SignInUseCase(injector());
  SignOutUseCase signOutUseCase = SignOutUseCase(injector());
  Authenticated authenticated = Authenticated(injector());

  Future<void> signInWithBiometric() async {
    debugPrint('trigger sign in with biometric');
    _state = SignInLoading();
    try {
      final response = await signInUseCase.call(NoParams());
      response.fold(
        (error) {
          _state = SignInError();
        },
        (success) {
          _state = SignInSuccess();
        },
      );
    } catch (e) {
      _state = SignInError();
    } finally {
      notifyListeners();
    }
  }

  Future<void> signOUt() async {
    try {
      final response = await signOutUseCase.call(NoParams());
      response.fold(
        (error) {
          _state = SignOutError();
        },
        (data) {
          _state = SignOutSuccess(data);
        },
      );
    } catch (e) {
      _state = SignOutError();
    } finally {
      notifyListeners();
    }
  }
}

abstract class AuthState {}

class AuthInitialize extends AuthState {}

class SignInSuccess extends AuthState {}

class SignInLoading extends AuthState {}

class SignInError extends AuthState {}

class SignOutSuccess extends AuthState {
  final bool isSignedOut;
  SignOutSuccess(this.isSignedOut);
}

class SignOutLoading extends AuthState {}

class SignOutError extends AuthState {}
