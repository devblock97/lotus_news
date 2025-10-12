import 'package:lotus_news/features/auth/domain/repositories/auth_repository.dart';

class Authenticated {
  final AuthRepository _repository;
  Authenticated(this._repository);

  bool isAuthenticated() {
    return _repository.isBiometricAuthenticated;
  }
}
