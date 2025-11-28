import 'package:fpdart/fpdart.dart';
import 'package:lotus_news/core/exceptions/failure.dart';
import 'package:lotus_news/features/auth/data/models/auth_model.dart';
import 'package:lotus_news/features/auth/data/models/password_update_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthModel>> signIn(String email, String password) =>
      throw UnimplementedError('Stub');

  Future<Either<Failure, bool>> signOut() => throw UnimplementedError('Stub');

  Future<Either<Failure, void>> signInWithBiometrics() =>
      throw UnimplementedError('Stub');

  Future<Either<Failure, void>> signInWithThirdParty() =>
      throw UnimplementedError('Stub');

  Future<Either<Failure, bool>> isAuthenticated() =>
      throw UnimplementedError('Stub');

  Future<Either<Failure, PasswordUpdateModel>> changePassword(
    String oldPass,
    String newPass,
  ) => throw UnimplementedError('Change password not implemented');
}
