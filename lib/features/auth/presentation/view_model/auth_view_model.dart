import 'package:flutter/widgets.dart';
import 'package:lotus_news/core/usecases/usecase.dart';
import 'package:lotus_news/features/auth/data/models/auth_model.dart';
import 'package:lotus_news/features/auth/domain/usecases/authenticated_usecase.dart';
import 'package:lotus_news/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:lotus_news/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:lotus_news/injector.dart';

class AuthViewModel extends ChangeNotifier {
  AuthState _state = AuthInitialize();

  AuthState get state => _state;

  SignInUseCase signInUseCase = SignInUseCase(injector());
  SignOutUseCase signOutUseCase = SignOutUseCase(injector());
  Authenticated authenticated = Authenticated(injector());

  Future<void> signIn(String email, String password) async {
    _state = SignOutLoading();
    notifyListeners();
    try {
      final response = await signInUseCase.call(
        SignInParam(email: email, password: password),
      );
      response.fold(
        (error) {
          _state = SignInError();
        },
        (data) {
          _state = SignInSuccess(authModel: data);
        },
      );
      notifyListeners();
    } catch (e) {
      _state = SignInError();
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

  Future<void> isAuthenticated() async {
    try {
      final response = await authenticated.call(NoParams());
      response.fold(
        (error) {
          _state = AuthenticatedError();
        },
        (authenticated) {
          if (authenticated) {
            _state = HasAuthenticated();
          } else {
            _state = UnAuthenticated();
          }
        },
      );
      notifyListeners();
    } catch (e) {
      _state = AuthenticatedError();
      notifyListeners();
    }
  }
}

abstract class AuthState {}

class AuthInitialize extends AuthState {}

class SignInSuccess extends AuthState {
  final AuthModel authModel;
  SignInSuccess({required this.authModel});
}

class SignInLoading extends AuthState {}

class SignInError extends AuthState {}

class SignOutSuccess extends AuthState {
  final bool isSignedOut;
  SignOutSuccess(this.isSignedOut);
}

class SignOutLoading extends AuthState {}

class SignOutError extends AuthState {}

class HasAuthenticated extends AuthState {}

class UnAuthenticated extends AuthState {}

class AuthenticatedError extends AuthState {
  final String? message;
  AuthenticatedError({this.message});
}
