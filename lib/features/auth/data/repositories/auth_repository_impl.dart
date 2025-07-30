
import 'package:fpdart/fpdart.dart';
import 'package:tma_news/core/exceptions/failure.dart';
import 'package:tma_news/features/auth/data/datasource/auth_local_data_source.dart';
import 'package:tma_news/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {

  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl(this.localDataSource);

  @override
  bool get isBiometricAuthenticated => localDataSource.isBiometricAuthenticated;

  @override
  Future<Either<Failure, void>> signIn() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> signInWithThirdParty() {
    throw UnimplementedError('signInWithThirdParty() has implement yet');
  }

  @override
  Future<Either<Failure, bool>> signOut() async {
    try {
      final response = await localDataSource.signOut();
      return Right(response);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<Either<Failure, void>> signInWithBiometrics() async {
    try {
      final response = await localDataSource.signInWithBiometric();
      return Right(response);
    } catch (_) {
      rethrow;
    }
  }

}