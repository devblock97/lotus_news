import 'package:fpdart/src/either.dart';
import 'package:lotus_news/core/exceptions/failure.dart';
import 'package:lotus_news/core/usecases/usecase.dart';
import 'package:lotus_news/features/auth/domain/repositories/auth_repository.dart';

class Authenticated {
  final AuthRepository _repository;
  Authenticated(this._repository);

  bool isAuthenticated()  {
    return _repository.isBiometricAuthenticated;
  }

}