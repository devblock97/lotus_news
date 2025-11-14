import 'package:fpdart/fpdart.dart';
import 'package:lotus_news/core/exceptions/failure.dart';

abstract class AuthStorageRepository {
  Future<Either<Failure, String?>> getAuthorizationHeader() =>
      throw UnimplementedError('Stub');
  Future<Either<Failure, String?>> getAccessToken() =>
      throw UnimplementedError('Stub');
}
