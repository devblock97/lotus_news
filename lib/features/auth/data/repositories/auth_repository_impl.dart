import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:lotus_news/core/exceptions/failure.dart';
import 'package:lotus_news/core/network/network_info.dart';
import 'package:lotus_news/features/auth/data/datasource/auth_local_data_source.dart';
import 'package:lotus_news/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:lotus_news/features/auth/data/models/auth_model.dart';
import 'package:lotus_news/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(
    this._networkInfo,
    this._remoteDataSource,
    this._localDataSource,
  );

  @override
  Future<Either<Failure, bool>> isAuthenticated() async {
    try {
      final response = await _localDataSource.isAuthenticated();
      return Right(response);
    } catch (e) {
      return Left(
        Failure.fromOffline(RetrieveException('Something went wrong!')),
      );
    }
  }

  @override
  Future<Either<Failure, AuthModel>> signIn(
    String email,
    String password,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.signIn(email, password);
        await _localDataSource.saveAuthUser(response);
        await _localDataSource.saveToken(response.token);
        await _localDataSource.isAuthenticated();
        return Right(response);
      } on DioException catch (e) {
        return Left(Failure.fromNetwork(e));
      }
    } else {
      return Left(
        Failure(message: 'No internet connection. Please check internet again'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> signInWithThirdParty() {
    throw UnimplementedError('signInWithThirdParty() has implement yet');
  }

  @override
  Future<Either<Failure, bool>> signOut() async {
    try {
      final response = await _localDataSource.signOut();
      return Right(response);
    } catch (_) {
      return Left(
        Failure.fromOffline(RetrieveException('Something went wrong')),
      );
    }
  }

  @override
  Future<Either<Failure, void>> signInWithBiometrics() async {
    try {
      final response = await _localDataSource.signInWithBiometric();
      return Right(response);
    } catch (_) {
      rethrow;
    }
  }
}
