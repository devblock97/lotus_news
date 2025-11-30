import 'package:fpdart/fpdart.dart';
import 'package:lotus_news/core/exceptions/failure.dart';
import 'package:lotus_news/features/auth/data/datasource/auth_local_data_source.dart';
import 'package:lotus_news/features/auth/domain/repositories/auth_storage_repository.dart';

class AuthStorageRepositoryImpl implements AuthStorageRepository {
  final AuthLocalDataSource _localDataSource;

  AuthStorageRepositoryImpl(this._localDataSource);

  @override
  Future<Either<Failure, String?>> getAccessToken() async {
    final token = await _localDataSource.getAccessToken();
    if (token != null) {
      return Right(token);
    } else {
      return Left(
        Failure.fromOffline(RetrieveException('Failed to retrieved token')),
      );
    }
  }

  @override
  Future<Either<Failure, String?>> getAuthorizationHeader() async {
    final accessToken = await _localDataSource.getAccessToken();
    if (accessToken != null) {
      return Right('Bearer $accessToken');
    } else {
      return Left(
        Failure.fromOffline(RetrieveException('Token không tồn tại')),
      );
    }
  }
}
