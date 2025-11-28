import 'package:flutter/widgets.dart';
import 'package:lotus_news/core/usecases/usecase.dart';
import 'package:lotus_news/features/auth/data/models/auth_model.dart';
import 'package:lotus_news/features/auth/data/models/password_update_model.dart';
import 'package:lotus_news/features/auth/domain/usecases/authenticated_usecase.dart';
import 'package:lotus_news/features/auth/domain/usecases/change_password_usecase.dart';
import 'package:lotus_news/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:lotus_news/features/auth/domain/usecases/sign_out_usecase.dart';

class AuthViewModel extends ChangeNotifier {
  AuthState _state = AuthInitialize();

  AuthState get state => _state;

  final SignInUseCase _signInUseCase;
  final SignOutUseCase _signOutUseCase;
  final AuthenticatedUseCase _authenticated;
  final ChangePasswordUseCase _changePasswordUseCase;
  AuthViewModel(
    this._signInUseCase,
    this._signOutUseCase,
    this._authenticated,
    this._changePasswordUseCase,
  );

  Future<void> signIn(String email, String password) async {
    _state = SignOutLoading();
    notifyListeners();
    try {
      final response = await _signInUseCase.call(
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
      final response = await _signOutUseCase.call(NoParams());
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
      final response = await _authenticated.call(NoParams());
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

  Future<void> changePassword(String oldPass, String newPass) async {
    _state = ChangePasswordProcessing();
    notifyListeners();
    try {
      final response = await _changePasswordUseCase.call(
        ChangePasswordParam(oldPass: oldPass, newPass: newPass),
      );
      debugPrint('check point 1');
      response.fold(
        (error) {
          _state = ChangePasswordError(
            error.message ?? 'Something went wrong. Please try again',
          );
        },
        (success) {
          _state = ChangePasswordSuccess(data: success);
        },
      );
      debugPrint('check point 2');
      notifyListeners();
    } catch (e) {
      _state = ChangePasswordError(e.toString());
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

class ChangePasswordProcessing extends AuthState {}

class ChangePasswordSuccess extends AuthState {
  final PasswordUpdateModel data;
  ChangePasswordSuccess({required this.data});
}

class ChangePasswordError extends AuthState {
  final String? message;
  ChangePasswordError(this.message);
}
