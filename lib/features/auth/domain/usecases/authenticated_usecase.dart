import 'package:fpdart/fpdart.dart';
import 'package:lotus_news/core/exceptions/failure.dart';
import 'package:lotus_news/core/usecases/usecase.dart';
import 'package:lotus_news/features/auth/domain/repositories/auth_repository.dart';

class Authenticated extends UseCase<bool, NoParams> {
  final AuthRepository _repository;
  Authenticated(this._repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return _repository.isAuthenticated();
  }
}
