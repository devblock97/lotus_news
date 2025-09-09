import 'package:fpdart/fpdart.dart';
import 'package:lotus_news/core/exceptions/failure.dart';

abstract class AuthRepository {

  Future<Either<Failure, void>> signIn() => throw UnimplementedError('Stub');

  Future<Either<Failure, bool>> signOut() => throw UnimplementedError('Stub');

  Future<Either<Failure, void>> signInWithBiometrics() => throw UnimplementedError('Stub');

  Future<Either<Failure, void>> signInWithThirdParty() => throw UnimplementedError('Stub');

  bool get isBiometricAuthenticated;
}