import 'package:fpdart/fpdart.dart';
import 'package:lotus_news/core/exceptions/failure.dart';
import 'package:lotus_news/core/usecases/usecase.dart';
import 'package:lotus_news/features/auth/domain/repositories/auth_repository.dart';

class SignInUseCase extends UseCase<void, NoParams> {
  final AuthRepository _repository;
  SignInUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return _repository.signInWithBiometrics();
  }
}
